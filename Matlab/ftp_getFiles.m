function [daemonAction] = ftp_getFiles( )
%FTP_GETFILES Download audio samples from NAO
    
    % Load the list of files to download from NAO
    load('ral_settings.mat');
    load(settings.path_socket_files_to_download);
    fprintf('DAEMON : load %s ; length = %i \n',settings.path_socket_files_to_download, length(files_to_download));
    
    daemonAction = 'none';
    % Check if there is at least one corect entry
    if length(files_to_download) >= 3
        nbFilesToDownload = length(files_to_download) - 2;
        fprintf('DAEMON : %i files to download\n', nbFilesToDownload );
        
        % FTP Connexion : TO BE SET
        naoHost = strcat(files_to_download{1}, ':21');
        fprintf('FTP : begin');
        fprintf('FTP : host = %s\n', naoHost);
        
        %ftpobj = ftp('169.254.51.53:22','nao','arnaud'); %TEST
        ftpobj = ftp(naoHost,'nao','arnaud');
        
        % Move to dir
        naoDirPath = 'recordings/microphones/';
        cd(ftpobj, naoDirPath);
        fprintf('FTP : move to = %s\n', naoDirPath);

        for iColumn = 3:length(files_to_download)
            % Download the sample from NAO
            fprintf('FTP : download %s\n in the directory %s', files_to_download{iColumn}, settings.path_audio_inputs);
            mget(ftpobj, files_to_download{iColumn}, settings.path_audio_inputs);
            % Delete the sample from NAO
            delete(ftpobj, files_to_download{iColumn});
            fprintf('FTP : delete %s\n', files_to_download{iColumn});
        end

        % FTP Déconnexion
        close(ftpobj);
        fprintf('FTP : end\n');
        
        
        % Get the next daemon action : train or recognize ?
        tmpData = strsplit(files_to_download{3},'_');
        daemonAction = tmpData{1};
        fprintf('DAEMON : output action = %s\n',daemonAction);
    else
        fprintf('DAEMON : no files to download\n');
    end
end

