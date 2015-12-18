#include "wshelper.bas"
#include "fbgfx.bi"
using fb

hStart()

print "Server started..."

var ServerPort = 28000

var serverSocket = hOpen()
hBind(ServerSocket,ServerPort)
hListen(ServerSocket)

dim as ubyte buffer = 255
dim as string smsg = space(buffer)
dim as integer iresu
dim as uinteger connectedClients,maxClients = 8

type playerProp
    as socket sock
    as long port,ip
    as zstring*16 msg
    as uinteger ID
    as uinteger x,y
end type

dim as playerProp pl(1 to maxClients)
dim as playerProp tmpPl

do
    if hselect(serverSocket) then 'Check for new clients
        if connectedClients < maxClients then 'More slots to fill
            for i as integer = lbound(pl) to ubound(pl) 'Check for which slot is empty
                with pl(i)
                    if .sock = 0 then 'It's empty
                        .sock = haccept(ServerSocket,.ip,.port)
                        
                        smsg = space(buffer)
                        iresu = hreceive(.sock,smsg,buffer)
                        
                        print "Client connected: " & i
                        print .ip
                        print .port
                        
                        smsg = left(smsg,iresu) 'Check auth >cn
                        if smsg = "cn" then 'Send >tr if auth is correct
                            smsg = "tr"
                            hSend(.sock,smsg,buffer)
                            smsg = "" & maxClients
                            hsend(.sock,smsg,len(smsg))
                            
                            connectedClients+=1
                        else 'Send >ba if auth is a bad auth. Kill connection
                            print "Incorrect auth: >" & smsg & "<"
                            smsg = "ba"
                            hSend(.sock,smsg,buffer)
                            hclose(.sock)
                            .sock = 0
                        end if
                        
                        exit for
                    end if
                end with
            next i
        else 'Server is full. Make temporary connection and tell it to fuck off
            with tmpPl
                .sock = haccept(serversocket,.ip,.port)
                smsg = space(buffer)
                iresu = hreceive(.sock,smsg,buffer)
                
                print "Client connected but server is full..."
                if smsg = "cn" then 'Just for shits and giggles we will check the auth.
                    print "    Correct auth..."
                else
                    print "    Incorrect auth: >" & smsg & "<"
                end if
                
                smsg = "sf" 'Send >sf. Server Full
                hsend(.sock,smsg,buffer)
                
                hclose(.sock)
                .sock = 0
            end with
        end if
    else
        'print "Checking..."
        for i as integer = lbound(pl) to ubound(pl)
            with pl(i)
                if .sock andalso hselect(.sock) then 'Did the client send us anything?
                    
                    smsg = space(buffer)
                    iresu = hreceive(.sock,smsg,buffer)
                    
                    if iresu <= 0 then 'Client disconnected
                        hclose(.Sock)
                        .sock = 0
                        print "dc: " & i
                        connectedClients-=1
                    else 'Handle input from client here
                        smsg = left(smsg,iresu)
                        print "" & i & ": " & smsg,iresu
                        
                        smsg = "tr"
                        hSend(.sock,smsg,buffer)
                    end if
                else
                    continue for
                end if
            end with
        next i
    end if
    
    
    sleep 20,1
loop until multikey(sc_escape)

hclose(serverSocket)