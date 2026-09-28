import express, { Router } from 'express';
import { synthesizeAudio } from '../controllers/ttsController.js';
import { requireAuth } from '../middleware/authMiddleware.js';

const router: Router = express.Router();
router.post('/synthesize', requireAuth, synthesizeAudio);

export default router;