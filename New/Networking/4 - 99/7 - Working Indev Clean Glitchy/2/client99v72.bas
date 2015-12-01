'http://codeshare.io/BzbCn

#include "wshelper.bas"
#include "fbgfx.bi"
#include "scrn.bas"

using fb

randomize 1

print "Setting up..."

declare sub init()
declare sub sendAuth()
declare sub renderWorld()
declare sub requestMap()

type serverProp
    as socket sock
    as zstring*32 ip1
    as long ip2,port
    
    as ubyte cmd
    as short x,y
    as ubyte tl
end type

dim shared as string key
dim shared as ubyte snd
dim shared as ubyte map(1 to 50,1 to 20)

dim shared as serverProp sv

sub init()
    hStart()
    
    with sv
        .sock = hOpen()
        .port = 28000
    end with
end sub

sub sendAuth()
    print "Sending auth to server..."
    snd = 1
    hSend(sv.sock,cast(any ptr,@snd),sizeof(ubyte))
end sub

sub renderWorld()
    for y as short = lbound(map,2) to ubound(map,2)
        for x as short = lbound(map,1) to ubound(map,1)
            select case map(x,y)
            case 0
                locate(y,x):color 3:print "."
            case 1
                locate(y,x):color 2:print "-"
            case 2
                locate(y,x):color 8:print chr(219)
            case 3
                locate(y,x):color 14:print chr(2)
            end select
        next x
    next y
    
    color 7
end sub

sub requestMap()
    do
        if hSelect(sv.sock) then hReceive(sv.sock,cast(any ptr,@sv.cmd),sizeof(ubyte))
        if sv.cmd = 12 then
            if hSelect(sv.sock) then hReceive(sv.sock,cast(any ptr,@sv.x),sizeof(short))
            if hSelect(sv.sock) then hReceive(sv.sock,cast(any ptr,@sv.y),sizeof(short))
            if hSelect(sv.sock) then hReceive(sv.sock,cast(any ptr,@sv.tl),sizeof(ubyte))
            print sv.cmd & "," & sv.x & "," & sv.y & "," & sv.tl
            map(sv.x,sv.y) = sv.tl
        end if
        loop until sv.cmd = 13
    print sv.cmd
end sub

init()

dim as string ans

'Menu
print "-----"
print "1. localhost"
print "2. Cca's server"
print "3. Coach's Corner"
print "4. Custom IP"
print
print "0. Exit"
print "-----"
input "Input: " , ans

select case ans
case "0"
    stop 0
case "1"
    sv.ip1 = "localhost"
case "2"
    sv.ip1 = "108.75.38.19"
case "3"
    sv.ip1 = "68.40.180.165"
case "4"
    input "Enter IP: ",sv.ip1
case else
    print "Nope..."
    sleep:stop 0
end select

print "Establishing connection to: " & sv.ip1 & " : " & sv.port
    sv.ip2 = hResolve(sv.ip1)
    print sv.ip1
    print sv.ip2
    print sv.sock
    print sv.port
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
                exit select
                
            case 2 'No
                print "Server: No"
                exit select
                
            case 5 'Server is full
                print "Failed to join... Server is full..."
                sleep:exit do
                exit select
                
            case 6 'Get map
                requestMap()
                renderWorld()
                exit select
                
            case 9 'Server requested Auth
                print "Server requested auth..."
                sendAuth()
                exit select
                
            case else 'Unknown data from server
                print "Unknown cmd byte - " & sv.cmd
                exit select
                
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
        exit select
        
    case "r" 'Request map
        snd = 9
        hSend(sv.sock,cast(any ptr,@snd),sizeof(ubyte))
        exit select
        
    case "f" 'Render world
        renderWorld()
        exit select
        
    case "w" 'Move Up
        snd = 4
        hSend(sv.sock,cast(any ptr,@snd),sizeof(ubyte))
        exit select
        
    case "s" 'Move down
        snd = 5
        hSend(sv.sock,cast(any ptr,@snd),sizeof(ubyte))
        exit select
        
    case "a" 'Move Left
        snd = 6
        hSend(sv.sock,cast(any ptr,@snd),sizeof(ubyte))
        exit select
        
    case "d" 'Move Right
        snd = 7
        hSend(sv.sock,cast(any ptr,@snd),sizeof(ubyte))
        exit select
        
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