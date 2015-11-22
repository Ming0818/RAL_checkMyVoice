function ral_db_mfcc_init( )
%RAL_DB_MFCC_INIT Summary of this function goes here
%   Detailed explanation goes here

    dbMFCCFile = 'ral_db_mfcc.mat';
    
    if exist(dbMFCCFile, 'file') == 0
        fprintf('CREATE : %s\n', dbMFCCFile);
        
        mfcc_features_data = {};
        
        save(dbMFCCFile, 'mfcc_features_data');
        while exist(dbMFCCFile, 'file') == 0
            pause(0.5);
        end     
    else
        fprintf('%s is already created\n', dbMFCCFile);
    end
end

