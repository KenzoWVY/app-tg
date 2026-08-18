import mongoose, { Schema, Document } from 'mongoose';

export interface IUser extends Document {
    email: string;
    passwordHash: string;
    refreshToken?: string;
}

const UserSchema: Schema = new Schema({
    email: { type: String, required: true, unique: true },
    passwordHash: { type: String, required: true },
    refreshToken: { type: String, default: null },
}, { timestamps: true });

export default mongoose.model<IUser>('User', UserSchema);