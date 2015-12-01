#include "wshelper\wshelper.bas"

'so starting up and connecting to someone is really easy...

hStart() 'this initialize the socket system

'now we need to create a socket (each connection uses one)

var MySocket = hOpen() 'create an UDP socket

'now you want to connect to somehwere so you need an IP
'then we better resolve a hostname to an IP (the server IP)

function hSendMessage(tSocket as socket,sMessage as string) as integer
    return hSend(tSocket,sMessage,len(sMessage)
end function
    
var sHost = "201.14.170.16" '"mysoft.zapto.org" 'At the start of the program, I can call for a custom IP Using sHost? yes
input "Hostname? ",sHost 'cool
var MyIP = hResolve(sHost) 'so this resolve host to IP
'just print out the ip it resolved btw MyIP will be 0 in case of faillure.
print "'"+sHost+"' resolved to: "+hIPtoString(MyIP)

'so now we have a socket, and we have an IP
'then now all left is connect, and then send/receive packets
var iResu = hConnect(MySocket,MyIP,999) 'socket/ip/port
if iResu then 'just print result of connection attempt
    print "Connected..."
else
    print "Connection failed :("
    sleep:end
end if

dim as string sBuffer = "Hello is anybody there?" 'This is the data I send? yes
'it can be done directly like this
hSendMessage(MySocket,"Hello!")
'so you can make it do this if you want :) Thank you

'sending bytes from the sbuffer string to mysocket (the last is amount)
'well i'm using the sBuffer, so then len(sBuffer) will get the length
'of the data tin the buffer, so you don't need to specify'
iResu = hSend(MySocket,sBuffer,len(sBuffer))'What is this then? Oh I get it. xD
print "Send " & iResu & " bytes"

print "Waiting answer...."

sBuffer = space(8192) 'just creating a buffer to receive data
'this will wait for a packet to arrive it can be as long as the maximum
'value we allowed on the third parameter, in this case i reserved 8kb.
'remember the space() is very important because it will not 'create'
'a string for you, it just fills part of the string with the received data' 
do
    'this check if there's something to be read or write (0=read,1=write)
    if hSelect( MySocket, 0 ) then 
        iResu = hReceive(MySocket,sBuffer,len(sBuffer)) 'i will limit to 8 bytes per message
        if iResu <=0 then 
            print "Connection closed from remote side."
            exit do
        end if
        print "Received " & iResu & " bytes"
        print "'"+left(sBuffer,iResu)+"'"
    else
        print ".";
        sleep 50,1
    end if
loop

'now i will close the socket...
hClose(MySocket)
print "socket closed and... done"

'and just for good behave i will shutdown the socket system
hShutdown()
sleep

'well one more thing first 'let's make it receive messages
'until the socket is closed from here...

'Interesting. So 1 byte = 1 character? yes you did ctrl+c?
'No why? it should not have closed on it's own
'Im not sure. oh well let's make it be a normal size of the input buffer
'Cool 'now just one more little test, to make sure of something i'm in dobut
'Is it bad that it does not get 0 bytes?
'no it actually good...
'i wasnt 100% sure if it would be possible
'but the thing is... when the socket is closed sucessfully
'hreceive will return 0.
'and if something happened (timeout,broken socket,connection loss...)
'hreceive will return 0
'that's why i made it be <= 0
'Ok.
'Nevermind k
'So now what? now we go to the freebasic folder as i sent you
'the wrong wshelper :)
'so this extra function... is what was left, something that is very useful
'this hSelect, is a function that will allow the app to not be blocked
'so that means you can use this Select() function to not block the app
'so you can check for 'events' every frame
'without  disturbing the game, and without more complex 'threads"
'which is how those examples you got are doing.
'I dont like threads xD, good for you i did this hSelect then, right? :)
'Correct :D, i think the alternative libraries for freebasic, they all have
'callback functions to receive events, when something happen
'but in the end they are using a thread, to wait and then dispatch those callbacks.
'i just happen to like this way with a single thread as well.
'So how about a server now? yes, you have any qeustions so far?
'That's all I need. Server now? yes ok should we change back to keep this client working? :P
'This client will be my example . well this client is able to connect to our server yes
'We can make a copy of it.