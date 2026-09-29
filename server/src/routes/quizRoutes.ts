import express, { Router } from 'express';
import { generateQuiz } from '../controllers/quizController.js';
import { requireAuth } from '../middleware/authMiddleware.js';

const router: Router = express.Router();

router.post('/generate', requireAuth, generateQuiz);

export default router;