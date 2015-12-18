declare sub controller()

declare sub initNetwork()
declare sub initServer()
declare sub initVars()
declare sub initMap()
declare sub init()

declare sub addClient(i as uinteger)
declare sub removeClient(i as uinteger)
declare sub authClient(i as uinteger)
declare sub serverFull()
declare sub spawnPlayer(i as uinteger)
declare sub putCmd(i as uinteger,smsgTmp as ubyte)
declare sub getCmd(i as uinteger)
declare sub sendMap(i as uinteger)

sub controller()
    if multikey(sc_q) then sv.flag = fl.shutdown
end sub

sub initNetwork()
    hStart()
end sub

sub initServer()
    with sv
        .port = 28000
        
        .sock = hOpen()
        hBind(.sock,.port)
        hListen(.sock)
        
        .flag = runServer
    end with
end sub

sub initVars()
    sv.maxPlayers = 8
end sub

sub initMap()
    var mapBiasTries = 1
    for x as integer = lbound(map,1) to ubound(map,1)
        for y as integer = lbound(map,2) to ubound(map,2)
            
            map(x,y) = 1*rnd+1
            
            for i as integer = 1 to mapBiasTries
                if map(x,y) = 2 then map(x,y) = 1*rnd+1
            next i
            
            select case map(x,y)
            case 1
                locate(y,x):print  "-"
            case 2
                locate(y,x):print "#"
            end select
        next y
    next x
end sub

sub init()
    initNetwork()
    initServer()
    initVars()
    initMap()
end sub

'===============================================================================

sub addClient(i as uinteger)
    with pl(i)
        .joinTime = timer
        .sock = haccept(sv.sock,.ip,.port)
        .ID = i
        .status = waitAuth
        
        putCmd(i,9)
    end with
    sv.playerCount+=1
end sub

sub removeClient(i as uinteger)
    with pl(i)
        hClose(.sock)
        .sock = 0
        .ID = 0
        .status = notConnected
'        map(.x,.y) = 1
    end with
    sv.playerCount-=1
end sub

sub authClient(i as uinteger)
    with pl(i)
        .status = playing
    end with
end sub

sub serverFull()
    sv.cmd = 5
    
    with plTmp
        .sock = hAccept(sv.sock,.ip,.port)
        
        hSend(.sock,cast(any ptr,@sv.cmd),sizeof(sv.cmd))
        
        hClose(.sock)
        .sock = 0
    end with
end sub

sub spawnPlayer(i as uinteger)
    var flag = 0
    
    with pl(i)
        do
            .x = ubound(map,1)*rnd
            .y = ubound(map,2)*rnd
            
            select case map(.x,.y)
            case 1
                flag = 1
            case 2
                flag = 0
            case 3
                flag = 0
            end select
        loop until flag = 1
        
        map(.x,.y) = 3
    end with
    
end sub

sub putCmd(i as uinteger,smsgTmp as ubyte)
    sv.cmd = smsgTmp
    with pl(i)
        hSend(.sock,cast(any ptr,@sv.cmd),1)
    end with
end sub

sub getCmd(i as uinteger)
    with pl(i)
        iresu = hReceive(.sock,cast(any ptr,@sv.cmd),1)
    end with
end sub

sub sendMap(i as uinteger)
    with pl(i)
        sv.cmd = 6
        hSend(.sock,cast(any ptr,@sv.cmd),sizeof(sv.cmd))
        
        sv.sz = 0
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
    end with
end sub