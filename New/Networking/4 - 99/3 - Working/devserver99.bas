#include once "fbgfx.bi"
#include once "wshelper.bas"

using fb

randomize timer


enum fl
    runServer
    shutdown
end enum

enum ClientStatus
    notConnected
    waitAuth
    playing
    
    sendID
    sendCoords
    sendMap
    sendPlayers
end enum

enum directionEnum
    mu
    md
    ml
    mr
end enum

type serverProp
    as integer sock
    as uinteger port
    
    as integer maxPlayers,playerCount
    as fl flag
end type
dim shared as serverProp sv

type playerProp
    as socket sock
    as long ip,port
    
    as ClientStatus status
    as directionEnum direct
    
    as zstring*32 smsg
    as zstring*32 chat
    as uinteger ID,x,y
    as double joinTime
end type

type mapProp
    as ubyte ID(1 to 50,1 to 20)
    as zstring*2 mask(1 to 50,1 to 20)
end type

dim shared as ubyte buffer
dim shared as string smsg,smsg2
dim shared as integer iresu

dim shared as playerProp pl(),plTmp
dim shared as mapProp mp

#include once "svFunc.bas"

print "Setting up server..."
init()

redim shared as playerProp pl(1 to sv.maxPlayers)

print "Running server..."
do
    'Check for new clients trying to connect to the server
    if hSelect(sv.sock) then
        'Check if the server is full
        if sv.playerCount < sv.maxPlayers then
            'Find which slot is empty
            for i as integer = lbound(pl) to ubound(pl)
                with pl(i)
                    if .sock = 0 then
                        'Slot is empty so fill it and increase player count
                        print "Client connected: " & i
                        
                        addClient(i)
                        .status = waitAuth
                        
                        exit for
                    end if 'End empty slot found
                end with
            next i
        else
            'Server is full
            print "Client connected but the server is full..."
            serverFull()
        end if
    else
        'Manage existing clients
        for i as integer = lbound(pl) to ubound(pl)
            with pl(i)
                if .sock then
                    if hSelect(.sock) then
                        'The client has sent us a message
                        getMsg(i)
                        
                        if iResu <= 0 then
                            'The client has disconnected
                            print "Client disconnected: " & i
                            removeClient(i)
                            
                        else
                            'Do stuff with the new data we got in 'smsg'
                            
                            select case .status
                            case waitAuth
                                'This client needs to be authenticated still
                                select case left(.smsg,3)
                                case "cn."
                                    'Auth is good
                                    print "Client authenticated: " & i,.smsg,iresu
                                    authClient(i)
                                    spawnPlayer(i)
                                    putMsg(i,"ys.")
                                    
                                case else
                                    'Auth is bad
                                    print "Bad auth from client: " & i,.smsg,iresu
                                    putMsg(i,"ba.")
                                    
                                end select
                                
                            case playing
                                select case left(.smsg,3)
                                case "mu."
                                    .direct = mu
                                    move(i)
                                    
                                case "md."
                                    .direct = md
                                    move(i)
                                    
                                case "ml."
                                    .direct = ml
                                    move(i)
                                    
                                case "mr."
                                    .direct = mr
                                    move(i)
                                    
                                case "rm."
                                    print i & " requested map...rm"
                                    sendMap(i)
                                    print "en."
                                    
                                case "dc."
                                    print i & " disconnected...dc"
                                    putMsg(i,"ys.")
                                    removeClient(i)
                                    
                                case "ri."
                                    print i & " requested their ID...ri"
                                    putMsg(i,str(.ID) & ".")
                                    
                                case "rc."
                                    print i & " requested their coords...rc"
                                    putMsg(i,str(.x & ";" & .y & "."))
                                    print .x,.y
                                    
                                case "rp."
                                    print i & " requested player count...rp"
                                    putMsg(i,str(sv.playerCount) & ".")
                                    
                                case "ms;"
                                    .chat = mid(.smsg,4)
                                    print i & ": " & .chat
                                    putAll("ms;" & i & ";" & .chat)
                                    
                                case else
                                    print "Unknown message:" & i,.smsg
                                    putMsg(i,"no.")
                                    
                                end select
                                
                            end select 'End status
                        end if 'End get message
                    end if
                    
                    select case .status
                    case waitAuth
                        'Lets timeout people who have not been authed yet after an amount of time
                        if (timer-.joinTime) > 5 then
                            print "Client timed out...ba/to"
                            putMsg(i,"to.")
                            removeClient(i)
                        end if
                    case playing
                        
                    end select
                end if 'End check socket
            end with
        next i
    end if 'End hSelect
    
    '
    
    controller()
    sleep 50,1
loop until sv.flag = fl.shutdown

print "Shutting down..."

putAll("sh.")
hclose(sv.sock)

print "Done!"

end 0