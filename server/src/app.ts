import dotenv from 'dotenv';

dotenv.config();

import express, { Application } from 'express';
import authRoutes from './routes/authRoutes.js';
import chatRoutes from './routes/chatRoutes.js';
import translationRoutes from './routes/translationRoutes.js';

const app: Application = express();

app.use(express.json());

app.use('/api/auth', authRoutes);
app.use('/api/chats', chatRoutes);
app.use('/api/translation', translationRoutes);

export default app;