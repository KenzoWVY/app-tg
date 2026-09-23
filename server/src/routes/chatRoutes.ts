import express, { Router } from 'express';
import { createTranslationChat, getUserChats } from '../controllers/chatController.js';
import { requireAuth } from '../middleware/authMiddleware.js';

const router: Router = express.Router();

router.use((req, res, next) => {
  next();
});

router.post('/', requireAuth, createTranslationChat);
router.get('/', requireAuth, getUserChats);

export default router;