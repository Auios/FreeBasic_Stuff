#include "wshelper.bas"
#include "fbgfx.bi"
#include "scrn.bas"

using fb

randomize 1

print "Setting variables..."

declare sub generateWorld()
declare sub spawnClient(i as integer)
declare sub sendMap(i as integer)
declare sub renderWorld()

enum clientStatus
    notConnected
    waitAuth
    waitCmd
    requestMap
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

sv.port = 28000
sv.clientCount = 0
sv.maxClients = ubound(cl)

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
    with cl(i)
        .x = ubound(map,1)*rnd
        .y = ubound(map,2)*rnd
        map(.x,.y) = 3
    end with
end sub

sub sendMap(i as integer)
    with cl(i)
        sv.cmd = 6
        hSend(.sock,cast(any ptr,@sv.cmd),sizeof(ubyte))
        
        for y as short = .y-4 to .y+4
            for x as short = .x-4 to .x+4
                if map(x,y) > 0 then
                    continue for
                else
                    hSend(.sock,cast(any ptr,@x),sizeof(short))
                    hSend(.sock,cast(any ptr,@y),sizeof(short))
                    hSend(.sock,cast(any ptr,@map(x,y)),sizeof(ubyte))
                end if
            next x
        next y
    end with
end sub

sub renderWorld()
    for y as short = lbound(map,2) to ubound(map,2)
        for x as short = lbound(map,1) to ubound(map,1)
            select case map(x,y)
            case 1
                locate(y,x):print chr(176)
            case 2
                locate(y,x):print chr(219)
            case 3
                locate(y,x):print chr(2)
            end select
        next x
    next y
end sub

print "Generating world..."
generateWorld()

print "Starting network..."
hstart()
sv.Sock = hOpen()
hBind(sv.sock,sv.port)
hListen(sv.sock)

print "Server running..."

do
    if hSelect(sv.sock) then
        'New client connected
        for i as integer = lbound(cl) to ubound(cl)
            with cl(i)
                if sv.clientCount < sv.maxClients then
                    'Server is not full
                    if .inUse = 0 andalso .sock = 0 andalso .status = notConnected then
                        'Fill the empty slot
                        print "Client connected..."
                        print "ID/IP/Port - " & i & " / " & hIPtoString(.ip) & " / " & .port
                        
                        .sock = hAccept(sv.sock,.ip,.port)
                        .inUse = 1
                        .status = waitAuth
                        
                        sv.clientCount+=1
                        exit for
                    end if
                else
                    'Server is full
                    print "Client connected... Server is full!"
                    cltmp.sock = hAccept(sv.sock,cltmp.ip,cltmp.port)
                    hClose(cltmp.sock)
                end if
            end with
        next i
    else
        'Manage existing clients
        for i as integer = lbound(cl) to ubound(cl)
            with cl(i)
                if .inUse = 1 andalso .status <> notConnected then
                    if hSelect(.sock) then
                        'Client has sent us data
                        var iresu = hReceive(sv.sock,cast(any ptr,@.cmd),sizeof(ubyte))
                        print .cmd,iresu
                        if iresu <= 0 then
                            'Client disconnected
                            print "Client '" & i & "' disconnected..."
                            
                            map(.x,.y) = 1
                            hclose(.sock)
                            .sock = 0
                            .inUse = 0
                            .status = notConnected
                            
                            sv.clientCount-=1
                            
                        else
                            select case .status
                            case notConnected
                                'This is not supposed to happen...
                                print "Client '" & i & "' did something very wrong..."
                                
                                exit select
                                
                            case waitAuth
                                'Waiting for auth byte from client
                                select case .cmd
                                case 1
                                    'Client has sent auth byte
                                    print "Client '" & i & "' has been authenticated..."
                                    sv.cmd = 1
                                    hSend(.sock,cast(any ptr,@sv.cmd),sizeof(ubyte))
                                    .status = waitCmd
                                    
                                    spawnClient(i)
                                    
                                    exit select
                                    
                                case else
                                    'Client sent wrong data during auth. Kill the connection!
                                    print "Client '" & i & "' failed to be authenticated..."
                                    sv.cmd = 2
                                    hSend(.sock,cast(any ptr,@sv.cmd),sizeof(ubyte))
                                    hClose(.sock)
                                    .sock = 0
                                    .inUse = 0
                                    
                                    exit select
                                end select
                                
                            case waitCmd
                                'Waiting for client to send cmd byte
                                select case .cmd
                                case 9
                                    'Client requested map
                                    .status = requestMap
                                case else
                                    'Unknown cmd byte
                                    print "Client '" & i & "' sent unknown cmd: " & .cmd
                                    
                                    exit select
                                end select
                                
                                exit select
                                
                            case requestMap
                                sendMap(i)
                                .status = waitCmd
                                
                                exit select
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
    case "q"
        print "Shutting down..."
        sv.flag = 1
        
    case "r"
        cls
        print "Rendering world..."
        renderWorld()
        
    case ""
        exit select
        
    case else
        print "Unknown keypress: " & key
    end select
    
    while inkey<>"":wend
        
    sleep 1,1
loop until sv.flag = 1

hClose(sv.sock)
hShutdown()

print "Bye!"