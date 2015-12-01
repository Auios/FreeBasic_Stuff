#define fbc -exx

#include "fbgfx.bi"
#include "wshelper.bas"

using fb

randomize timer

enum clientStatus
    waitAuth
    playing
end enum

type serverProp
    as integer sock
    as long port
    
    as ubyte clientCount,maxClients
    
    as ubyte cmd,sz
end type

type clientProp
    as socket sock
    as long ip,port
    as ubyte iresu
    
    as clientStatus status
    
    as ubyte ID
    as ubyte cmd,sz
    as short x,y
    
    as byte pong
    as double ping
end type

dim shared as ubyte map(1 to 50,1 to 20)

dim shared as serverProp sv
dim shared as clientProp cl(),tmpCl

declare sub init()
declare sub generateMap()

sub init()
    
    hStart()
    
    with sv
        .port = 28000
        .maxClients = 8
        
        .sock = hOpen()
        hBind(.sock,.port)
        hListen(.sock)
    end with
end sub

sub generateMap()
    var mapBias = 1
    
    for y as uinteger = lbound(map,2) to ubound(map,2)
        for x as uinteger = lbound(map,1) to ubound(map,1)
            map(x,y) = int(2*rnd+2)
            
            for i as uinteger = 1 to mapBias
                if map(x,y) = 3 then map(x,y) = int(2*rnd+2)
            next i
            
            select case map(x,y)
            case 2
                locate(y,x):color 2:print "-"
            case 3
                locate(y,x):color 7:print "#"
            case 4
                locate(y,x):color 14:print "@"
            end select
            
        next x
    next y
end sub

print "Starting server..."
init()

print "Generating map..."
generateMap()

redim shared as clientProp cl(1 to sv.maxClients)

for i as uinteger = lbound(cl) to ubound(cl)
    with cl(i)
        .sock = 0
        
        .pong = 0
        .ping = timer
    end with
next i

