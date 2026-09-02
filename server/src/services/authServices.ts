import User from '../models/User.js';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';

export const registerUser = async (email: string, password: string) =>
{
    if (!email || !password) {
        throw new Error('Email and password are required.');
    }

    const existingUser = await User.findOne({ email });
    if (existingUser) {
        throw new Error('Email already in use.');
    }

    const saltRounds = 10;
    const hashedPassword = await bcrypt.hash(password, saltRounds);

    const newUser = await User.create({ email, passwordHash: hashedPassword });
    if (!newUser) {
        throw new Error('Failed to create user.');
    }

    return newUser;
}

export const authUser = async (email: string, password: string) =>  {
    if (!email || !password) {
        throw new Error('Email and password are required.');
    }

    const user = await User.findOne({ email });
    if (!user) {
        throw new Error('User not found.');
    }

    const isMatch = await bcrypt.compare(password, user.passwordHash);
    if (!isMatch) {
        throw new Error('Invalid password.');
    }

    const jwtSecretKey = process.env.JWT_KEY;
    if (!jwtSecretKey) {
        throw new Error('JWT secret key is not defined in environment variables.');
    }
    const token = jwt.sign({ userId: user._id }, jwtSecretKey, { expiresIn: '5m' });

    const jwtRefreshSecretKey = process.env.JWT_REFRESH_KEY;
    if (!jwtRefreshSecretKey) {
        throw new Error('JWT refresh secret key is not defined in environment variables.');
    }
    const refreshToken = jwt.sign({ userId: user._id }, jwtRefreshSecretKey, { expiresIn: '7d' });
    user.refreshToken = refreshToken;
    await user.save();

    return { user, token, refreshToken };
}

export const refreshService = async (refreshToken: string) => {
    if (!refreshToken) {
        throw new Error('Refresh token is required.');
    }

    const jwtRefreshSecretKey = process.env.JWT_REFRESH_KEY;
    if (!jwtRefreshSecretKey) {
        throw new Error('JWT refresh secret key is not defined in environment variables.');
    }

    let decodedToken;

    try {
        decodedToken = jwt.verify(refreshToken, jwtRefreshSecretKey) as { userId: string };
    } catch (error) {
        throw new Error('Invalid or expired refresh token.');
    }

    const user = await User.findById(decodedToken.userId);
    if (!user) {
        throw new Error('User not found.');
    }

    if (user.refreshToken !== refreshToken) {
        throw new Error('Invalid refresh token.');
    }

    const jwtSecretKey = process.env.JWT_KEY;
    if (!jwtSecretKey) {
        throw new Error('JWT secret key is not defined in environment variables.');
    }

    const newAccessToken = jwt.sign({ userId: user._id }, jwtSecretKey, { expiresIn: '5m' });
    return newAccessToken;
}

export const getUserInfo = async (userId: string) => {
    if (!userId) {
        throw new Error('User ID is required.');
    }

    const user = await User.findById(userId).select('-passwordHash -refreshToken');
    if (!user) {
        throw new Error('User not found.');
    }

    return user;
}