import { Response } from 'express';
import { AuthRequest } from '../middleware/authMiddleware.js';
import Chat from '../models/Chat.js';
import { quizService } from '../services/quizService.js';
import { Types } from 'mongoose';

export const generateQuiz = async (req: AuthRequest, res: Response) => {
    try {
        const { chatId } = req.body;

        if (!chatId) {
            return res.status(400).json({ error: 'Chat ID is required to generate a questionnaire.' });
        }

        const chat = await Chat.findOne({ _id: new Types.ObjectId(chatId), userId: req.userId } as any);
        if (!chat) {
            return res.status(404).json({ error: 'Chat session not found.' });
        }

        const quizQuestions = await quizService(
            chat.sourceText,
            chat.translatedText,
            chat.sourceLanguage,
            chat.targetLanguage
        );

        res.status(200).json({ questions: quizQuestions });
    } catch (error: any) {
        console.error('[Quiz Controller Error]:', error);
        res.status(500).json({ error: error.message || 'Failed to generate quiz.' });
    }
};