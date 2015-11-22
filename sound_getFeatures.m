function [ features ] = sound_getFeatures( audioData, sampleRate )
%AUDIO_GETFEATURES Calculate and get voice's features
%   Detailed explanation goes here
    
    features = [];
    sound = double(audioData);
    
    load('ral_settings.mat');
    sampleRateOutput	= settings.sample_rate_output;
    speechSignal = ral_prepare_sample(sound, sampleRate, sampleRateOutput);
    features = melcepst(speechSignal, sampleRateOutput, ['d']);
end

