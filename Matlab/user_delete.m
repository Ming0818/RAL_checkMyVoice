function user_delete( p_userName )
%USER_DELETE Summary of this function goes here
%   Detailed explanation goes here

    load('ral_settings.mat');
    
    % Get user ID
    [ idUser, userPseudo ] = user_getUserByPseudo( p_userName );
    
    % Delete MFCC linked to the user
    mfcc_delete( idUser )
    
    % Delete the user 
    load(settings.path_user_database);
    nbLines = size(users, 1);
    if nbLines > 0
        iLineUser = find(cell2mat(users(:,1)) == idUser);
        if iLineUser > 0
            users(iLineUser,:) = [];
        end
    end
    save(settings.path_user_database, 'users', '-append');
    
    fprintf('DELETE : user %s\n', p_userName);
    
end