do
    if hselect(sv.sock) then
        'New client
        print "Client connected!"
        if sv.clientCount < sv.maxClients then
            'There's room for more clients
            
            for i as uinteger = lbound(cl) to ubound(cl)
                with cl(i)
                    if .sock = 0 then
                        'Free slot
                        .sock = hAccept(sv.sock,.ip,.port)
                        .status = waitAuth
                        sv.cmd = 9
                        hSend(.sock,cast(any ptr,@sv.cmd),sizeof(sv.cmd))
                        exit for
                    end if
                end with
            next i
        else
            'Server full
            with tmpCl
                .sock = hAccept(sv.sock,.ip,.port)
                hClose(.sock)
                
            end with
        end if
    else
        'Manage existing clients
        
        for i as integer = lbound(cl) to ubound(cl)
            with cl(i)
                if .sock then
                    if hSelect(.sock) then
                        'Client sent us a message.
                        'Grab first byte to see the cmd
                        
                        .iresu = hReceive(.sock,cast(any ptr,@.cmd),sizeof(.cmd))
                        if .iresu <= 0 then
                            print .iresu
                            print "Client disconnected..."
                            
                            hclose(.sock)
                            .sock = 1
                            map(.x,.y) = 1
                        else
                            
                            select case .status
                            case waitAuth
                                if .cmd = 1 then
                                    print "Client auth'd"
                                    .status = playing
                                    sv.cmd = 1
                                    hSend(.sock,cast(any ptr,@sv.cmd),sizeof(sv.cmd))
                                    
                                    .x = ubound(map,1)*rnd
                                    .y = ubound(map,2)*rnd
                                    print i
                                    .ping = timer
                                    .pong = 1
                                    print .pong
                                    
                                    map(.x,.y) = 3
                                    
                                    'Send ping
                                    sv.cmd = 3
                                    hSend(.sock,cast(any ptr,@sv.cmd),sizeof(sv.cmd))
                                    
                                else
                                    sv.cmd = 1
                                    hSend(.sock,cast(any ptr,@sv.cmd),sizeof(sv.cmd))
                                    
                                end if
                                exit select
                                
                            case playing
                                select case .cmd
                                case 3
                                    'Get pong
                                    print "got pong"
                                    .ping = timer
                                    .pong = 1
                                    exit select
                                    
                                case 4
                                    'Up
                                    if .y-1 > lbound(map,2) then
                                        if map(.x,.y-1) = 1 then
                                            map(.x,.y) = 1
                                            .y-=1
                                            map(.x,.y) = 3
                                        else
                                            sv.cmd = 1
                                            hSend(.sock,cast(any ptr,@sv.cmd),sizeof(sv.cmd))
                                        end if
                                    end if
                                    exit select
                                    
                                case 5
                                    'Down
                                    if .y+1 < ubound(map,2) then
                                        if map(.x,.y+1) = 1 then
                                            map(.x,.y) = 1
                                            .y+=1
                                            map(.x,.y) = 3
                                        else
                                            sv.cmd = 1
                                            hSend(.sock,cast(any ptr,@sv.cmd),sizeof(sv.cmd))
                                        end if
                                    end if
                                    exit select
                                    
                                case 6
                                    'Left
                                    if .x-1 > lbound(map,1) then
                                        if map(.x-1,.y) = 1 then
                                            map(.x,.y) = 1
                                            .x-=1
                                            map(.x,.y) = 3
                                        else
                                            sv.cmd = 1
                                            hSend(.sock,cast(any ptr,@sv.cmd),sizeof(sv.cmd))
                                        end if
                                    end if
                                    exit select
                                    
                                case 7
                                    'Right
                                    if .x+1 < ubound(map,1) then
                                        if map(.x+1,.y) = 1 then
                                            map(.x,.y) = 1
                                            .x+=1
                                            map(.x,.y) = 3
                                        else
                                            sv.cmd = 1
                                            hSend(.sock,cast(any ptr,@sv.cmd),sizeof(sv.cmd))
                                        end if
                                    end if
                                    
                                case 9
                                    'Send map
                                    print "Client getting map"
                                    .cmd = 0
                                    sv.cmd = 6
                                    sv.sz = 0
                                    hSend(.sock,cast(any ptr,@sv.cmd),sizeof(sv.cmd))
                                    
                                    for y as integer = .y-4 to .y+4
                                        for x as integer = .x-4 to .x+4
                                            if x >= 1 andalso y >= 1 then sv.sz+=1
                                        next x
                                    next y
                                    hSend(.sock,cast(any ptr,@sv.sz),sizeof(sv.sz))
                                    
                                    for y as short = .y-4 to .y+4
                                        for x as short = .x-4 to .x+4
                                            if x >= 1 andalso x <= 50 andalso y >= 1 andalso y <= 20 then
                                                
                                                hSend(.sock,cast(any ptr,@x),sizeof(short))
                                                hSend(.sock,cast(any ptr,@y),sizeof(short))
                                                hSend(.sock,cast(any ptr,@map(x,y)),sizeof(map(x,y)))
                                            end if
                                        next x
                                    next y
                                    exit select
                                    
                                case else
                                    sv.cmd = 1
                                    hSend(.sock,cast(any ptr,@sv.cmd),sizeof(sv.cmd))
                                    exit select
                                    
                                end select
                            end select
                        end if
                    else
                        if timer-.ping > 10 then
                            if .pong = 0 then
                                'Timeout
                                print "Client timeout"
                                print timer-.ping
                                print .pong
                                print .iresu
                                
                                hclose(.sock)
                                .sock = 0
                                map(.x,.y) = 1
                                
                            else
                                print "sending ping"
                                'Still alive
                                sv.cmd = 3
                                hSend(.sock,cast(any ptr,@sv.cmd),sizeof(sv.cmd))
                                
                                .ping = timer
                                .pong = 0
                                
                            end if
                        end if
                        
                    end if
                end if
            end with
        next i
    end if
    
    if multikey(sc_q) then exit do
    
    sleep 1,1
loop until multikey(sc_q)

hClose(sv.sock)

end 0