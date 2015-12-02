% MAIN file for the NAO project
clear;
clc;

% =========================================================================
%   Initialize all required files
% =========================================================================
ral_initialize();
load('ral_settings.mat');

if exist(settings.path_socket_files_to_download, 'file') == 2
    % Download files from NAO
    daemonAction = ftp_getFiles();
    
    % Get the MFCC
    if strcmp(daemonAction, 'train')
        fprintf('DAEMON : train');
        audioFiles = file_getFilesForAction(daemonAction);
        for audioFile = audioFiles
            % === Init user : add the user if not created ===
            user_initUser(audioFile{3});
            % === Add MFCC to the database ===
            mfcc_add(audioFile);
            % === Delete the training file ===
            file_deleteInputFile(audioFile{1});
        end
        
        % Train the Neural Network
        nn_trainWithMFCC();
    elseif strcmp(daemonAction, 'recognize')
        fprintf('DAEMON : recognize');
        % === Get the audio file with the prefix "recognize"
        audioFile = file_getFilesForAction(daemonAction);
        
        % Get the saved users' MFCC
        inputsPath = settings.path_audio_inputs;
        
        % === Try to recognize the user with this audio file
        userPseudo = ral_recogniseUser(audioFile);
        
        % === Send the user to NAO
        fprintf('DAEMON : Recognized user : %s\n', userPseudo);
        
        % === Delete the audio file
    	file_deleteInputFile(audioFile{1});
    else
        fprintf('DAEMON : nothing to do');
        pause(1);
    end
    
else
    fprintf('DAEMON : ERROR, %s not loaded\n',settings.path_socket_files_to_download);
end
    