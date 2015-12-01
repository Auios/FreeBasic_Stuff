#include "header.bi"
using fb
randomize timer
printf(!"***** Version 2 *****\n")
printf(!"***** Structures/Types/Constants *****\n")
' ***** Structures/types/constants *****

type ClientData
    as zstring*16 sign
    as integer x,y,ox,oy
    as integer Clr
    as integer inUse
    as integer ID
end type

printf(!"***** Shared Variables/Structures *****\n")
' ***** shared variables/structures *****
dim shared as ClientData cl(SERVER_MAXPLAYERS)
dim shared as ClientData Me
dim shared as socket SockServer 'same everywhere
dim shared as integer Scrnx,scrny

printf(!"***** Subs/Functions *****\n")
' ***** subs/functions *****
sub ProcessServerMessage(pMsg as MessageHeader ptr)
    select case pMsg->iType 'what kind of message the client is sending? '
    case mtSignReply 'server allowed you in the session
        Me.ID = cptr(tMessageSignReply ptr,pMsg)->ID 'this is your ID :)
        Me.InUse = 1
        printf(!"Server accepted auth ID:%i\n",Me.ID) 
        'what is printf? the C runtime print
        'im using printf here to make it print on the console
        'even that the graphical screen is opened. Good idea
    case mtJoin      'some other player joined the server
        with *cptr(tMessageJoin ptr,pMsg)
            var p = @cl(.ID) 'make a pointer from array element
            'this is to avoid using cli(.ID).sign and etc.. (because we can only have one with)
            'so call this "manual" with :P Alrighteh :P
            p->sign = .sign ' "->" means reference to a type member
            p->InUse = 1
            'maybe put some extra action here to announce player join
        end with
    case mtPart      'some other player parted from the server
        with *cptr(tMessagePart ptr,pMsg)
            var p = @cl(.ID)
            p->sign = ""
            p->InUse = 0
            'maybe put some extra action here to announce player part
        end with
    case mtPosition  'server sent new position
        with *cptr(tMessageUpdatePostion ptr,pMsg)
            'initial me.ID is -1 so it will not match any other possible ID
'            printf(!"Client ID:%i x:%i y:%i\n",.ID,.tData.x,.tData.y) 'Can't we
            'use this ^ to print? to print what? to draw? Yes.we can but we have some
            'stupid bug that we must fix. :o
            if .ID = me.ID then 
                me.x = .tData.x
                me.y = .tData.y 'maybe you can use the same tData on me/cl here as well but for now let's try it ifirst
                me.Clr = .tData.iColor   
            else
                cl(.ID).x = .tData.x 'Oh I didn't notice this was already here xD
                cl(.ID).y = .tData.y
                cl(.ID).Clr = .tData.iColor 'What if it is printing, but the color is
                'black :o
            end if
        end with
    end select
end sub
sub RenderStuff() 'Wait a minute... -.-
    cls    
    locate(1,1):print me.x;me.y
    
    
    for i as integer = 0 to SERVER_MAXPLAYERS-1
        with cl(i)            
            if .InUse then
                'printf(!"inside: %i x=%i y=%i",i,.x,.y)
                if abs(.x-.ox) >= scrnx\2 then .ox=.x
                if abs(.y-.oy) >= scrny\2 then .oy=.y
                .ox = (.ox*3+.x)\4 : .oy = (.oy*3+.y)\4
                var iPX = .ox-(len("["+.sign+"]")*4)
                for Y as integer = -scrny to scrny step scrny
                  for X as integer = -scrnx to scrnx step scrnx
                    circle(X+.ox,Y+.oy),15,.Clr',,,,"f"'Other people >.>
                    draw string (X+iPX,Y+.oy-4),"["+.sign+"]",rgb(85,255,85)
                  next X
                next Y
            end if
            'printf(!"outside: %i \n",i)
        end with
    next i
    
    var iPX = me.x-(len("["+me.sign+"]")*4)
    for Y as integer = -scrny to scrny step scrny
        for X as integer = -scrnx to scrnx step scrnx
            circle(X+me.x,Y+me.y),15,me.Clr 'Me :D
            draw string (X+iPX,Y+me.y-4),"["+me.sign+"]",rgb(85,255,85)
        next X
    next Y
end sub

sub Controller()
    with me
        if multikey(sc_w) then .y-=1
        if multikey(sc_s) then .y+=1
        if multikey(sc_a) then .x-=1
        if multikey(sc_d) then .x+=1
        
        if .x >= scrnx then .x-=scrnx
        if .x < 0 then .x+=scrnx
        if .y >= scrny then .y-=scrny
        if .y < 0 then .y+=scrny
    end with
