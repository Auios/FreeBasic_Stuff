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
    buffer = 255
    smsg = space(buffer)
    sv.maxPlayers = 8
end sub

sub initMap()
    var mapBiasTries = 1
    with mp
        for x as integer = lbound(.ID,1) to ubound(.ID,1)
            for y as integer = lbound(.ID,2) to ubound(.ID,2)
                
                .ID(x,y) = 1*rnd+1
                
                for i as integer = 1 to mapBiasTries
                    if .ID(x,y) = 2 then .ID(x,y) = 1*rnd+1
                next i
                
                select case .ID(x,y)
                case 1
                    .mask(x,y) = "."
                case 2
                    .mask(x,y) = chr(178)
                end select
                locate(y,x):print .mask(x,y)
            next y
        next x
    end with
    print
end sub

sub init()
    initNetwork()
    initServer()
    initVars()
    initMap()
end sub

sub spawnPlayer(i as uinteger)
    var flag = 0
    
    with pl(i)
        do
            .x = ubound(mp.ID,1)*rnd
            .y = ubound(mp.ID,2)*rnd
            
            select case mp.ID(.x,.y)
            case 1
                flag = 1
            case 2
                flag = 0
            case 3
                flag = 0
            end select
        loop until flag = 1
        
        mp.ID(.x,.y) = 3
    end with
    
    
end sub

sub getMsg(i as uinteger)
    with pl(i)
        .smsg = space(buffer)
        iresu = hReceive(.sock,.smsg,buffer)
        .smsg = left(.smsg,iresu)
    end with
end sub

sub putMsg(i as uinteger,smsgTmp as string)
    smsg = smsgTmp
    with pl(i)
        hSend(.sock,smsg,len(smsg))
    end with
end sub

sub putAll(smsgTmp as string)
    smsg = smsgTmp
    for i as integer = lbound(pl) to ubound(pl)
        with pl(i)
            if .sock andalso .status = playing then
                putMsg(i,smsg)
            else
                continue for
            end if
        end with
    next i
end sub

sub putAllBut(j as uinteger,smsgTmp as string)
    smsg = smsgTmp
    for i as integer = lbound(pl) to ubound(pl)
        with pl(i)
            if .sock andalso j <> i andalso .status = playing then
                putMsg(i,smsg)
            else
                continue for
            end if
        end with
    next i
end sub

sub addClient(i as uinteger)
    with pl(i)
        .joinTime = timer
        .sock = haccept(sv.sock,.ip,.port)
        .ID = i
        .status = waitAuth
        putMsg(i,"ra.")
    end with
    sv.playerCount+=1
end sub

sub removeClient(i as uinteger)
    with pl(i)
        hClose(.sock)
        .sock = 0
        .ID = 0
        .status = notConnected
        mp.ID(.x,.y) = 1
    end with
    sv.playerCount-=1
end sub

sub authClient(i as uinteger)
    with pl(i)
        .status = playing
    end with
end sub

sub serverFull()
    var tmsg = "sf."
    
    with plTmp
        .sock = hAccept(sv.sock,.ip,.port)
        
        hSend(.sock,tmsg,len(tmsg))
        
        hClose(.sock)
        .sock = 0
    end with
end sub

sub sendMap(i as uinteger)
    dim as string tmsg = "tl."
    dim as uinteger sz
    with pl(i)
        for x as integer = .x-4 to .x+4
            for y as integer = .y-4 to .y+4
                if x >= lbound(mp.ID,1) and x <= ubound(mp.ID,1)then
                    if y >= lbound(mp.ID,2) and y <= ubound(mp.ID,2) then
                        tmsg += mp.ID(x,y) & ";" & x & ";" & y & "."
                    end if
                end if
            next y
        next x
        
        tmsg+="en."
        putMsg(i,tmsg)
    end with
end sub

'===============================================================================
'Movements

