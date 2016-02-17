function mfcc_delete( p_idUser )
%MFCC_DELETE Delete all lines from the mfcc database with the user ID
%   Detailed explanation goes here

    load('ral_settings.mat');
    load(settings.path_mfcc_database);
    
    nbLines = size(mfcc_features_data, 1);
    if nbLines > 0
        iLineUser = find(cell2mat(mfcc_features_data(:,1)) == p_idUser);
        if iLineUser > 0
            mfcc_features_data(iLineUser,:) = [];
        end
    end
    save(settings.path_mfcc_database, 'mfcc_features_data', '-append');
    
    fprintf('DELETE : mfcc for user ID %i\n', p_idUser);
end

