import { Response, Request } from 'express';
import jwt from 'jsonwebtoken';

import { registerUser, authUser, refreshService} from '../services/authServices.js';

export const register = async (req: Request, res: Response) => {
    try {
        const { email, password } = req.body;
        const newUser = await registerUser(email, password);
        res.status(201).json({ newUser });
    } catch (error: any) {
        res.status(400).json({ error: error.message});
    }
}

export const login = async (req: Request, res: Response) => {
    try {
        const { email, password } = req.body;
        const { user, token, refreshToken } = await authUser(email, password);
        res.status(200).json({ user, token, refreshToken });
    } catch (error: any) {
        res.status(401).json({ error: error.message });
    }
}

export const refresh = async (req: Request, res: Response) => {
    try {
        const { refreshToken } = req.body;
        const newAccessToken = await refreshService(refreshToken);
        res.status(200).json({ token: newAccessToken });
    } catch (error: any) {
        res.status(403).json({ error: error.message });
    }
}