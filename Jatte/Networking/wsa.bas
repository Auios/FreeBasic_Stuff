_print "Starting WSA..."


if( WSAStartup( MAKEWORD( 1, 1 ), @wsaData ) <> 0 ) then
    color 12: db("ERROR: WSAStartup failed"): color 7
    sleep
    end
end if


_print "Creating listener socket..."
With Connection(0)
    .socket_in.sin_port = htons( UIC_GetInteger("Server", "Port") )
    .socket_in.sin_family = AF_INET
    .socket_in.sin_addr.S_addr = INADDR_ANY
    .socket=opensocket(AF_INET, SOCK_STREAM, 0)
    if .socket=INVALID_SOCKET then
        color 12: _print "ERROR: Unable to open server socket.": color 7
        sleep
        end
    end if
    if bind(.socket, cptr(sockaddr ptr, @.socket_in), len(.socket_in)) then
        color 12: _print "ERROR: Unable to bind listening socket. "& WSAGetLastError(): color 7
        sleep
        end
    end if
    'listen(.socket, SOMAXCONN)
    if listen(.socket, 8) then
        color 12: _print "ERROR: Unable to initiate listen. "& WSAGetLastError(): color 7
        sleep
        end
    end if
end with
