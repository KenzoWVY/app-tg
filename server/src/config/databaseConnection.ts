import mongoose from 'mongoose';

export const databaseConnection = async (): Promise<void> => {
    try {
        const mongoURI = process.env.MONGODB_URI || '';
        if (mongoURI === '') {
            throw new Error('MONGO_URI is not defined in the environment variables.');
        }
        const connection = await mongoose.connect(mongoURI);

        console.log('Connected successfully to MongoDB container: ', connection.connection.host);

    } catch (error) {
        console.error('Error connecting to MongoDB container:', error);
        throw error;
    }
}