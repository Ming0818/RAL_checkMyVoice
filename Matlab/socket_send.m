function socket_send( p_ip, p_port, p_message )
%socket_send Function sending a string message with TCP/IP socket
    
    t = tcpip(p_ip, p_port);
    fopen(t);  
    fprintf(t, strcat(p_message, '$ \t\n\r'))
    
    fclose(t);
    delete(t);
    clear t;
    
    fprintf('INFO : SENDING SOCKET TO %s:%i ; message = %s\n', p_ip, p_port, p_message);
end

