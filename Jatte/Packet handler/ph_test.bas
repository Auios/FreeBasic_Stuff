#include "PacketHandlers.bi"

dim as PH_Packet myPacket

myPacket = PH_CreatePacket(4)
if PH_Error(myPacket) then
print "Error: "& PH_Error(myPacket)
end if

PH_AddInteger(@myPacket, 500)
if PH_Error(myPacket) then
print "Error: "& PH_Error(myPacket)
end if

PH_Reset(@myPacket)
if PH_Error(myPacket) then
print "Error: "& PH_Error(myPacket)
end if

print PH_ReadInteger(@myPacket)
if PH_Error(myPacket) then
print "Error: "& PH_Error(myPacket)
end if

sleep
