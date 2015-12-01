'Server 99 v8.1
#include "fbgfx.bi"
#include "crt.bi"
#include "wshelper.bas"
#include "ccbuffer.bas"
#include "scrn.bas"

using fb

randomize 1

'=====Constants
'Map tile IDs
dim shared as ubyte tl_null =   0,_
                    tl_floor =  1,_
                    tl_wall =   2

'=====Enums

enum clientStatus
    notConnected
    waitAuth
    playing
end enum

'=====Structs

type serverProp
    as socket sock
    as long port
    as zstring*16 ip
    
    as ubyte cmd
    as uinteger iresu
    
    as integer buffPos
    as zstring*1024 sBuff
    as any ptr pBuff
    
    as ubyte maxClients,connectedClients
end type

type clientProp
    as socket sock
    as long ip1,port
    as zstring*16 ip2
    
    as ubyte cmd
    as integer buffPos
    as zstring*1024 sBuff
    as any ptr pBuff
    
    as short x,y
    
    as clientStatus status
    
    as ubyte inUse
end type

type clientTempProp
    as socket sock
    as long ip1,port
    as zstring*16 ip2
end type

'=====Variables

dim as ubyte map(1 to 50,1 to 20)

dim as serverProp sv
dim as clientProp cl(1 to 8)
dim as clientTempProp clTmp

'====Functions/Subs

sub initServer(sv as serverProp)
    with sv
        .sock = hopen()
        .port = 28000
        
        .buffPos = 0
        .sBuff = space(1024)
        .pBuff = strptr(.sBuff)
        
        .maxClients = 8
    end with
end sub

sub initNetwork(sv as serverProp)
    hStart()
    
    with sv
        hBind(.sock,.port)
        hListen(.sock)
    end with
end sub

sub initMap(map() as ubyte,filt as ubyte = 1)
    for y as ubyte = lbound(map,2) to ubound(map,2)
        for x as ubyte = lbound(map,1) to ubound(map,1)
            dim as uinteger tl = 1*rnd+1
            
            for i as ubyte = 1 to filt
                if tl = tl_wall then tl = 1*rnd+1
            next i
            
            map(x,y) = tl
        next x
    next y
end sub

sub renderMap(map() as ubyte)
    cls
    for y as ubyte = lbound(map,2) to ubound(map,2)
        for x as ubyte = lbound(map,1) to ubound(map,1)
            select case map(x,y)
            case tl_null
                locate(y,x):print "X"
            case tl_floor
                locate(y,x):print "."
            case tl_wall
                locate(y,x):print "#"
            end select
        next x
    next y
end sub

sub connectPlayerServerFull(cl as clientTempProp,sv as serverProp)
    with cl
        .sock = hAccept(sv.sock,.ip1,.port)
        hClose(.sock)
        .sock = 0
        .ip1 = 0
        .port = 0
    end with
end sub

sub connectPlayer(cl as clientProp,sv as serverProp)
    with cl
        .sock = hAccept(sv.sock,.ip1,.port)
        .inUse = 1
        
        .status = waitAuth
        
        sv.connectedClients+=1
    end with
end sub

sub spawnPlayer(cl as clientProp,map() as ubyte)
    var fl = 0
    with cl
        do
            .x = ubound(map,1)*rnd
            .y = ubound(map,2)*rnd
            
            if map(.x,.y) = tl_floor then fl = 1
        loop until fl = 1
    end with
end sub

