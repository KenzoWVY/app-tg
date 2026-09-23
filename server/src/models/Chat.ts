import mongoose, { Document, Schema, Types } from 'mongoose';

export interface IAlignment {
  sourceWord: string;
  targetWord: string;
  sourceStartIndex: number;
  sourceEndIndex: number;
  targetStartIndex: number;
  targetEndIndex: number;
}

export interface IChat extends Document {
  userId: Types.ObjectId;
  sourceLanguage: string;
  targetLanguage: string;
  sourceText: string;
  translatedText: string;
  title: string;
  alignments: IAlignment[];
  createdAt: Date;
}

const chatSchema = new Schema<IChat>({
  userId: { 
    type: Schema.Types.ObjectId, 
    ref: 'User', 
    required: true 
  },
  sourceLanguage: { type: String },
  targetLanguage: { type: String, required: true },
  sourceText: { type: String, required: true },
  translatedText: { type: String, required: true },
  title: { type: String, required: true },
  
  alignments: [{
    sourceWord: { type: String, required: true },
    targetWord: { type: String, required: true },
    sourceStartIndex: { type: Number, required: true },
    sourceEndIndex: { type: Number, required: true },
    targetStartIndex: { type: Number, required: true },
    targetEndIndex: { type: Number, required: true }
  }],
  
  createdAt: { type: Date, default: Date.now }
});

export default mongoose.model<IChat>('Chat', chatSchema);