import { GoogleGenAI } from '@google/genai';

export const quizService = async (
    sourceText: string, 
    translatedText: string, 
    sourceLanguage: string,
    targetLanguage: string
) => {
    const googleKey = process.env.GEMINI_API_KEY || '';

    if (googleKey === '') {
        throw new Error('Google Gemini API key is not configured.');
}
    const ai = new GoogleGenAI({ apiKey: googleKey });
    const modelName = process.env.GEMINI_MODEL || 'gemini-3.5-flash';
    const prompt = `
    You are an expert language learning assistant. 
    - The user's native/source language is: "${sourceLanguage}" (e.g., pt for Portuguese).
    - The target language they are learning is: "${targetLanguage}" (e.g., de for German).

    Based on the source text and its translation below, generate 4 multiple-choice comprehension and vocabulary questions.

    Translated Text (${targetLanguage}): "${translatedText}"

    CRITICAL RULES FOR THE RESPONSE:
    1. The "question" text must be written entirely in "${sourceLanguage}".
    2. The "options" array must contain 4 choices relevant to the target language ("${targetLanguage}").
    3. The "explanation" must be written entirely in "${sourceLanguage}".

    Provide a strict JSON array response where each object contains:
    - "question": a clear question testing a word or phrase from the target text
    - "options": an array of 4 possible answer choices (strings)
    - "correctIndex": the 0-based integer index of the correct option in the array
    - "explanation": a brief explanation of why the answer is correct (in the source text language)
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

        return JSON.parse(response.text);
    } catch (error: any) {
        throw new Error(`Quiz generation failed: ${error.message || 'AI service error'}`);
    }
};