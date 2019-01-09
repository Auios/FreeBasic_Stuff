#include once "win/winsock2.bi"

type TcpServer
    as socket sock
    as uinteger port
    
    declare function start(port as uinteger) as boolean
end type

function TcpServer.start(port as uinteger) as boolean
    if(NOT port) then return false
    this.port = port
    
    dim as WSAData wsad
    if( WSAStartup( MAKEWORD( 2, 2 ), @wsad ) <> 0 ) then return false
    if( wsad.wVersion <> MAKEWORD( 2, 2 ) ) then
        WSACleanup()
        return false
    end if
    
    sock = WSASocket(AF_INET, SOCK_STREAM, IPPROTO_TCP, NULL, NULL, NULL)
    if( sock = NULL ) then
        WSACleanup()
        return false
    end if
    
    dim sa as sockaddr_in
    sa.sin_port         = htons( port )
    sa.sin_family       = AF_INET
    sa.sin_addr.S_addr  = INADDR_ANY
    if(bind( sock, cptr( PSOCKADDR, @sa ), len( sa ) ) = SOCKET_ERROR) then
        WSACleanup()
        return false
    end if
    
    if(listen(sock, SOMAXCONN) = SOCKET_ERROR) then
        WSACleanup()
        return false
    end if
    
    return true
end function

