import { Response } from 'express';
import { Types } from 'mongoose';
import { AuthRequest } from '../middleware/authMiddleware.js';
import { translateAndSaveService } from '../services/translationService.js';
import Chat from '../models/Chat.js';

export const createTranslationChat = async (req: AuthRequest, res: Response) => {
    try {
        const userId = req.userId;
        if (!userId) {
            return res.status(401).json({ error: 'Unauthorized: User ID missing.' });
        }

        const { sourceText, targetLanguage, sourceLanguage, title } = req.body;

        if (!sourceText || !targetLanguage) {
            return res.status(400).json({ error: 'sourceText and targetLanguage are required.' });
        }

        const chat = await translateAndSaveService(
            userId,
            sourceText,
            targetLanguage,
            sourceLanguage,
            title
        );

        res.status(201).json({ chat });
    } catch (error: any) {
        res.status(500).json({ error: error.message });
    }
};

export const getUserChats = async (req: AuthRequest, res: Response) => {
    try {
        const userId = req.userId;
        if (!userId) {
            return res.status(401).json({ error: 'Unauthorized: User ID missing.' });
        }
        const chats = await Chat.find({ userId: new Types.ObjectId(userId) }).sort({ createdAt: -1 });
        res.status(200).json({ chats });
    } catch (error: any) {
        res.status(500).json({ error: error.message });
    }
};