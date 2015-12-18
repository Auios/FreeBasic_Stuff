'Include wshelper.bas (duh c:)
#include "wshelper.bas"

'Define CRLF as the end-of-line used by sockets
#define CRLF !"\r\n"

'http://forum.blockland.us/index.php?action=profile;u=2

hStart()    'Call the function to start the winsock process

var Sock = hOpen()  'Open a socket and set Sock to the return value
var IP = hResolve("forum.blockland.us") 'Resolve the IP of the URL
if hConnect(Sock,IP,80)=0 then  'If Sock failed to connect,
  print "Failed to connect" 'Print it and stop the program
  sleep: stop
end if

'--Here we're defining a header to send to the website, telling it what we want
var sBuff = "GET /index.php?action=profile;u=2 HTTP/1.1" CRLF _ 'send a GET request including the url path
"Host: forum.blockland.us" CRLF _   'Define the host of the url path
"Accept: text/html" CRLF _          'Tell it what we want
"Connection: close" CRLF CRLF       'Define the type of connection
hSend(Sock,sBuff,len(sBuff))        'Send the buffer

sBuff = space(16384) 'max 16kb for the page
dim as any ptr pBuff = strptr(sBuff)
var iBuffSz = 16384, iSz = 0

do
    if hSelect(sock) = 0 then sleep 1,1:continue do   'Check if our socket is still open (I think)
    var iResu = hReceive(sock,pBuff,iBuffSz)  'Receive data from where our socket is connected
    if iResu <= 0 then exit do              'If we received no data, disconnect
    iBuffSz -= iResu: iSz += iResu          'Do some math stuff
    pBuff += iResu                        'More math stuff
loop while iBuffSz                      'Loop until iBuffSz is <= 0

hClose(sock):sock=0 'Close the socket

sBuff = lcase(left(sBuff,iSz)) 'lowercase
var iPosi = instr(1,sBuff,"<td><b>posts:") 'Get the position of where the post count begins
if iPosi then                           'If iPosi > 0
    iPosi = instr(iPosi+1,sBuff,"<td>")     'Post count
    if iPosi then                         'If iPosi > 0
        var iPosts = valint(mid$(sBuff,iPosi+4,15)) 'Change it into an integer
        print "Posts: " & iPosts    'Print the post count
    end if
end if
if iPosi=0 then 'If we somehow didn't get a post count
  print "Something went wrong..."
end if

sleep