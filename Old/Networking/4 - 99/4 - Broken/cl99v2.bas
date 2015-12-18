
#include "wshelper.bas"
#include "fbgfx.bi"
#include "scrn.bas"
using fb

'var hostIP = "108.75.38.19"
var hostIP = "localhost"
dim as long port = 28000

hstart()
scrn()

dim as integer iresu
dim shared as event e

var myIP = hresolve(hostip)
var sock = hOpen()

iResu = hConnect(sock,MyIP,Port)'socket/ip/port
if iResu then
    print "Connected..."
else
    print "Connection failed..."
    sleep:stop 1
end if

dim as ubyte smsg,sz
dim as short x,y
dim shared as ubyte map(1 to 50,1 to 20)

dim shared as uinteger clr

sub initMap()
    for y as short = lbound(map,2) to ubound(map,2)
        for x as short = lbound(map,1) to ubound (map,1)
            map(x,y) = 0
        next x
    next y
end sub

initMap()

do
    if screenevent(@e) then
        select case e.type
        case event_key_press
            if e.scancode = sc_w then
                smsg = 4
                hSend(sock,cast(any ptr,@smsg),sizeof(smsg))
            end if
            if e.scancode = sc_s then
                smsg = 5
                hSend(sock,cast(any ptr,@smsg),sizeof(smsg))
            end if
            if e.scancode = sc_a then
                smsg = 6
                hSend(sock,cast(any ptr,@smsg),sizeof(smsg))
            end if
            if e.scancode = sc_d then
                smsg = 7
                hSend(sock,cast(any ptr,@smsg),sizeof(smsg))
            end if
            
            if e.scancode = sc_r then
                smsg = 9
                hSend(sock,cast(any ptr,@smsg),sizeof(smsg))
            end if
            
        end select
    end if
    
    if hselect(sock) then
        iResu = hReceive(sock,cast(any ptr,@smsg),1)
        print iresu
        
        if iResu <=0 then
            print "Server shutdown..."
            sleep
            exit do
            
        else
            print "Server: ",smsg,iresu
            
            select case smsg
            case 3
                print "Pong!"
                smsg = 3
                hSend(sock,cast(any ptr,@smsg),sizeof(smsg))
                
            case 6
                print "Getting map!"
                if hSelect(sock) then iResu = hReceive(sock,cast(any ptr,@sz),1)
                
                for i as integer = 1 to sz
                    if hSelect(sock) then iResu = hReceive(sock,cast(any ptr,@x),2)
                    if hSelect(sock) then iResu = hReceive(sock,cast(any ptr,@y),2)
                    if hSelect(sock) then iResu = hReceive(sock,cast(any ptr,@map(x,y)),1)
                    sleep 1,1
                next i
                
                cls
                print "Generating map now"
                for yy as short = lbound(map,2) to ubound(map,2)
                    for xx as short = lbound(map,1) to ubound(map,1)
                        select case map(xx,yy)
                        case 1
                            clr = rgb(100,100,100)
                        case 2
                            clr = rgb(100,200,100)
                        case 3
                            clr = rgb(200,100,100)
                        case 4
                            clr = rgb(100,100,200)
                        end select
                        
                        line(xx*8,yy*8+32)-(xx*8+8,yy*8+40),clr,"bf"
                    next xx
                next yy
                exit select
                
            case 9
                print "Server is requesting auth"
                print "Sending auth"
                smsg = 1
                hSend(sock,cast(any ptr,@smsg),sizeof(smsg))
                exit select
                
            end select
        end if
    end if
    
    sleep 1,1
loop until multikey(sc_escape)

hclose(sock)

While Inkey <> "": Wend
sleep
end 0