sub sendMap(cl as clientProp,map() as ubyte)
    dim as ubyte sz = 0
    dim as ubyte xx,yy
    
    with cl
        .cmd = 7
        putBuff(.cmd,.pBuff,.buffPos)
        
        'Calculate map size
        for y as short = .y-4 to .y+4
            if y >= lbound(map,2) or y <= ubound(map,2) then
                for x as short = .x-4 to .x+4
                    if x >= lbound(map,1) or x <= ubound(map,1) then
                        'True
                        sz+=1
                    else
                        'False
                        continue for
                    end if
                next x
            end if
        next y
        
        putBuff(sz,.pBuff,.buffPos)
        
        'Add map data to buffer
        for y as short = .y-4 to .y+4
            if y >= lbound(map,2) or y <= ubound(map,2) then
                for x as short = .x-4 to .x+4
                    if x >= lbound(map,1) or x <= ubound(map,1) then
                        'True
                        xx = x
                        yy = y
                        
                        putBuff(xx,.pBuff,.buffPos)
                        putBuff(yy,.pBuff,.buffPos)
                        putBuff(map(xx,yy),.pBuff,.buffPos)
                    else
                        'False
                        continue for
                    end if
                next x
            end if
        next y
        
        'Send buffer
        print .sbuff
        hSend(.sock,.sBuff,sizeof(.sBuff))
        clsBuff(.buffPos)
    end with
end sub

'=====Init

print ">Init Server"
initServer(sv)
print ">Init Network"
initNetwork(sv)
'sv.ip = hGetExternalIP()
print ">Init map"
initMap(map(),1)
print ">Server running..."
'print "...Server IP: '" & sv.ip & "'"

'=====Main

do
    'Check for new clients trying to connect
    if hSelect(sv.sock) then
        'Check if the server is full
        if sv.connectedClients >= sv.maxClients then
            'Server is full
            connectPlayerServerFull(clTmp,sv)
        else
            'Server has open slots
            for i as ubyte = lbound(cl) to ubound(cl)
                with cl(i)
                    if .inUse = 0 andalso .status = notConnected then
                        'Connect player
                        connectPlayer(cl(i),sv)
                        
                        .cmd = 1
                        putBuff(.cmd,.pBuff,.buffPos)
                        hSend(.sock,.sBuff,sizeof(.sBuff))
                        clsBuff(.buffPos)
                        exit for
                    end if
                end with
            next i
        end if
    else
        'Manage existing users
        for i as ubyte = lbound(cl) to ubound(cl)
            with cl(i)
                if .inUse = 1 then
                    if hSelect(.sock) then
                        'Client has sent the server data
                        sv.iresu = hReceive(.sock,cast(any ptr,@.cmd),1)
                        
                        if sv.iResu <= 0 then
                            'Client disconnected
                            hClose(.sock)
                            .inUse = 0
                        else
                            'Client cmd
                            select case .status
                            case waitAuth
                                select case .cmd
                                case 1
                                    'Client auth'd
                                    .cmd = 1
                                    putBuff(.cmd,.pBuff,.buffPos)
                                    hSend(.sock,.sBuff,sizeof(.sBuff))
                                    clsBuff(.buffPos)
                                    
                                    .status = playing
                                    
                                case else
                                    'Client failed to send auth
                                    .cmd = 2
                                    putBuff(.cmd,.pBuff,.buffPos)
                                    hSend(.sock,.sBuff,sizeof(.sBuff))
                                    clsBuff(.buffPos)
                                    
                                end select
                                
                            case playing
                                select case .cmd
                                case 5
                                    'Request map
                                    sendMap(cl(i),map())
                                case 6
                                    'Up
                                    
                                case 7
                                    'Down
                                    
                                case 8
                                    'Left
                                    
                                case 9
                                    'Right
                                    
                                end select
                            end select
                        end if
                    end if
                end if
            end with
        next i
    end if
    
    do
        var k = inkey()
        if len(k) = 0 then exit do
        var ik = cint(k[0])
        if ik = 255 then ik = -k[1]
        select case ik
        case asc("m"),asc("M")
            renderMap(map())
        case 27
            exit do,do
        end select
    loop
    
    sleep 1,1
'    While Inkey <> "": Wend
loop' until multikey(sc_escape)

print ">Shutting down..."
hClose(sv.sock)
hShutdown()

end 0