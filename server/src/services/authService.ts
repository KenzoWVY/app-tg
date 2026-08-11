import User from '../models/user.js';
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

    const jwtKey = process.env.JWT_KEY;
    if (!jwtKey) {
        throw new Error('JWT secret key is not defined in environment variables.');
    }
    const token = jwt.sign({ userId: user._id }, jwtKey, { expiresIn: '7d' });

    return { user, token };
}