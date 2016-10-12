#include "PacketHandler.bi"

dim as PH_Packet myPacket
dim as integer dickButts = 555

myPacket = PH_CreatePacket(4, FALSE)
if PH_Error(myPacket) then
print "Error: "& PH_Error(myPacket)
end if

myPacket.data = @dickButts

'Seek
PH_Reset(@myPacket)
if PH_Error(myPacket) then
print "Error: "& PH_Error(myPacket)
end if

print PH_ReadInteger(@myPacket)
if PH_Error(myPacket) then
print "Error: "& PH_Error(myPacket)
end if

sleep()

