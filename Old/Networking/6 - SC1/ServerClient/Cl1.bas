#include "wshelper.bas"
#include "fbgfx.bi"
#include "scrn.bas"

using fb

randomize 1

print "Setting variables..."

declare sub init()

type serverProp
    as socket sock
    as zstring*32 ip1
    as long ip2,port
    
    as ubyte cmd
end type

dim shared as string key
dim shared as ubyte snd

dim shared as serverProp sv

sub init()
    hStart()
    
    with sv
        
        .sock = hOpen()
        .ip1 = "localhost"
        .ip2 = hResolve(.ip1)
        .port = 28000
    end with
end sub

init()

print "Establishing connection to: " & sv.ip1
var iresu = hConnect(sv.sock,sv.ip2,sv.port)
if iresu then
    print "Connected..."
else
    print "Failed to connect..."
    sleep:stop 1
end if

print "Client running..."
do
    if hSelect(sv.sock) then
        iResu = hReceive(sv.sock,cast(any ptr,@sv.cmd),sizeof(ubyte))
        if iResu <= 0 then
            print "Server shutdown..."
            sleep:exit do
            
        else
            select case sv.cmd
            case else
                print "Unknown cmd byte - " & sv.cmd
            end select
        end if
    end if
    key = inkey()
    select case key
    case "f"
        snd = 1
        hSend(sv.sock,cast(any ptr,@snd),sizeof(ubyte))
    case "q"
        exit do
    case "t"
        input snd
        hSend(sv.sock,cast(any ptr,@snd),sizeof(ubyte))
    case ""
        exit select
        
    case else
        print "Unknown keypress: " & key
    end select
    
    while inkey<>"":wend
    
    sleep 1,1
loop until key = "q"

hclose(sv.sock)
hShutdown()