import request from 'supertest';
import mongoose from 'mongoose';
import { MongoMemoryServer } from 'mongodb-memory-server';
import app from '../../src/app.js';
import User from '../../src/models/User.js';

describe('Auth Integration Tests', () => {
    let mongoServer: MongoMemoryServer;

    beforeAll(async () => {
        mongoServer = await MongoMemoryServer.create();
        await mongoose.connect(mongoServer.getUri());
        process.env.JWT_KEY = 'jwtTestKey';
    });

    afterEach(async () => {
        await User.deleteMany({});
    });

    afterAll(async () => {
        await mongoose.connection.close();
        await mongoServer.stop();
    });

    describe('POST /api/auth/register', () => {
        test('should register a new user', async () => {
            const res = await request(app)
                .post('/api/auth/register')
                .send({ email: 'testUser@testEmail.com',
                        password: 'testPassword' });

            expect(res.status).toBe(201);
            expect(res.body.newUser).toHaveProperty('email', 'testUser@testEmail.com');

            const userInDb = await User.findOne({ email: 'testUser@testEmail.com' });
            expect(userInDb).not.toBeNull();
        });
    });

    describe('POST /api/auth/login', () => {
        test('should authenticate user and return token and refreshToken', async () => {
            await request(app)
                .post('/api/auth/register')
                .send({ email: 'testUser@testEmail.com',
                        password: 'testPassword' });

            const res = await request(app)
                .post('/api/auth/login')
                    .send({ email: 'testUser@testEmail.com',
                            password: 'testPassword' });

            expect(res.status).toBe(200);
            expect(res.body).toHaveProperty('token');
            expect(res.body).toHaveProperty('refreshToken');
        });
    });

    describe('POST /api/auth/refresh', () => {
        test('should return new access token', async () => {
            await request(app)
                .post('/api/auth/register')
                .send({ email: 'testUser@testEmail.com',
                        password: 'testPassword' });
            
            const loginRes = await request(app)
                .post('/api/auth/login')
                .send({ email: 'testUser@testEmail.com',
                        password: 'testPassword' });

            const refreshRes = await request(app)
                .post('/api/auth/refresh')
                .send({ refreshToken: loginRes.body.refreshToken });

            expect(refreshRes.status).toBe(200);
            expect(refreshRes.body.result).toHaveProperty('accessToken');
        });
    });

    describe('GET /api/auth/userinfo', () => {
        test('should return user information', async () => {
            await request(app)
                .post('/api/auth/register')
                .send({ email: 'testUser@testEmail.com',
                        password: 'testPassword' });

            const loginRes = await request(app)
                .post('/api/auth/login')
                .send({ email: 'testUser@testEmail.com',
                        password: 'testPassword' });

            const userInfoRes = await request(app)
                .get('/api/auth/me')
                .set('Authorization', `Bearer ${loginRes.body.token}`);
            
            expect(userInfoRes.status).toBe(200);
            expect(userInfoRes.body.user).toHaveProperty('email', 'testUser@testEmail.com');
        });
    });
});