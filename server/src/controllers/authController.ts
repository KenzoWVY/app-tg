import { Response, Request } from 'express';

import { registerUser, authUser } from '../services/authService.js';

export const register = async (req: Request, res: Response) => {
    const { email, password } = req.body;

    const newUser = await registerUser(email, password);

    res.status(201).json({ newUser });
}

export const login = async (req: Request, res: Response) => {
    const { email, password } = req.body;

    const { user, token } = await authUser(email, password);

    res.status(200).json({ user, token });
}