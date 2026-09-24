import axios from 'axios';
import Chat, { IAlignment } from '../models/Chat.js';
import { GoogleGenAI } from '@google/genai';

interface AzureAlignmentResponse {
  translations: {
    text: string;
    to: string;
    alignment?: {
      proj: string;
    };
  }[];
}

const parseAlignments = (alignmentProj: string, sourceText: string, translatedText: string): IAlignment[] => {
  if (!alignmentProj) return [];

  const alignments: IAlignment[] = [];
  const pairs = alignmentProj.trim().split(' ');

  for (const pair of pairs) {
    const [sourceRange, targetRange] = pair.split('-');
    if (!sourceRange || !targetRange) continue;

    const [sourceStart, sourceEnd] = sourceRange.split(':').map(Number);
    const [targetStart, targetEnd] = targetRange.split(':').map(Number);

    if (
      sourceStart === undefined || sourceEnd === undefined ||
      targetStart === undefined || targetEnd === undefined ||
      isNaN(sourceStart) || isNaN(sourceEnd) ||
      isNaN(targetStart) || isNaN(targetEnd)
    ) continue;

    const sourceWord = sourceText.substring(sourceStart, sourceEnd + 1);
    const targetWord = translatedText.substring(targetStart, targetEnd + 1);

    if (!sourceWord || !targetWord || !sourceWord.trim() || !targetWord.trim()) {
      continue;
    }
    
    alignments.push({
      sourceWord,
      targetWord,
      sourceStartIndex: sourceStart,
      sourceEndIndex: sourceEnd,
      targetStartIndex: targetStart,
      targetEndIndex: targetEnd,
    });
  }

  return alignments;
};

export const translateAndSaveService = async (
  userId: string,
  sourceText: string,
  targetLanguage: string,
  sourceLanguage?: string,
  title?: string
) => {
  const apiKey = process.env.AZURE_TRANSLATOR_KEY;
  const region = process.env.AZURE_TRANSLATOR_REGION;
  const endpoint = process.env.AZURE_TRANSLATOR_ENDPOINT || 'https://api.cognitive.microsofttranslator.com';

  if (!apiKey) {
    throw new Error('Azure Translator key is not configured.');
  }

  const cleanEndpoint = endpoint.replace(/\/+$/, '');

  let url: string;
  const headers: Record<string, string> = {
    'Ocp-Apim-Subscription-Key': apiKey,
    'Ocp-Apim-Region': region || '',
    'Content-Type': 'application/json',
  };

  url = `${cleanEndpoint}/translator/text/v3.0/translate?api-version=3.0&to=${targetLanguage}${sourceLanguage ? `&from=${sourceLanguage}` : ''}&includeAlignment=true`;

  let azureResponse;
  try {
      azureResponse = await axios.post<AzureAlignmentResponse[]>(
        url,
        [{ Text: sourceText }],
        { headers }
      );
  } catch (error: any) {
      throw new Error(`Azure API Failed: ${error.response?.data?.error?.message || error.message}`);
  }

  const translationResult = azureResponse.data?.[0]?.translations?.[0];
  if (!translationResult) {
    throw new Error('Failed to retrieve translation from Azure.');
  }

  const translatedText = translationResult.text;
  const alignmentProj = translationResult.alignment?.proj || '';

  const alignments = parseAlignments(alignmentProj, sourceText, translatedText);
  const chatTitle = title || (sourceText.length > 30 ? `${sourceText.substring(0, 30)}...` : sourceText);

  const newChat = await Chat.create({
    userId,
    sourceLanguage: sourceLanguage || 'auto',
    targetLanguage,
    sourceText,
    translatedText,
    title: chatTitle,
    alignments,
  });

  return newChat;
};

export const lookupWordService = async (word: string, contextSentence: string, sourceLanguage: string, targetLanguage: string) => {
  const googleKey = process.env.GEMINI_API_KEY || '';
  const modelName = process.env.GEMINI_MODEL || 'gemini-3.5-flash-lite';
  const ai = new GoogleGenAI({ apiKey: googleKey });
  if (!word) {
      throw new Error('Word is required for lookup.');
  }

  const prompt = `
    You are a helpful dictionary and language learning assistant.
    - The user's native/spoken language is: "${sourceLanguage}".
    - The language of the word being looked up is: "${targetLanguage}".
    
    Analyze the word "${word}" in the context of this sentence: "${contextSentence}".

    Provide a strict JSON response with the following fields and NO markdown formatting or extra text outside the JSON:
    - "word": the base or inflected form of the word being explained (in "${targetLanguage}")
    - "translation": the translation of the word IN "${sourceLanguage}" (the user's native language)
    - "partOfSpeech": noun, verb, adjective, etc.
    - "gender": grammatical gender if applicable (e.g., masculine, feminine, neuter, or null)
    - "definition": a brief definition or usage explanation written entirely in "${sourceLanguage}"
    - "example": a short example sentence using this word written entirely in "${targetLanguage}"
    `;

  try {
      const response = await ai.models.generateContent({
          model: modelName,
          contents: prompt,
          config: {
              responseMimeType: 'application/json',
          },
      });

      if (!response.text) {
          throw new Error('No response received from AI model.');
      }

      return JSON.parse(response.text.trim());
  } catch (error: any) {
      console.error('[AI Lookup Error]:', error.message || error);
      throw new Error(`AI lookup failed: ${error.message}`);
  }
};