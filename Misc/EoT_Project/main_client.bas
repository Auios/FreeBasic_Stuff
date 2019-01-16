#include "netWrapper.bi"
#include "packetHandler.bi"
#include "debugTools.bi"

dim as _CONNECTION_ sv
dim shared as boolean runClient = true
dim as long bytes
dim as PH_Packet packet

packet = PH_createPacket()

db("----Client----")

if(nw_start() <> 0 ) then
    color 12: db("ERROR: WSAStartup failed"): color 7
    sleep
    end
end if

if(nw_connect(@sv,"127.0.0.1",28000) <> 0) then
    db("Failed to connect...")
    
    sleep()
    end(0)
end if

db("Connected!")

while(runClient)
    var k = inkey()
    if(k = chr(27)) then runClient = false
    if(k = "w") then
        PH_addByte(@packet,cast(byte,100*rnd))
        db("Packet size: " & packet.size)
    end if
    if(k = chr(32)) then
        PH_reset(@packet)
        
        nw_set(sv)
        if(nw_select()) then
            if(nw_isSet(sv,S_ERROR)) then
                db("Lost connection with server...")
                sleep()
                runClient = false
            end if
            
            if(nw_isSet(sv,S_SEND)) then
                db("Packet size: " & packet.size)
                if(nw_send(sv,packet.data,packet.size) <> 0) then
                    db("Failed to send")
                    sleep()
                    runClient = false
                else
                    db("Sent!")
                end if
            end if
        end if
    end if
    sleep(1,1)
wend

nw_disconnect(@sv)