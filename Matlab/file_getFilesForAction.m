function [ audioFiles ] = file_getFilesForAction( p_action )
%FILE_GETINPUTSAUDIOFILES Summary of this function goes here
%   p_action : "train" or "recognize"

    % This 2 values has been initiazed with the function ral_initiaze()
    load('ral_settings.mat');
    % Get all the input fils with the prefixe p_action : "train_" or "recognize"
    inputFiles = file_getFilesFromDir(settings.path_audio_inputs);
    if ~isempty(inputFiles)
       audioFiles = file_keepFilesForAction(p_action, settings.path_audio_inputs, inputFiles);
    end
end

function [ audioFiles ] = file_keepFilesForAction( p_action, p_inputsPath, p_files )

    audioFiles = [];
    % Remove the path of audio inputs to only keep the files name
    p_files = strrep(p_files, '\', '/'); % for windows only
    p_files = strrep(p_files, p_inputsPath, '');

    for iFile = 1:numel(p_files)
        % Decompose the file name to get informations
        fileData = file_getDataFromName(p_files{iFile});
        
        if ~isempty(fileData)
            % Check if the file is for the action
            if strcmp(fileData{2}, p_action)
                fprintf('%s : %s file for %s (%s)\n', upper(fileData{2}), fileData{5}, fileData{3}, fileData{4});
                audioFiles = [audioFiles, fileData];
            end
        end
    end 
end

function [ fileData ] = file_getDataFromName( p_fileName )   
    tmpData = strsplit(p_fileName,'_');
    
    if length(tmpData) < 3
        % the file name's format is incorrect, we delete the file
        fprintf('ERROR : the file name "%s" is incorrect\n', p_fileName);
        file_deleteInputFile(p_fileName);
        fileData = {};
    else
        % the file name is correct, we retrieve the data
        action = tmpData{1};
        user_pseudo = tmpData{2};

        fileEnd = strsplit(tmpData{3},'.');
        timestamp = fileEnd{1};
        extension = fileEnd{2};

        fileData = {p_fileName; action; user_pseudo; timestamp; extension};
    end
end