function taken = user_isPseudoTaken( p_userPseudo )
%user_isPseudoTaken Check if a pseudo is already in the database
%   p_userpseudo : the users pseudo added
%   taken : boolean returned
    taken = false;
    
    load('ral_settings.mat');
    load(settings.path_user_database);
    
    nbLines = size(users, 1);
    if nbLines > 0
        if find(ismember( users(:,2), p_userPseudo)) > 0
            taken = true;
        end
    end
end