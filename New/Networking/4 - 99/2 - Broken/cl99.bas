#include "scrn.bas"
#include "wshelper.bas"
#include "fbgfx.bi"
using fb

randomize timer

'scrn()

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
    rm
end enum
dim as myStatus status = ready

dim as ubyte buffer = 255
dim as string smsg = space(buffer)
dim as uinteger maxClients,connectedClients
dim as string map = ""
dim as string tmsg,tmsg2
dim as integer tposi,posi
dim as string ID,x,y
dim as string Mask

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
            select case status
            case ready
                smsg = left(smsg,iresu)
                print smsg,iresu
            case rm
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
                        ID = left(tmsg,tposi)
                        tmsg2 = mid(tmsg,tposi+2)
                        
                        tposi = instr(tmsg2,";")-1
                        X = left(tmsg2,tposi)
                        tmsg2 = mid(tmsg,tposi+4)
                        
                        tposi = instr(tmsg2,".")-1
                        Y = left(tmsg2,tposi)
                        
                        print tmsg
                        print ID,X,Y
                        sleep
                        
                        map = mid(map,posi+2)
                    loop until tmsg = "en."
                    
                    status = ready
                end if
            end select
        end if
    else
        if multikey(sc_t) then
            While Inkey <> "": Wend
            input smsg
            hSend(mySocket,smsg,len(smsg))
            
            select case smsg
            case "rm."
                status = rm
            case "dc."
                exit do
            end select
        end if
        
        if multikey(sc_w) then
            smsg = "mu."
            hSend(mySocket,smsg,len(smsg))
        end if
        if multikey(sc_s) then
            smsg = "md."
            hSend(mySocket,smsg,len(smsg))
        end if
        if multikey(sc_a) then
            smsg = "ml."
            hSend(mySocket,smsg,len(smsg))
        end if
        if multikey(sc_d) then
            smsg = "mr."
            hSend(mySocket,smsg,len(smsg))
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