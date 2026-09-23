import axios from 'axios';
import Chat, { IAlignment } from '../models/Chat.js';

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