import * as sdk from 'microsoft-cognitiveservices-speech-sdk';

export const synthesizeSpeechService = async (
    text: string, 
    voiceName: string = 'en-US-AndrewMultilingualNeural'
): Promise<Buffer> => {
    const speechKey = process.env.AZURE_SPEECH_KEY;
    const serviceRegion = process.env.AZURE_SPEECH_REGION;

    if (!speechKey) {
        throw new Error('Azure Speech key is not configured.');
    }

    if (!serviceRegion) {
        throw new Error('Azure Speech region is not configured.');
    }

    const speechConfig = sdk.SpeechConfig.fromSubscription(speechKey, serviceRegion);
    speechConfig.speechSynthesisVoiceName = voiceName;
    speechConfig.speechSynthesisOutputFormat = sdk.SpeechSynthesisOutputFormat.Audio16Khz32KBitRateMonoMp3;

    const synthesizer = new sdk.SpeechSynthesizer(speechConfig, undefined);

    return new Promise((resolve, reject) => {
        synthesizer.speakTextAsync(
            text,
            (result) => {
                synthesizer.close();
                if (result.reason === sdk.ResultReason.SynthesizingAudioCompleted) {
                    resolve(Buffer.from(result.audioData));
                } else {
                    reject(new Error(`Speech synthesis failed: ${result.errorDetails}`));
                }
            },
            (error) => {
                synthesizer.close();
                reject(error);
            }
        );
    });
};