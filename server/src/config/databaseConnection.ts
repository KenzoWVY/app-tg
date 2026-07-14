import mongoose from 'mongoose';

export const databaseConnection = async (): Promise<void> => {
    try {
        const mongoURI = 'mongodb://' + process.env.MONGO_ADMIN_USERNAME + ':' + process.env.MONGO_ADMIN_PASSWORD + '@localhost:27017/';
        const connection = await mongoose.connect(mongoURI);

        console.log('Connected successfully to MongoDB container:', connection.connection.host);

    } catch (error) {
        console.error('Error connecting to MongoDB container:', error);
        throw error;
    }
}