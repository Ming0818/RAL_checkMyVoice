function ral_initialize
%RAL_INITIALIZE Initilaze "ral_" files if they don't exist
%   Check if the file exists.
%   If not, the software will create them

    clear
    clc
    fprintf('======================================\n');
    fprintf('\t RAL - Check My Voice\n');
    fprintf('======================================\n');
    
    
    ral_settings_init(); 
    ral_db_users_init();
    ral_db_mfcc_init();
    
    % Add libraries
    addpath('libs/')
end

