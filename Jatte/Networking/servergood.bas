#include "netWrapper.bi"
#include "packetHandlers.bi"
#include "debugTools.bi"

dim as _CONNECTION_ sv,cl
dim shared as boolean runServer = true
dim as long bytes

db("Starting WSA...")

if(nw_start() <> 0 ) then
    color 12: db("ERROR: WSAStartup failed"): color 7
    sleep
    end
end if

nw_listen(sv)

while(runServer)
    var k = inkey()
    if(k = chr(27)) then runServer = false
    
    'Trying to detect a client connecting to the server
    nw_set(sv)
    if(nw_select()) then
        if(nw_isSet(sv,S_ERROR)) then
            dbError("Error: " & wsaGetLastError())
            exit while
        end if
        
        if(nw_isSet(sv,S_RECV)) then
            db("Client attempting to connect")
            bytes = len(cl.socket_in)
            cl.socket = accept(sv.socket,cptr(sockaddr ptr, @cl.socket_in),@bytes)
            
            if(cl.socket<>INVALID_SOCKET) then
                nw_disconnect(@cl)
            else
                cl.socket = 0
                cl.socket_in = null_addr_in
            end if
        end if
    end if
    
    sleep(1,1)
wend

nw_disconnect(@sv)

sleep()