end sub

printf(!"***** Start of the Code *****\n")
' ************************ Start of the code ****************

scrnx = 640
scrny = 480
screenres scrnx,scrny,16,0,0

me.x = scrnx*rnd
me.y = scrny*rnd

hStart() ' :)
SockServer = hOpen()
Sv.Port = 5018
var ServerHost = "108.75.36.55"
'input "Host IP: ",ServerHost
var HostIP = hResolve(ServerHost)
Print "Attempting to connect to server..."
var ConnectResult = hConnect(SockServer,HostIP,Sv.Port)
if ConnectResult then
    print "Connected..."
else
    print "Connection failed..."
    sleep
    stop
end if

dim as string sColor
input "Nick: ", Me.sign
input "Color: ", sColor
Me.Clr = valint("&h"+sColor) 
Me.ID = -1 'set as no ID received (i.e. invalid ID)
Me.InUse = 0 'clear in use status for yourself
'almost what you did but the color you can set in hex
'like webdesign :) 

'a temporary message variable
dim as tMessageSign tSign
'filling the message
tSign.tInfo.sign = Me.sign
'sending the sign/auth message
hSendStruct(SockServer,tSign)
printf !"Sent authentication\n"

'receiving messages :)
dim pBuff as any ptr = allocate(MAX_MESSAGE_SIZE)
dim as integer iMsgSz,iMsgRead
do
    Controller()
    
    with me ':D
        static as integer OldX,OldY 'keep track of old X,Y only send new packet if it changes
        static as double StatsUpTimer
        'try to only update status at "SERVER_FPS rate" to avoid flooding.
        'as if your sessions was doing like 500 fps you don't want
        'to send 500 updates per second :) we wanna send 20/sec Ya? yes
        if abs(timer-StatsUPTimer) > 1/SERVER_FPS then
            StatsUPTimer = timer        
'            if .x<>OldX or .y<>OldY then
'                OldX=.x : OldY=.y
'                dim as tMessageUpdatePostion tNewPos
'                tNewPos.tData.x = .x
'                tNewPos.tData.y = .y
'                tNewPos.tData.iColor = .Clr
'                hSendStruct(SockServer,tNewPos)
'            end if
            
            OldX=.x : OldY=.y
            dim as tMessageUpdatePostion tNewPos
            tNewPos.tData.x = .x
            tNewPos.tData.y = .y
            tNewPos.tData.iColor = .Clr
            hSendStruct(SockServer,tNewPos)
        end if    
    
        dim as double MsgTimerLimit = timer
        while hSelect(SockServer) 'there's data to read?
            if iMsgSz =0 then 'read header (to avoid exploits)
'                printf !"Reading header\n"
                var iResu = hreceive(SockServer,pBuff+iMsgRead,sizeof(MessageHeader)-iMsgRead)
                if iResu < 0 then 'Lost connection with server.
                    print "Disconnected... Aborting(1): " & iResu: sleep
                    exit do
                end if
                iMsgRead += iResu
                if iMsgRead >= sizeof(MessageHeader) then
                    iMsgSz = cptr(MessageHeader ptr,pBuff)->iSize 'Get Message Full Size
'                    printf !"Message Type:%s size:%i\n",sMsgType(cptr(MessageHeader ptr,pBuff)->iType),iMsgSz
                end if
            end if
            if iMsgSz>0 then 'read rest of message (after safely read the header of it)
                var iResu = hreceive(SockServer,pBuff+iMsgRead,iMsgSz-iMsgRead)
                if iResu < 0 then 'Lost connection with server.
                    print "Disconnected... Aborting (2): " & iResu: sleep
                    exit do
                end if
                iMsgRead += iResu
                if iMsgRead >= sizeof(MessageHeader) then
'                    printf !"Processing received message \n"
                    ProcessServerMessage(pBuff)
                    iMsgSz=0:iMsgRead=0
                    if (timer-MsgTimerLimit) > 1/120 then
                      exit while
                    end if
                end if
            end if
        wend
    end with
    
    static as double FpsSync
    if abs(timer-FpsSync) > 1 then FpsSync=timer
    while (timer-FpsSync) < 1/60
      sleep 1,1
    wend
    FpsSync += 1/60
    
    screenLock
    RenderStuff()
    screenUnlock
    
loop until multikey(sc_escape)