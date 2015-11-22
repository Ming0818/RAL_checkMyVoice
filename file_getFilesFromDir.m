function [ fileList ] = file_getFilesFromDir( p_dir )
%FILE_GETFILESFROMDIR Summary of this function goes here
%   Detailed explanation goes here
    
    fprintf('Get all files recursively from the directory : %s\n', p_dir);
    % Get the data for the current directory
    dirData = dir(p_dir);
    % Find the index for directories
    dirIndex = [dirData.isdir];
    % Get a list of the files
    fileList = {dirData(~dirIndex).name}';  
    if ~isempty(fileList)
        % Prepend path to files
        fileList = cellfun(@(x) fullfile(p_dir,x), fileList, 'UniformOutput',false);
    end
    
    % Get a list of the subdirectories
    subDirs = {dirData(dirIndex).name};  
    % Find index of subdirectories that are not '.' or '..'
    validIndex = ~ismember(subDirs,{'.','..'});  
    
    % Loop over valid subdirectories
    for iDir = find(validIndex)
        % Get the subdirectory path
        nextDir = fullfile(p_dir,subDirs{iDir});    
        % Recursively call the function
        fileList = [fileList; getAllFiles(nextDir)];  
    end
end

