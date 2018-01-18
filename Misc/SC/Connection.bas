#pragma once

type Connection
    as socket sock
    as integer IP
    as ulong port
    
    declare sub startServer(port as ulong = 28000)
    declare sub startClient()
    declare sub shutDown()
    declare function connect(sIP as string, port as ulong) as integer
    declare sub close()
end type

sub Connection.startServer(port as ulong)
    with this
        hStart()
        .port = port
        .sock = hOpen()
        hBind(.sock,.port)
        hListen(.sock)
    end with
end sub

sub Connection.startClient()
    with this
        hStart()
        .sock = hOpen()
    end with
end sub

sub Connection.shutDown()
    this.close()
    hShutdown()
end sub

function Connection.connect(sIP as string, port as ulong) as integer
    dim as integer bytesIn
    with this
        .IP = hResolve(sIP)
        bytesIn = hConnect(.sock,.IP,.port)
    end with
    return bytesIn
end function

sub Connection.close()
    with this
        hClose(.sock)
        .sock = 0
    end with
end sub