import express, { Router } from 'express';
import { lookupWord } from '../controllers/translationController.js';
import { requireAuth } from '../middleware/authMiddleware.js';

const router: Router = express.Router();

router.post('/lookup', requireAuth, lookupWord);

export default router;