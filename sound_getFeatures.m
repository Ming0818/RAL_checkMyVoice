function [ features ] = sound_getFeatures( audioData, sampleRate )
%AUDIO_GETFEATURES Calculate and get voice's features
%   Detailed explanation goes here
    
    features = [];
    
    sound               = double(audioData);
    % sampleRateOutput = sampleRateOutput8000;
    load('ral_settings.mat');
    sampleRateOutput	= settings.sample_rate_output;
    speechSignal = prepare_voix(sound, sampleRate, sampleRateOutput);
%     [normalized, slot]  = findvoice(sound, sampleRate, sampleRateOutput);
    
%     speechSignal = [];
%     slotSize = size(slot,1);
%     for iSlot=1:slotSize    
%         % slotLimit = 128
%         if slot(iSlot,2)-slot(iSlot,1)>=settings.slot_limit
%             % normalized: normalized sound
%             % slot:       slot(ii,1) start of sound sequence (the i-th one) of interest
%             %             slot(ii,2) end of sound sequence (the i-th one) of interest
%             partSignal = normalized(slot(iSlot,1):slot(iSlot,2));
%             speechSignal = [speechSignal; partSignal];
% %             coefficients = melcepst(speechSignal, sampleRateOutput, ['d']);
% %             features = [features; coefficients];
%         end
%     end
    features = melcepst(speechSignal, sampleRateOutput, ['d']);
%         features = [features; coefficients];
end

