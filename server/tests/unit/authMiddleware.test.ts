import { Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import { requireAuth, AuthRequest } from '../../src/middleware/authMiddleware.js'; // Adjust path if needed

describe('Auth Middleware', () => {
  const secretKey = 'jwtTestKey';

  beforeAll(() => {
    process.env.JWT_KEY = secretKey;
  });

  test('should return 401 if authorization header is missing', () => {
    const req = { headers: {} } as AuthRequest;
    const res = {
      status: jest.fn().mockReturnThis(),
      json: jest.fn(),
    } as unknown as Response;
    const next = jest.fn() as NextFunction;

    requireAuth(req, res, next);

    expect(res.status).toHaveBeenCalledWith(401);
    expect(res.json).toHaveBeenCalledWith({ error: 'Unauthorized: No token provided' });
    expect(next).not.toHaveBeenCalled();
  });

  test('should return 401 if token is invalid or expired', () => {
    const req = {
      headers: { authorization: 'Bearer exampleinvalidtoken' },
    } as AuthRequest;
    const res = {
      status: jest.fn().mockReturnThis(),
      json: jest.fn(),
    } as unknown as Response;
    const next = jest.fn() as NextFunction;

    requireAuth(req, res, next);

    expect(res.status).toHaveBeenCalledWith(401);
    expect(res.json).toHaveBeenCalledWith({ error: 'Unauthorized: Invalid or expired token' });
    expect(next).not.toHaveBeenCalled();
  });

  test('should attach userId to req and call next() if token is valid', () => {
    const userId = '123456789abcdef123456789';
    const validToken = jwt.sign({ userId }, secretKey, { expiresIn: '30m' });

    const req = {
      headers: { authorization: `Bearer ${validToken}` },
    } as AuthRequest;
    const res = {
      status: jest.fn().mockReturnThis(),
      json: jest.fn(),
    } as unknown as Response;
    const next = jest.fn() as NextFunction;

    requireAuth(req, res, next);

    expect(req.userId).toBe(userId);
    expect(next).toHaveBeenCalledTimes(1);
    expect(res.status).not.toHaveBeenCalled();
  });
});