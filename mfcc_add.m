function mfcc_add( p_audioFile )
%DBMFCC_ADD add mfcc in the databse with the id user linked
%   Detailed explanation goes here

    load('ral_settings.mat');
    
    % Load the audio file
    % [y,Fs] = audioread('aFile.wav');
    % y : audio data
    % Fs : sample rate
    [audioData, sampleRate] = audioread(strcat(settings.path_audio_inputs, p_audioFile{1}));
    if exist('audioData', 'var')
        fprintf('Features extraction from %s\n', p_audioFile{1});
        features = sound_getFeatures(audioData, sampleRate);
        % Save in ral_mfcc.mat the user id with the mfcc
        [ idUser, userPseudo ] = user_getUserByPseudo( p_audioFile{3} );
        if idUser > 0
            load(settings.path_mfcc_database);
            newFeaturesData{1,1} = idUser;
            newFeaturesData{1,2} = features;
            mfcc_features_data = [mfcc_features_data ; newFeaturesData];
            save(settings.path_mfcc_database', 'mfcc_features_data', '-append');
        end
    else
        fprintf('ERROR : can not read the file %s\n', p_audioFile{1});
    end
end

