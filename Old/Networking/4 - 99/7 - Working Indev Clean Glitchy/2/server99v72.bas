'http://codeshare.io/BzbCn

#include "wshelper.bas"
#include "fbgfx.bi"
#include "scrn.bas"

using fb

randomize 3

print "Setting up..."

'screen 11
'windowtitle "Server v.7"

declare sub generateWorld()
declare sub spawnClient(i as integer)
declare sub sendMap(i as integer)
declare sub renderWorld()
declare sub init()
declare sub sendTile(i as integer,x as short,y as short,id as ubyte)

enum clientStatus
    notConnected
    waitAuth
    waitCmd
    requestMap
    move
end enum

type clientProp
    as ubyte inUse
    as socket sock
    as long ip,port
    
    as clientStatus status
    
    as ubyte cmd
    as short x,y
end type

type tmpClientProp
    as socket sock
    as long ip,port
end type

type serverProp
    as socket sock
    as long port
    as uinteger maxClients,clientCount
    
    as ubyte flag,cmd
end type

dim shared as string key
dim shared as ubyte map(1 to 50,1 to 20)

dim shared as clientProp cl(1 to 16)
dim shared as tmpClientProp cltmp
dim shared as serverProp sv

sub generateWorld()
    for y as integer = lbound(map,2) to ubound(map,2)
        for x as integer = lbound(map,1) to ubound(map,1)
            var tl = int(2*rnd+1)
            if tl = 2 then tl = int(2*rnd+1)
            map(x,y) = tl
        next x
    next y
end sub

sub spawnClient(i as integer)
    print "Spawning client '" & i & "'"
    with cl(i)
        .x = ubound(map,1)*rnd
        .y = ubound(map,2)*rnd
        map(.x,.y) = 3
    end with
end sub

sub sendMap(i as integer)
    print "Sending client '" & i & "' map data"
    with cl(i)
        sv.cmd = 6
        hSend(.sock,cast(any ptr,@sv.cmd),sizeof(ubyte))
        sv.cmd = 12
        
        for y as short = .y-4 to .y+4
            for x as short = .x-4 to .x+4
                if x < lbound(map,1) or x > ubound(map,1) or y < lbound(map,2) or y > ubound(map,2) then
                    continue for
                else
                    if map(x,y) <= 0 then
                        continue for
                    else
                        hSend(.sock,cast(any ptr,@sv.cmd),sizeof(ubyte))
                        hSend(.sock,cast(any ptr,@x),sizeof(short))
                        hSend(.sock,cast(any ptr,@y),sizeof(short))
                        hSend(.sock,cast(any ptr,@map(x,y)),sizeof(ubyte))
                    end if
                end if
            next x
        next y
        
        sv.cmd = 13
        hSend(.sock,cast(any ptr,@sv.cmd),sizeof(ubyte))
    end with
end sub

sub renderWorld()
    for y as short = lbound(map,2) to ubound(map,2)
        for x as short = lbound(map,1) to ubound(map,1)
            select case map(x,y)
            case 1
                locate(y,x):color 2:print "-"
            case 2
                locate(y,x):color 8:print chr(219)
            case 3
                locate(y,x):color 14:print chr(2)
            end select
        next x
    next y
    
    color 7
end sub

sub disconnectClient(i as integer)
    with cl(i)
        print "Client disconnected... " & i & " / " & hIPtoString(.ip) & " / " & .port
        
        if .status <> waitAuth then map(.x,.y) = 1
        hclose(.sock)
        .sock = 0
        .inUse = 0
        .status = notConnected
    end with
    
    sv.clientCount-=1
end sub

sub init()
    sv.port = 28000
    sv.clientCount = 0
    sv.maxClients = ubound(cl)
    
    print "Generating world..."
    generateWorld()
    
    print "Starting network..."
    hstart()
    sv.Sock = hOpen()
    if hBind(sv.sock,sv.port)=0 then print "failed to bind...":sleep
'    hBind(sv.sock,sv.port)
    hListen(sv.sock)
end sub

