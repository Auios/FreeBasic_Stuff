'http://codeshare.io/BzbCn

#include "wshelper.bas"
#include "fbgfx.bi"
#include "scrn.bas"

using fb

randomize 1

print "Setting up..."

'screen 11
'windowtitle "Client v.7"

declare sub init()
declare sub sendAuth()

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

sub sendAuth()
    print "Sending auth to server..."
    snd = 1
    hSend(sv.sock,cast(any ptr,@snd),sizeof(ubyte))
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

do 'Main loop
    if hSelect(sv.sock) then 'Message from server
        iResu = hReceive(sv.sock,cast(any ptr,@sv.cmd),sizeof(ubyte))
        
        if iResu <= 0 then 'Server shutdown/error
            print "Server shutdown..."
            sleep:exit do
            
        else 'Manage data from server
            select case sv.cmd
            case 1 'Yes
                print "Server: Yes"
                
            case 2 'No
                print "Server: No"
                
            case 5 'Server is full
                print "Failed to join... Server is full..."
                sleep:exit do
                
            case 9 'Server requested Auth
                print "Server requested auth..."
                
                sendAuth()
                
            case else 'Unknown data from server
                print "Unknown cmd byte - " & sv.cmd
            end select
        end if
    end if
    
    key = inkey()
    select case key
    case "q" 'Disconnect from server
        snd = 2
        hSend(sv.sock,cast(any ptr,@snd),sizeof(ubyte))
        print "Disconnected from server"
        exit do
    case "t" 'Custom message
        input snd
        hSend(sv.sock,cast(any ptr,@snd),sizeof(ubyte))
        
    case "" 'Nothing
        exit select
        
    case else 'Unknown
        print "Unknown keypress: " & key
    end select
    while inkey<>"":wend
    
    sleep 1,1
loop until key = "q"

'Send disconnect byte
snd = 2
hSend(sv.sock,cast(any ptr,@snd),sizeof(ubyte))

hclose(sv.sock)
hShutdown()