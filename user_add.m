function user_add( p_userPseudo )
%USER_ADD Add a user in ral_users.xml
%   Detailed explanation goes here

    % load users database
    load('ral_settings.mat');
    load(settings.path_user_database);
    
    % Create ID user
    nbLines = size(users, 1);
    if nbLines == 0
        % Init the first user ID
        userID = 1;
    else
        % Find the last user ID and add 1
        lastID = users{nbLines, 1};
        userID = lastID + 1;
    end
    
    % Save user ID with pseudo
    users{userID, 1} = userID;
    users{userID, 2} = p_userPseudo;
    save(settings.path_user_database, 'users', '-append');
    
    fprintf('ADD : user %s (id_user %i) added.\n', p_userPseudo, userID);
end

