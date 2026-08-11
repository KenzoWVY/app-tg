import express, { Application, Request, Response, NextFunction } from 'express';
import authRoutes from './routes/authRoutes.js';

const app: Application = express();

app.use(express.json());

app.use('/api/auth', authRoutes);

app.get('/', (req: Request, res: Response) => {
    res.send('Hello, World!');
});

export default app;