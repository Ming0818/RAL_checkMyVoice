function user_initUser( p_userPseudo )
%USER_INITUSER Add a user in ral_users.xml if needed
%   p_userpseudo : the user pseudo added
    
    if user_isPseudoTaken(p_userPseudo)
        fprintf('INFO : the pseudo %s is already taken\n', p_userPseudo);
    else
        user_add( p_userPseudo );
    end
end
