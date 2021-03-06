function ral_settings_init( )
%RAL_SETTINGS_INIT Init the setting file. It s deleted then created for a fresh
%start
    
    settingsFile = 'ral_settings.mat';
    
    if exist(settingsFile, 'file') == 0
        fprintf('CREATE : %s\n', settingsFile);
        
        % show windows for debugging phase ?
        settings(1).debug_mode = 0; 
        % main settings
        settings(1).path_audio_inputs = 'audio_inputs/';
        settings(1).path_user_database = 'ral_db_users.mat';
        settings(1).path_mfcc_database = 'ral_db_mfcc.mat';
        settings(1).path_socket_files_to_download = 'files_to_download.mat';
        settings(1).recognize_user_threshold = 0.700;
        
        settings(1).sample_rate_output = 16000;
        settings(1).slot_limit = 128;
        
        settings(1).trigger_cut_length = 0.9;
        settings(1).fir_filter_value = 0.97;
        settings(1).silence_threshold = 0.07;
        
        settings(1).net_hiddenSizes = 50; %30
        settings(1).net_trainParam_goal = 0.000000001;
        settings(1).net_trainParam_show = 100;
        settings(1).net_trainParam_epochs = 1000;
        settings(1).net_trainParam_mc = 0.95;
        
        save(settingsFile, 'settings');
        while exist(settingsFile, 'file') == 0
            pause(0.5);
        end
    else
        fprintf('%s is already created\n', settingsFile);
    end
    
    filesToDownloadMat = 'files_to_download.mat';
    if exist(filesToDownloadMat, 'file') == 0
        files_to_download = {};
        save(filesToDownloadMat, 'files_to_download');
        while exist(filesToDownloadMat, 'file') == 0
            pause(0.5);
        end
        fprintf('CREATE : %s\n', filesToDownloadMat);
    else
        fprintf('%s is already created\n', filesToDownloadMat);
    end
end

