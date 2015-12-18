
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
    
    as ubyte cmd,sz
    
    as integer maxPlayers,playerCount
    as fl flag
end type
dim shared as serverProp sv

type playerProp
    as socket sock
    as long ip,port
    
    as ClientStatus status
    as directionEnum direct
    
    as uinteger ID,x,y
    as double joinTime
end type

dim shared as ubyte map(1 to 50,1 to 20)

dim shared as integer iresu

dim shared as playerProp pl(),plTmp

'include once "svFunc.bas"
#include once "svFunc2.bas"

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
                        getCmd(i)
                        
                        if iResu <= 0 then
                            'The client has disconnected
                            print "Client disconnected: " & i
                            removeClient(i)
                            
                        else
                            'Do stuff with the new data we got in 'smsg'
                            
                            select case .status
                            case waitAuth
                                'This client needs to be authenticated still
                                select case sv.cmd
                                case 1
                                    'Auth is good
                                    print "Client authenticated: " & i,sv.cmd,iresu
                                    authClient(i)
                                    spawnPlayer(i)
                                    putCmd(i,1)
                                    
                                case else
                                    'Auth is bad
                                    print "Bad auth from client: " & i,sv.cmd,iresu
                                    putCmd(i,2)
                                    
                                end select
                                
                            case playing
                                select case sv.cmd
                                case 2
                                    print i & " disconnected...dc"
                                    putcmd(i,1)
                                    removeClient(i)
                                    
                                case 4
                                    .direct = mu
'                                    move(i)
                                    
                                case 5
                                    .direct = md
'                                    move(i)
                                    
                                case 6
                                    .direct = ml
'                                    move(i)
                                    
                                case 7
                                    .direct = mr
'                                    move(i)
                                    
                                case 9
                                    print i & " requested map...rm"
                                    sendMap(i)
                                    print "en."
                                    
                                case else
                                    print "Unknown message:" & i,sv.cmd,iresu
                                    putCmd(i,2)
                                    
                                end select
                                
                            end select 'End status
                        end if 'End get message
                    end if
                    
                    select case .status
                    case waitAuth
                        'Lets timeout people who have not been authed yet after an amount of time
                        if (timer-.joinTime) > 5 then
                            print "Client timed out...ba/to"
                            putCmd(i,11)
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

'putAll("sh.")
hclose(sv.sock)

print "Done!"

end 0