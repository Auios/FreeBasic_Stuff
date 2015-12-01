#include "fbgfx.bi"
using fb
#include "wshelper.bas"
#include "scrn.bas"
#include "crt.bi"
randomize timer

declare function GetArg(stri as string, x as short) as string

hStart()

var SocketTCP = hOpen()
var SocketUDP = hOpenUDP()
var SocketUDPt = hOpenUDP()

dim shared as string HostIP
dim shared as integer Port

'===============================================================================

var sel = 1
select case sel
case 1
    'Red
    HostIP = "108.243.220.199"
    Port = 12878
case 2
    'Kirby
    HostIP = "71.239.44.241"
    Port = 12345
case 3
    'Mysoft
    HostIP = "177.5.188.148"
    Port = 12345
end select

dim shared as string sMsg
var sBuff = space(8192)

dim shared as string sKey,sText

dim shared as ushort iUpdate

Dim shared as EVENT e

'===============================================================================

hBind(SocketUDPt,Port)

print "Attempting to connect to host..."
var MyIP = hResolve(HostIP)
hConnect(SocketUDP,MyIP,Port)'socket/ip/port

sel = 2
select case sel
case 1
    input "Name: ", sMsg
    sMsg = "cmd;name=" & sMsg
case 2
    sMsg = "cmd;name=Cca"
end select
hSendUDP(SocketUDP,MyIP,Port,sMsg,len(sMsg))

scrn(800,600,32,0)

'===============================================================================

do
    if hSelect(SocketUDP) then
        var iPacketSz = hReceiveUDP(SocketUDP,MyIP,Port,sBuff,len(sBuff))
        
        sMsg = left(sBuff,iPacketSz)
        
        if sMsg = "ping" then
            puts "ping"
            sMsg = "pong"
            hSendUDP(SocketUDP,MyIP,Port,sMsg,len(sMsg))
        else
            select case GetArg(sMsg,0)
            case "connection"
                select case GetArg(sMsg,1)
                case "connect"
                    puts "Connected to server..."
                    print "Connected to server..."
                
                case "name"
                    if GetArg(sMsg,4) <> "" then
                        print GetArg(sMsg,4) & " changed their name to " & GetArg(sMsg,5)
                    end if
                end select
                
            case "chat"
                print GetArg(sMsg,3) & ": " & GetArg(sMsg,4)
                
            case "return"
                select case GetArg(sMsg,1)
                case "list"
                    print GetArg(sMsg,4)
                end select
            end select
        end if
    else
        if (ScreenEvent(@e)) Then
            Select Case e.type
            'On key press
            Case EVENT_KEY_PRESS
                if multikey(sc_t) then
                    While Inkey <> "": Wend
                    input "Input: ",sMsg
                    sMsg = "chat;" & sMsg
                    hSendUDP(SocketUDP,MyIP,Port,sMsg,len(sMsg))
                end if
                
                if multikey(sc_slash) then
                    While Inkey <> "": Wend
                    input "cmd: ",sMsg
                    sMsg = "cmd;" & sMsg
                    hSendUDP(SocketUDP,MyIP,Port,sMsg,len(sMsg))
                end if
            end Select
        end If
    end if
loop until multikey(sc_escape)

sMsg = "cmd;disc"
hSendUDP(SocketUDP,MyIP,Port,sMsg,len(sMsg))

hClose(SocketUDPt)
hClose(SocketUDP)
hClose(SocketTCP)

function GetArg(stri as string, x as short) as string
    dim as string array(0 to len(stri))
    stri+=";" 'Add the split char at the end for laziness
    
    dim as integer oldI = 0
    dim as integer count = 0
   
    for i as integer = 1 to len(stri) 'run a for loop for the entirety of the string
        var strichar = mid(stri, i, 1) 'cycle through each char of the string
        
        if strichar = ";" then 'If the char equals the split char
            redim preserve array(0 to count) 'redim our array to fit the current count
            array(count) = mid(stri, oldI+1, (i-oldI)-1) 'put our split into the index
            oldI = i
            count += 1
        end if
    next i
    
    if x <= UBound(array) then
        function = array(x)
    else
        function = ""
    end if
end function