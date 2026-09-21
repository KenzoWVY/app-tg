import dotenv from 'dotenv';
dotenv.config();

import app from './app.js';
import { databaseConnection } from './config/databaseConnection.js';

const PORT = 3000;

const startServer = async () => {
    app.listen(PORT, () => {
        console.log('Server running.');
    });

    await databaseConnection();
};

startServer();