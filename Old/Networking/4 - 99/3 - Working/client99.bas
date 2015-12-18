#include "scrn.bas"
#include "wshelper.bas"
#include "fbgfx.bi"
using fb

randomize timer

scrn()

hStart()

dim as integer iresu

dim as string HostIP = "localhost"
var MyIP = hResolve(HostIP)
var mySocket = hOpen()
var ServerPort = 28000

print "Attempting to connect to host..."

iResu = hConnect(mySocket,MyIP,ServerPort)'socket/ip/port
if iResu then
    print "Connected..."
else
    print "Connection failed..."
    sleep:stop 1
end if

enum myStatus
    ready
    getMap
    requestID
end enum

type playerProp
    as myStatus status
    as uinteger ID
    as integer x,y
    as ubyte flag
end type

type mapProp
    as byte rdy
    as string tID,tX,tY
    as ubyte ID(1 to 50,1 to 20)
    as zstring*2 mask(1 to 50,1 to 20)
end type

dim shared as event e

dim shared as ubyte buffer
dim shared as string smsg
dim shared as uinteger maxClients,connectedClients
dim shared as string map
dim shared as string tmsg,tmsg2
dim shared as integer tposi,posi

dim shared as playerProp me
dim shared as mapProp mp

buffer = 255
smsg = space(buffer)
map = ""

#include "clFunc.bas"

smsg = "cn."
hSend(mySocket,smsg,len(smsg))

do
    if hselect(mySocket) then
        smsg = space(buffer)
        iResu = hReceive(MySocket,smsg,buffer)
        if iResu <=0 then
            print "Server shutdown..."
            smsg = "sh."
            sleep
            exit do
        else
            select case left(smsg,3)
            case "tl."
                me.status = getMap
            end select
            
            select case me.status
            case ready
                smsg = left(smsg,iresu)
                print smsg,iresu
            case getMap
                with mp
                    print "Gathering map data..."
                    smsg = left(smsg,iresu)
                    print smsg,iresu
                    map+=smsg
                    
                    if right(map,3) = "en." then
                        print "End of stream"
                        
                        do
                            posi = instr(map,".")-1
                            tmsg = left(map,posi)
                            
                            tmsg += "."
                            
                            
                            tposi = instr(tmsg,";")-1
                            .tID = left(tmsg,tposi)
                            tmsg2 = mid(tmsg,tposi+2)
                            
                            tposi = instr(tmsg2,";")-1
                            .tX = left(tmsg2,tposi)
                            tmsg2 = mid(tmsg,tposi+4)
                            
                            tposi = instr(tmsg2,".")-1
                            .tY = left(tmsg2,tposi)
                            
                            if val(.tID) > 0 then
                                .ID(int(val(.tX)),int(val(.tY))) = int(val(.tID))
                            end if
                            
                            map = mid(map,posi+2)
                        loop until tmsg = "en."
                        .rdy = 1
                        me.status = ready
                        
                        if me.flag = 5 then
                            renderMap()
                            me.flag = 0
                        end if
                    end if
                end with
            case requestID
                with me
                    .ID = val(smsg)
                    .status = ready
                end with
            end select
        end if
    else
        if (screenevent(@e)) then
            select case e.type
            case event_key_press
                if e.scancode = sc_t then
                    with me
                        While Inkey <> "": Wend
                        input smsg
                        
                        if right(smsg,1) = "." then
                            
                            select case left(smsg,3)
                            case "ri."
                                .status = requestID
                            case "rm."
                                .status = getMap
                            case "dc."
                                exit do
                            case "ms;"
                            end select
                            
                            hSend(mySocket,smsg,len(smsg))
                        else
                            select case smsg
                            case "renderMap"
                                renderMap()
                            end select
                        end if
                    end with
                    exit select
                end if
                
                if e.scancode = sc_w then
                    me.status = getMap
                    me.flag = 5
                    smsg = "mu."
                    hSend(mySocket,smsg,len(smsg))
                    
                    exit select
                end if
                if e.scancode = sc_s then
                    me.status = getMap
                    me.flag = 5
                    smsg = "md."
                    hSend(mySocket,smsg,len(smsg))
                    
                    exit select
                end if
                if e.scancode = sc_a then
                    me.status = getMap
                    me.flag = 5
                    smsg = "ml."
                    hSend(mySocket,smsg,len(smsg))
                    
                    exit select
                end if
                if e.scancode = sc_d then
                    me.status = getMap
                    me.flag = 5
                    smsg = "mr."
                    hSend(mySocket,smsg,len(smsg))
                    exit select
                end if
                
                if e.scancode = sc_r then
                    me.status = getMap
                    me.flag = 5
                    smsg = "rm."
                    hSend(mySocket,smsg,len(smsg))
                    exit select
                end if
            end select
        end if
    end if
    
    if multikey(sc_escape) then
        smsg = "dc."
        hSend(mySocket,smsg,len(smsg))
        exit do
    end if
    
    sleep 1,1
    While Inkey <> "": Wend
loop

hClose(mySocket)

end 0