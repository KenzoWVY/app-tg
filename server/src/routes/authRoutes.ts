import express, { Router } from 'express';

import { register, login, refresh, getUser } from '../controllers/authController.js';
import { requireAuth } from '../middleware/authMiddleware.js';

const router: Router = express.Router();

router.post('/register', register);
router.post('/login', login);
router.post('/refresh', refresh);
router.get('/me', requireAuth, getUser);

export default router;