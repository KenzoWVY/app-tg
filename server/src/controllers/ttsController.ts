import { Response } from 'express';
import { AuthRequest } from '../middleware/authMiddleware.js';
import { synthesizeSpeechService } from '../services/ttsService.js';

export const synthesizeAudio = async (req: AuthRequest, res: Response) => {
    try {
        const { text, voiceName } = req.body;

        if (!text) {
            return res.status(400).json({ error: 'Text parameter is required.' });
        }

        const audioBuffer = await synthesizeSpeechService(text, voiceName);

        res.setHeader('Content-Type', 'audio/mpeg');
        res.setHeader('Content-Length', audioBuffer.length);
        res.status(200).send(audioBuffer);
    } catch (error: any) {
        console.error('[TTS Error]:', error);
        res.status(500).json({ error: error.message || 'TTS synthesis failed' });
    }
};