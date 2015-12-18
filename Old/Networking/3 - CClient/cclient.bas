#include "fbgfx.bi"
using fb
#include "wshelper.bas"
#include "scrn.bas"
#include "crt.bi"
randomize timer

hstart()
var SocketTCP = hOpen()
var SocketUDP = hOpenUDP()
var S0cketUDP = hOpenUDP()
var Port = 12878
'var Port = 12345
var HostIP = "108.243.220.199"
'var HostIP = "71.239.44.241"
'var HostIP = "177.5.188.148"

dim shared as string sMsg
dim shared as string sign
var sBuffer = space(8192)

scrn(800,600,32,0)

input "Name: ", sign

print "Attempting to connect to host..."
var MyIP = hResolve(HostIP)
var iResu = hConnect(SocketUDP,MyIP,Port)'socket/ip/port
if iResu then
    print "Connected..."
else
    print "Connection failed..."
    sleep:stop
end if

hBind(S0cketUDP,Port)

sMsg = "cmd;name=" & sign
hSendUDP(SocketUDP,MyIP,Port,sMsg,len(sMsg))

do
    if hselect(SocketUDP) then
        printf "Recieve"
       
        var iPacketSz = hReceiveUDP(SocketUDP,MyIP,Port,sBuffer,len(sbuffer))
        if left$(sBuffer,iPacketSz) = "ping" then
            printf "Ping"
            sMsg = "pong"
            hSendUDP(SocketUDP,MyIP,Port,sMsg,len(sMsg))
        else
            print "["+left$(sBuffer,iPacketSz)+"]",iPacketSz
        end if
    else
        if multikey(sc_t) then
            Input "Input: ",sMsg
            hSendUDP(SocketUDP,MyIP,Port,sMsg,len(sMsg))
        end if
    end if
   
    sleep 1,1
loop until multikey(sc_escape)

sMsg = "cmd;disc"
hSendUDP(SocketUDP,MyIP,Port,sMsg,len(sMsg))

hClose(SocketUDP)
hClose(S0cketUDP)
hClose(SocketTCP)
sleep