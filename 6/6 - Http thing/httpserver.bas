#include "wshelper.bi"

type connection
    as socket sock
    as integer ip
    as ulong port
    
    as zstring*1024*4 buffer = space(1024)
    
    declare sub init(port as ulong)
end type

sub connection.init(port as ulong)
    with this
        .port = port
        .sock = hOpen()
        hBind(.sock,.port)
        hListen(.sock)
    end with
end sub

dim as connection sv,cl
dim as boolean runServer = true
dim as integer connectCount = 0

hStart()
sv.init(80)

while(runServer)
    var k = inkey()
    select case k
    case chr(27)
        runServer = false
    case "d"
        if(cl.sock) then
            hClose(cl.sock)
            cl.sock = 0
        end if
    end select
    
    if(hSelect(sv.sock)) then
        if(cl.sock = 0) then
            connectCount+=1
            print("Client connected")
            print(connectCount)
            cl.sock = hAccept(sv.sock,cl.ip,sv.port)
            cl.buffer = space(1024)
            var bytesIn = hReceive(cl.sock,cl.buffer,1024*4)
            
            dim as integer ran = 1000*rnd
            dim as string bufferSend = !"HTTP/1.1 200 OK\nAccept-Ranges: bytes\nConnection: close\nContent-Type: text/html\n\n<html><body><p>" & ran & "</p></body></html>"
            hSend(cl.sock,bufferSend,len(bufferSend))
            
            hClose(cl.sock)
            cl.sock = 0
            print("Client disconnected")
        end if
    end if
    sleep(1,1)
wend

hClose(sv.sock)
hShutdown()