sub sendTile(i as integer,x as short,y as short,id as ubyte)
    sv.cmd = 12
    with cl(i)
        hSend(.sock,cast(any ptr,@sv.cmd),sizeof(ubyte))
        hSend(.sock,cast(any ptr,@x),sizeof(short))
        hSend(.sock,cast(any ptr,@y),sizeof(short))
        hSend(.sock,cast(any ptr,@id),sizeof(ubyte))
    end with
end sub

init()

print "Server running..."

do 'Main loop
    if hSelect(sv.sock) then 'New client connected. Find empty slot
        for i as integer = lbound(cl) to ubound(cl) 'Loop through all the slots
            with cl(i) 'With client(i)
                if sv.clientCount < sv.maxClients then 'If the server is not full
                    if .inUse = 0 andalso .sock = 0 andalso .status = notConnected then 'If slot is empty, fill it with the new client
                        
                        .sock = hAccept(sv.sock,.ip,.port)
                        .inUse = 1
                        .status = waitAuth
                        
                        print "Client connected... " & i & " / " & hIPtoString(.ip) & " / " & .port
                        
                        sv.cmd = 9
                        hSend(.sock,cast(any ptr,@sv.cmd),sizeof(ubyte))
                        print "Server: " & sv.cmd
                        
                        sv.clientCount+=1
                        exit for
                    end if
                else 'Server is full
                    print "Client connected - Server full... " & hIPtoString(.ip) & " / " & .port
                    cltmp.sock = hAccept(sv.sock,cltmp.ip,cltmp.port)
                    
                    sv.cmd = 5
                    hSend(.sock,cast(any ptr,@sv.cmd),sizeof(ubyte))
                    print "Server: " & sv.cmd
                    hClose(cltmp.sock)
                end if
            end with
        next i
    else 'Manage existing clients
        for i as integer = lbound(cl) to ubound(cl) 'Loop through all the clients
            with cl(i) 'With client(i)
                if .inUse = 1 andalso .status <> notConnected then 'Is there a client connected?
                    if hSelect(.sock) then 'Client has sent us data
                        var iresu = hReceive(.sock,cast(any ptr,@.cmd),sizeof(ubyte))
                        print "Client '" & i & "' sent: " & .cmd,iresu
                        
                        if iresu <= 0 then 'Client disconnected
                            disconnectClient(i)
                            
                        else 'Client is still connected. Manage recv'd data.
                            select case .status
                            case notConnected 'This should never ever execute. If it does, burn this code and start over.
                                print "Client '" & i & "' wants me to kill myself..."
                                                                
                            case waitAuth 'Waiting for auth byte from client
                                select case .cmd
                                case 1 'Client has sent auth byte
                                    print "Client '" & i & "' has been authenticated..."
                                    sv.cmd = 1
                                    hSend(.sock,cast(any ptr,@sv.cmd),sizeof(ubyte))
                                    print "Server: " & sv.cmd
                                    .status = waitCmd
                                    
                                    spawnClient(i)
                                    
                                case else 'Client sent wrong data during auth. Kill the connection!
                                    print "Client '" & i & "' failed to be authenticated... Kicking client..."
                                    sv.cmd = 2
                                    hSend(.sock,cast(any ptr,@sv.cmd),sizeof(ubyte))
                                    print "Server: " & sv.cmd
                                    hClose(.sock)
                                    .sock = 0
                                    .inUse = 0
                                end select
                                
                            case waitCmd 'Waiting for client to send cmd byte
                                select case .cmd
                                case 2 'Client disconnected
                                    disconnectClient(i)
                                    
                                case 4 'Up
                                    if .y-1 >= lbound(map,2) andalso map(.x,.y-1) = 1 then
                                        map(.x,.y) = 1
                                        .y-=1
                                        map(.x,.y) = 3
                                        
                                        var ty = .y-4
                                        
                                        sv.cmd = 6
                                        hSend(.sock,cast(any ptr,@sv.cmd),sizeof(ubyte))
                                        sv.cmd = 12
                                        for x as short = .x-4 to .x+4
                                            if map(x,.y-4) >= 1 then
                                                sendTile(i,x,ty,map(x,ty))
                                            end if
                                        next x
                                        sv.cmd = 13
                                        hSend(.sock,cast(any ptr,@sv.cmd),sizeof(ubyte))
                                        
                                    else 'Cant move up
                                        sv.cmd = 2
                                        hSend(.sock,cast(any ptr,@sv.cmd),sizeof(ubyte))
                                        print "Server: " & sv.cmd
                                    end if
                                    
                                case 5 'Down
                                    if .y+1 <= ubound(map,2) andalso map(.x,.y+1) = 1 then
                                        map(.x,.y) = 1
                                        .y+=1
                                        map(.x,.y) = 3
                                        
                                        var ty = .y+4
                                        
                                        sv.cmd = 6
                                        hSend(.sock,cast(any ptr,@sv.cmd),sizeof(ubyte))
                                        sv.cmd = 12
                                        for x as short = .x-4 to .x+4
                                            if map(x,.y+4) >= 1 then
                                                sendTile(i,x,ty,map(x,ty))
                                            end if
                                        next x
                                        sv.cmd = 13
                                        hSend(.sock,cast(any ptr,@sv.cmd),sizeof(ubyte))
                                        
                                    else 'Cant move up
                                        sv.cmd = 2
                                        hSend(.sock,cast(any ptr,@sv.cmd),sizeof(ubyte))
                                        print "Server: " & sv.cmd
                                    end if
                                    
                                case 6 'Left
                                    if .x-1 >= lbound(map,1) andalso map(.x-1,.y) = 1 then
                                        map(.x,.y) = 1
                                        .x-=1
                                        map(.x,.y) = 3
                                        
                                        var tx = .x-4
                                        
                                        sv.cmd = 6
                                        hSend(.sock,cast(any ptr,@sv.cmd),sizeof(ubyte))
                                        sv.cmd = 12
                                        for y as short = .y-4 to .y+4
                                            if map(.x-4,y) >= 1 then
                                                sendTile(i,tx,y,map(tx,y))
                                            end if
                                        next y
                                        sv.cmd = 13
                                        hSend(.sock,cast(any ptr,@sv.cmd),sizeof(ubyte))
                                        
                                    else 'Cant move up
                                        sv.cmd = 2
                                        hSend(.sock,cast(any ptr,@sv.cmd),sizeof(ubyte))
                                        print "Server: " & sv.cmd
                                    end if
                                    
                                case 7 'Right
                                    if .x+1 <= ubound(map,1) andalso map(.x+1,.y) = 1 then
                                        map(.x,.y) = 1
                                        .x+=1
                                        map(.x,.y) = 3
                                        
                                        var tx = .x+4
                                        
                                        sv.cmd = 6
                                        hSend(.sock,cast(any ptr,@sv.cmd),sizeof(ubyte))
                                        sv.cmd = 12
                                        for y as short = .y-4 to .y+4
                                            if map(.x+4,y) >= 1 then
                                                sendTile(i,tx,y,map(tx,y))
                                            end if
                                        next y
                                        sv.cmd = 13
                                        hSend(.sock,cast(any ptr,@sv.cmd),sizeof(ubyte))
                                        
                                    else 'Cant move up
                                        sv.cmd = 2
                                        hSend(.sock,cast(any ptr,@sv.cmd),sizeof(ubyte))
                                        print "Server: " & sv.cmd
                                    end if
                                    
                                case 9 'Client requested map
                                    sendMap(i)
                                    
                                case else 'Unknown cmd byte
                                    print "Client '" & i & "' sent unknown cmd: " & .cmd
                                    
                                end select
                            end select
                        end if
                    end if
                end if
            end with
        next i
    end if
    
    'Keyboard input
    key = inkey()
    select case key
    case "q" 'Kill server
        print "Shutting down..."
        sv.flag = 1
        
    case "r" 'Render world
        cls
        print "Rendering world..."
        renderWorld()
        
    case "" 'No key
        exit select
        
    case else 'Unknown key press
        print "Unknown key press: " & key
    end select
    
    while inkey<>"":wend
    sleep 1,1
loop until sv.flag = 1

hClose(sv.sock)
hShutdown()

print "Bye!"