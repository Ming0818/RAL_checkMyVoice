function ral_db_users_init( )
%RAL_DB_USERS_INIT Summary of this function goes here
%   Detailed explanation goes here


    dbUsersFile = 'ral_db_users.mat';
    
    if exist(dbUsersFile, 'file') == 0
        fprintf('CREATE : %s\n', dbUsersFile);
        
        users = {};
        
        save(dbUsersFile, 'users');
        while exist(dbUsersFile, 'file') == 0
            pause(0.5);
        end     
    else
        fprintf('%s is already created\n', dbUsersFile);
    end
end

