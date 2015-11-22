function file_deleteInputFile( p_fileName )
%FILE_DELETEINPUTFILE Delete a file in the input directory
%   Detailed explanation goes here
    
    load('ral_settings.mat');
    fullPath = strcat(settings.path_audio_inputs, p_fileName);
    fprintf('DELETE : input file : %s\n', fullPath);
    delete(fullPath);
end

