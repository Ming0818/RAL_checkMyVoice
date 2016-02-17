function [ idUser, userPseudo ] = user_getUserByID( p_userID )
%USER_GETUSERBYPSEUDO Get the users id and pseuo in database
%   Detailed explanation goes here
    
    load('ral_settings.mat');
    load(settings.path_user_database);
    
    idUser = 0;
    userPseudo = '';
    
    nbLines = size(users, 1);
    if nbLines > 0
        iLineUser = find(cell2mat(users(:,1)) == p_userID);
        if iLineUser > 0
            idUser =  users{iLineUser, 1};
            userPseudo =  users{iLineUser, 2};
        end
    end
    
    fprintf('GET : users %i %s\n', idUser, userPseudo);
end

