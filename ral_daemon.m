% MAIN file for the NAO project
clear;
clc;

% =========================================================================
%   Initialize all required files
% =========================================================================
ral_initialize();
load('ral_settings.mat');

if exist(settings.path_socket_files_to_download, 'file') == 2
    % Load the list of files to download from NAO
    load(settings.path_socket_files_to_download);
    fprintf('DAEMON : load %s\n',settings.path_socket_files_to_download);
    
    % Check if there is at least one entry
    if length(files_to_download) >= 1
        nbFilesToDownload = length(files_to_download) - 2;
        fprintf('DAEMON : %i files to download\n', nbFilesToDownload );
        
        % FTP Connexion
        naoHost = strcat(strcat(files_to_download{1}, ':'), num2str(files_to_download{2}));
        fprintf('FTP : host = %s\n', naoHost);
        ftpobj = ftp(naoHost,'kimsavin','Se8yBapG');
        % Move to dir
        cd(ftpobj, 'www/shared'); 

        for iColumn = 3:length(files_to_download)
            % Download
            fprintf('FTP : download %s\n', files_to_download{iColumn});
            mget(ftpobj, files_to_download{iColumn}, settings.path_audio_inputs);
            % Delete
            % delete(ftpobj, files_to_download{iColumn});
            fprintf('FTP : delete %s\n', files_to_download{iColumn});
        end

        % FTP Déconnexion
        close(ftpobj);
        fprintf('FTP : end\n');
    else
        fprintf('DAEMON : no files to download\n');
    end
else
    fprintf('DAEMON : ERROR, %s not loaded\n',settings.path_socket_files_to_download);
end
    