sub move(i as uinteger)
    dim as string ymsg = "tl.",tmsg = "tl."
    dim as uinteger tx1,ty1,tx2,ty2
    dim as ubyte ID1,ID2
    dim as integer xx,yy
    
    with pl(i)
        select case .direct
        case mu
            yy-=4
            if .y-1 >= lbound(mp.ID,2) andalso mp.ID(.x,.y-1) = 1 then
                mp.ID(.x,.y) = 1
                tmsg+=mp.ID(.x,.y) & ";" & .x & ";" & .y & "."
                ID1 = mp.ID(.x,.y)
                tx1 = .x
                ty1 = .y
                
                .y-=1
                
                mp.ID(.x,.y) = 3
                tmsg+=mp.ID(.x,.y) & ";" & .x & ";" & .y & "."
                ID2 = mp.ID(.x,.y)
                tx2 = .x
                ty2 = .y
                
                if .y >= lbound(mp.ID,2)+4 then
                    for x as integer = .x-4 to .x+4
                        if x >= lbound(mp.ID,1) andalso x <= ubound(mp.ID,1) then
                            if .y+yy >= lbound(mp.ID,2) then
                                tmsg+=mp.ID(x,.y+yy) & ";" & x & ";" & .y+yy & "."
                            end if
                        end if
                    next x
                end if
            else
                putMsg(i,"no.")
                exit sub
            end if
            
        case md
            yy+=4
            if .y+1 <= ubound(mp.ID,2) andalso mp.ID(.x,.y+1) = 1 then
                mp.ID(.x,.y) = 1
                tmsg+=mp.ID(.x,.y) & ";" & .x & ";" & .y & "."
                ID1 = mp.ID(.x,.y)
                tx1 = .x
                ty1 = .y
                
                .y+=1
                
                mp.ID(.x,.y) = 3
                tmsg+=mp.ID(.x,.y) & ";" & .x & ";" & .y & "."
                ID2 = mp.ID(.x,.y)
                tx2 = .x
                ty2 = .y
                
                if .y <= ubound(mp.ID,2)-4 then
                    for x as integer = .x-4 to .x+4
                        if x >= lbound(mp.ID,1) andalso x <= ubound(mp.ID,1) then
                            if .y+yy <= ubound(mp.ID,2) then
                                tmsg+=mp.ID(x,.y+yy) & ";" & x & ";" & .y+yy & "."
                            end if
                        end if
                    next x
                end if
            else
                putMsg(i,"no.")
                exit sub
            end if
            
        case ml
            xx-=4
            if .x-1 >= lbound(mp.ID,1) andalso mp.ID(.x-1,.y) = 1 then
                mp.ID(.x,.y) = 1
                tmsg+=mp.ID(.x,.y) & ";" & .x & ";" & .y & "."
                ID1 = mp.ID(.x,.y)
                tx1 = .x
                ty1 = .y
                
                .x-=1
                
                mp.ID(.x,.y) = 3
                tmsg+=mp.ID(.x,.y) & ";" & .x & ";" & .y & "."
                ID2 = mp.ID(.x,.y)
                tx2 = .x
                ty2 = .y
                
                if .x >= lbound(mp.ID,1)+4 then
                    for y as integer = .y-4 to .y+4
                        if y >= lbound(mp.ID,2) andalso y <= ubound(mp.ID,2) then
                            if .x+xx >= lbound(mp.ID,1) then
                                tmsg+=mp.ID(.x+xx,y) & ";" & .x+xx & ";" & y & "."
                            end if
                        end if
                    next y
                end if
            else
                putMsg(i,"no.")
                exit sub
            end if
            
        case mr
            xx+=4
            if .x+1 <= ubound(mp.ID,1) andalso mp.ID(.x+1,.y) = 1 then
                mp.ID(.x,.y) = 1
                tmsg+=mp.ID(.x,.y) & ";" & .x & ";" & .y & "."
                ID1 = mp.ID(.x,.y)
                tx1 = .x
                ty1 = .y
                
                .x+=1
                
                mp.ID(.x,.y) = 3
                tmsg+=mp.ID(.x,.y) & ";" & .x & ";" & .y & "."
                ID2 = mp.ID(.x,.y)
                tx2 = .x
                ty2 = .y
                
                if .x <= ubound(mp.ID,1)-4 then
                    for y as integer = .y-4 to .y+4
                        if y >= lbound(mp.ID,2) andalso y <= ubound(mp.ID,2) then
                            if .x+xx <= ubound(mp.ID,1) then
                                tmsg+=mp.ID(.x+xx,y) & ";" & .x+xx & ";" & y & "."
                            end if
                        end if
                    next y
                end if
            else
                putMsg(i,"no.")
                exit sub
            end if
        end select
        
        for j as integer = lbound(pl) to ubound(pl)
            if pl(j).sock <> 0 andalso j <> i then
                if abs(pl(j).x-tx1) <= 4 andalso abs(pl(j).y-ty1) <= 4 then
                    ymsg+=mp.ID(tx1,ty1) & ";" & tx1 & ";" & ty1 & "."
                end if
                if abs(pl(j).x-tx2) <= 4 andalso abs(pl(j).y-ty2) <= 4 then
                    ymsg+=mp.ID(tx2,ty2) & ";" & tx2 & ";" & ty2 & "."
                end if
                ymsg+="en."
                putMsg(j,ymsg)
            end if
        next j
        
        tmsg+="en."
        putMsg(i,tmsg)
    end with
end sub