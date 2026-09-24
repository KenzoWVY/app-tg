import { Response } from 'express';
import { AuthRequest } from '../middleware/authMiddleware.js';
import { lookupWordService } from '../services/translationService.js';

export const lookupWord = async (req: AuthRequest, res: Response) => {
    try {
        const { word, contextSentence, sourceLanguage, targetLanguage } = req.body;

        if (!word) {
            return res.status(400).json({ error: 'Word parameter is missing.' });
        }

        const result = await lookupWordService(
            word, 
            contextSentence || '', 
            targetLanguage || '',
            sourceLanguage || ''
        );

        res.status(200).json(result);
    } catch (error: any) {
        res.status(500).json({ error: error.message });
    }
};