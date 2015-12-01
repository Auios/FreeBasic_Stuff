#include "wshelper.bas"

width 80,500 'Thanks xD

'so starting up and connecting to someone is really easy...

hStart() 'this initialize the socket system

'now we need to create a socket (each connection uses one)

var MySocket = hOpen() 'create an TCP socket

'now you want to connect to somehwere so you need an IP
'then we better resolve a hostname to an IP (the server IP)

var sHost = "108.75.36.55" '"mysoft.zapto.org" 'At the start of the program, I can call for a custom IP Using sHost? yes
input "Hostname? ",sHost
var MyIP = hResolve(sHost) 'so this resolve host to IP
'just print out the ip it resolved btw MyIP will be 0 in case of faillure.
print "'"+sHost+"' resolved to: "+hIPtoString(MyIP)

var MyPort=12345
input "What port";MyPort

'so now we have a socket, and we have an IP
'then now all left is connect, and then send/receive packets
var iResu = hConnect(MySocket,MyIP,MyPort) 'socket/ip/port
if iResu then 'just print result of connection attempt
    print "Connected..."
else
    print "Connection failed :("
    sleep:end
end if

var sBuffer = space(8192) 'just creating a buffer to receive data
'this will wait for a packet to arrive it can be as long as the maximum
'value we allowed on the third parameter, in this case i reserved 8kb.
'remember the space() is very important because it will not 'create'
'a string for you, it just fills part of the string with the received data' 

dim as string sText,sName
dim as integer iMustUpdate = 1

input "NickName: ",sName
sName = left$(sName,16)
if len(sName) = 0 then end 'empty to quit

sText = "$AuTh$"+sName
hSend(MySocket,sText,len(sText))
sText = ""
'k
do
    'this check if there's something to be read or write (0=read,1=write)
    var iTest = hSelect( MySocket, 0 )
    if iTest then  
        locate ,1: print space(78);: locate,1 'clear current line
        iResu = hReceive(MySocket,sBuffer,len(sBuffer)) 'i will limit to 8 bytes per message
        if iResu <=0 then 
            print "Connection closed from remote side."
            print "Test: " & iTest
            'exit do
        else 
            if sBuffer[0] = 255 then '
                color 13 : print mid(sBuffer,2,iResu-1): color 7 
            else
                color 8: print time$ + " ";
                color 7: print left(sBuffer,iResu)
            end if
        end if
        
        iMustUpdate = 1
    else 
        do
            var sKey = inkey$()
            if len(sKey) = 0 then exit do
            select case sKey[0]
            case 8 'Backspace
                if len(sText) then sText = left$(sText,len(sText)-1) 
            case 13 'Send
                hSend(MySocket,sText,len(sText))
                locate ,1
                color 8: print time$+" ";
                color 7: print sName+": "+sText
                sText = ""
            case 27 'Quit
                exit do,do
            case 255 'Action keys
                'Action keys (ignore)
            case else
                if len(sText) < 60 then sText += sKey
            end select
            iMustUpdate=1
        loop
        if iMustUpdate then
            locate ,1: color 15 'starting from the being of current line
            print "> "+sText+chr$(32,32,8,8); 'text+clear two bytes ahead
            color 7: iMustUpdate = 0
        end if        
        sleep 10,1
    end if
loop

'now i will close the socket...
hClose(MySocket)
print "socket closed and... done"

'that's it, start the server and let's try :P
'ok now there's the bug