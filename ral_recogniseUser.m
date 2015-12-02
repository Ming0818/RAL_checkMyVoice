function [ userPseudo ] = ral_recogniseUser( p_audioFile )
%RAL_RECOGNISEUSER Summary of this function goes here
%   Detailed explanation goes here
    
    % Features extraction
    fprintf('Features extraction from %s\n', p_audioFile{1});
    load('ral_settings.mat');
    [audioData, sampleRate] = audioread(strcat(settings.path_audio_inputs, p_audioFile{1}));
    features = sound_getFeatures(audioData, sampleRate);
    % Recognize with a neural network
    tic;
    [userId,score] = ral_getRecognizeNNResults(features);
    toc;
    time=toc/3;
    disp(time);
    fprintf('RAL : ID = %s, SCORE = %s\n', num2str(userId), num2str(score));
    
    % If the score is higher than 0.700 (recognize_user_threshold), then
    % it's not an anonymous
    userPseudo = 'anonymous';
    if score > settings.recognize_user_threshold
        % Get the user's pseudo
        [ idUser, userPseudo ] = user_getUserByID(userId);
    end
end

