function [daemonAction] = ftp_getFiles( )
%FTP_GETFILES Download audio samples from NAO
    
    % Load the list of files to download from NAO
    load('ral_settings.mat');
    load(settings.path_socket_files_to_download);
    fprintf('DAEMON : load %s\n',settings.path_socket_files_to_download);
    
    daemonAction = 'none';
    % Check if there is at least one corect entry
    if length(files_to_download) >= 3
        nbFilesToDownload = length(files_to_download) - 2;
        fprintf('DAEMON : %i files to download\n', nbFilesToDownload );
        
        % FTP Connexion
        naoHost = strcat(strcat(files_to_download{1}, ':'), num2str(files_to_download{2}));
        fprintf('FTP : host = %s\n', naoHost);
        ftpobj = ftp(naoHost,'kimsavin','Se8yBapG');
        % Move to dir
        cd(ftpobj, 'www/shared'); 

        for iColumn = 3:length(files_to_download)
            % Download the sample from NAO
            fprintf('FTP : download %s\n', files_to_download{iColumn});
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
        fprintf('DAEMON : %s',daemonAction);
        
        % Delete the line from files_to_download.mat
        files_to_download(1,:) = [];
        save(settings.path_socket_files_to_download, 'files_to_download', '-append');
    else
        fprintf('DAEMON : no files to download\n');
    end
end

