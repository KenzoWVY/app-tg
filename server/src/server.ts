import app from './app.js';
import express from 'express';
import dotenv from 'dotenv';
import { databaseConnection } from './config/databaseConnection.js';

dotenv.config();

const PORT = 3000;

const startServer = async () => {
    app.listen(PORT, () => {
        console.log('Server running.');
    });

    await databaseConnection();
};

startServer();