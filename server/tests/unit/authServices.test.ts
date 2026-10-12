import mongoose from 'mongoose';
import { MongoMemoryServer } from 'mongodb-memory-server';
import { registerUser, authUser, refreshService, getUserInfo } from '../../src/services/authServices.js';
import User from '../../src/models/User.js';

describe('Auth Services', () => {
    let mongoServer: MongoMemoryServer;

    beforeAll(async () => {
        mongoServer = await MongoMemoryServer.create();
        await mongoose.connect(mongoServer.getUri());

        process.env.JWT_KEY = 'jwtTestKey';
        process.env.JWT_REFRESH_KEY = 'jwtRefreshTestKey';
    });

    afterEach(async () => {
        await User.deleteMany({});
    });

    afterAll(async () => {
        await mongoose.disconnect();
        await mongoServer.stop();
    });

    describe('registerUser', () => {
        test('should hash password and create new user', async () => {
            const email = 'testUser@testEmail.com';
            const password = 'testPassword';

            const newuser = await registerUser(email, password);

            expect(newuser).toBeDefined();
            expect(newuser.email).toBe(email);
            expect(newuser.passwordHash).not.toBe(password);
        })
    });

    describe('authUser', () => {
        test('should authenticate user and return token and refreshToken', async () => {
            const email = 'testUser@testEmail.com';
            const password = 'testPassword';

            await registerUser(email, password);

            const authResult = await authUser(email, password);

            expect(authResult).toBeDefined();
            expect(authResult.token).toBeDefined();
            expect(authResult.refreshToken).toBeDefined();
        });
    });

    describe('refreshService', () => {
        test('should return new access token', async () => {
            const email = 'testUser@testEmail.com';
            const password = 'testPassword';

            await registerUser(email, password);

            const authResult = await authUser(email, password);

            const newToken = await refreshService(authResult.refreshToken);

            expect(newToken).toBeDefined();
        });
    });

    describe('getUserInfo', () => {
        test('should return user information', async () => {
            const email = 'testUser@testEmail.com';
            const password = 'testPassword';

            const registeredUser = await registerUser(email, password);

            const userInfo = await getUserInfo(registeredUser._id.toString());

            expect(userInfo).toBeDefined();
            expect(userInfo.email).toBe(email);
        });
    });
});