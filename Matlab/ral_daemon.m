% MAIN file for the NAO project
clear;
clc;

% =========================================================================
%   Initialize all required files
% =========================================================================
ral_initialize();
load('ral_settings.mat');

if exist(settings.path_socket_files_to_download, 'file') == 2
    % Download files from NAO : you need to set the FTP connexion
    daemonAction = ftp_getFiles();
    % daemonAction = 'recognize';
    %
    
    fprintf('DAEMON : daemonAction %s\n', daemonAction);
    
    % Get the MFCC
    if strcmp(daemonAction, 'train')
        fprintf('DAEMON : train');
         % === Get the audio file with the prefix "train"
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
        
        % === Delete the line from files_to_download.mat
        load(settings.path_socket_files_to_download); 
        files_to_download(1,:) = [];
        save(settings.path_socket_files_to_download, 'files_to_download', '-append');
    elseif strcmp(daemonAction, 'recognize')
        fprintf('DAEMON : recognize');
        % === Get the audio file with the prefix "recognize"
        audioFile = file_getFilesForAction(daemonAction);
        
        % Get the saved users' MFCC
        inputsPath = settings.path_audio_inputs;
        
        % === Try to recognize the user with this audio file
        try
            userPseudo = ral_recogniseUser(audioFile);
        catch
            userPseudo = 'inconnu';
        end
        
        % === Send the user to NAO
        fprintf('DAEMON : Recognized user : %s\n', userPseudo);
        load(settings.path_socket_files_to_download);        
        socket_send(files_to_download{1}, str2num(files_to_download{2}), userPseudo);
        
        % === Delete the audio file
    	file_deleteInputFile(audioFile{1});
        
        % === Delete the line from files_to_download.mat
        load(settings.path_socket_files_to_download); 
        files_to_download(1,:) = [];
        save(settings.path_socket_files_to_download, 'files_to_download', '-append');
    else
        fprintf('DAEMON : nothing to do');
        pause(1);
    end
    
else
    fprintf('DAEMON : ERROR, %s not loaded\n',settings.path_socket_files_to_download);
end
