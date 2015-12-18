#include "fbgfx.bi"
#include "wshelper.bas"

declare sub SendToAll( FromID as integer, sText as string )    

width 80,500

hStart() 'this initialize the socket system

'now we need to create a socket (each connection uses one)

var ServerSock = hOpen() 'create an TCP socket
print "Opening socket '" & ServerSock & "'"

'so now that we have the socket we must BIND it to a port number
hBind( ServerSock , 12345 ) 'bind to the PORT that will listen 
'dumb us? IKr
'and then we set this socket as a listener...
hListen( ServerSock ) 'ServerSocket will be listening

'after that it will be listening, but it will immediatelly
'reach this point.... now the hAccept() that will be
'waiting for a connection and it will BLOCK until someone connects
'so for now that doesnt matter, as we must wait at least
'one client to connect anyway :)
var ServerIP = "25.37.119.230"
print "This IP is "+ServerIp
print

enum ClientStatus 'Client Status
    csNotConnected
    csWaitAuth
    csReady
    csLast
end enum

type ClientInfo
    tSocket as socket
    iStatus as ClientStatus 'this is a integer anyway ok? :P
    sNick as string*16
    iIP as long
    iPort as long
end type

dim shared as ClientInfo tClients(15) 'max 16 clients
dim as integer iClientCount
var RecvBuff = space(8192)

do
    'Checking if client connected....
    if hSelect( ServerSock ) then 'There's a client waiting to connect?
        'yes let's accept it and add to the list.
        dim as integer CNT
        for CNT = 0 to ubound(tClients)
            with tClients(CNT) 
                if .tSocket = 0 then 'free slot!
                    .tSocket = hAccept( ServerSock , .iIP , .iPort )'Socket, Client IP, client Port
                    color 13:print "Client #" & CNT & " Connected. " _ 'The _ is a continuation of one line on two
                    "("+hIPtoString(.iIP)+":" & .iPort & ")":color 7
                    iClientCount += 1: .iStatus = csWaitAuth 'adds one to the pot.
                    print "Clients connected: " & iClientCount                    
                    exit for
                end if
            end with
        next CNT
        if CNT > ubound(tClients) then 'no free slots :(
            print "WARNING: Server is full"
            dim as long iTempIP,iTempPort
            var TempSocket = hAccept( ServerSock ,iTempIP , iTempPort )
            hClose(TempSocket) 'reject connection
        end if
    end if
    
    ' now let's manage our client's
    for CNT as integer = 0 to ubound(tClients)
        with tClients(CNT)
            if .tSocket andalso hSelect( .tSocket ) then 
            'checking if used slot received/closed
                var iSz = hReceive( .tSocket, RecvBuff , len(RecvBuff) ) 'What is iSz?
                'the result (integer) of hReceive it says how many bytes were written to the buffer
                if iSz <=0 then
                    if .iStatus = csReady then
                        print "Client '"+.sNick+"'";
                        SendToAll( CNT , chr$(255)+.sNick + " left the room." )
                    else
                        print "Client #" & CNT;
                    end if
                    color 13:print " ("+hIPtoString(.iIP)+":" & .iPort & ") " _
                    "DISCONNECTED!":color 7
                    hClose(.tSocket) 'i will close it to make sure it will not be a ghost socket.
                    iClientCount -= 1: .tSocket = 0 'free slot
                    .iStatus = csNotConnected 'just to make it sane :)
                    print "Clients connected: " & iClientCount                    
                else
                    select case .iStatus
                    case csWaitAuth
                        if left$(RecvBuff,6) = "$AuTh$" then 'protection to avoid mistakes
                            .sNick = mid$(left$(RecvBuff,iSz),7,16) '16= max nick size Sure
                            .iStatus = csReady
                            print "Client #" & CNT & " Authenthicated as '"+.sNick+"'" 
                            SendToAll( CNT , chr$(255)+.sNick+" joined the room." )
                        end if
                    case csReady
                        print "Client '"+.sNick+": "+left$(RecvBuff,iSz)+"'"
                        SendToAll( CNT , .sNick+": "+left$(RecvBuff,iSz) )
                    end select
                end if
            end if
        end with
    next CNT
    
    sleep 50,1 'just wait a bit (50ms is a lot but fine :P)
loop until multikey(fb.SC_ESCAPE) 'ESC quit Why do you fb.SC? it works without the fb.

hClose(ServerSock)
print "Done."
sleep

sub SendToAll( FromID as integer, sText as string )
    for CNT as integer = 0 to ubound(tClients)
        with tClients(CNT) 
            if .tSocket andalso CNT<>FromID then
                hSend( .tSocket , sText , len(sText) )
            end if
        end with
    next CNT
end sub