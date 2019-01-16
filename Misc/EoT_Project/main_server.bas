#include "netWrapper.bi"
#include "packetHandler.bi"
#include "debugTools.bi"

dim as _CONNECTION_ sv,cl
dim shared as boolean runServer = true
dim as integer bytes
dim as any ptr buffer
buffer = allocate(256)

db("----Server----")
db("Starting WSA...")

if(nw_start() <> 0 ) then
    color 12: db("ERROR: WSAStartup failed"): color 7
    sleep
    end
end if

nw_listen(@sv, 28000)

while(runServer)
    var k = inkey()
    if(k = chr(27)) then runServer = false
    
    'Trying to detect a client connecting to the server
    if(cl.socket = 0) then
        nw_set(sv)
        if(nw_select()) then
            if(nw_isSet(sv,S_ERROR)) then
                dbError("Error: " & wsaGetLastError())
                exit while
            end if
            
            if(nw_isSet(sv,S_RECV)) then
                bytes = len(cl.socket_in)
                cl.socket = accept(sv.socket,cptr(sockaddr ptr, @cl.socket_in),@bytes)
                
                if(cl.socket = INVALID_SOCKET) then
                    cl.socket = 0
                    cl.socket_in = null_addr_in
                else
                    db("Client connected!")
                end if
            end if
        end if
    end if
    
    if(cl.socket) then
        nw_set(cl)
        if(nw_select()) then
            if(nw_isSet(cl,S_ERROR)) then
                db("Client error: " & wsaGetLastError())
                nw_disconnect(@cl)
                cl.socket = 0
                cl.socket_in = null_addr_in
            end if
            
            if(nw_isSet(cl,S_RECV)) then
                bytes = nw_recv(sv,buffer,256)
                if(bytes < 0) then
                    db("Client disconnected: " & bytes & " : " & wsaGetLastError())
                    nw_disconnect(@cl)
                else
                    db("Client sent data: " & bytes)
                end if
            end if
        end if
    end if
    
    sleep(1,1)
wend

db("Shutting down...")

if(cl.socket > 0) then
    db("Disconnecting the client...")
    nw_disconnect(@cl)
end if

deallocate(buffer)
nw_disconnect(@sv)