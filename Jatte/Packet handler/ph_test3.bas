#include "packetHandlers.bi"

dim as PH_Packet myPacket
dim as string dickButts = "Auios"

myPacket = PH_CreatePacket(4, FALSE)
if PH_Error(myPacket) then
print "Error: "& PH_Error(myPacket)
end if

myPacket.data = strptr(dickButts)

PH_Reset(@myPacket)
if PH_Error(myPacket) then
print "Error: "& PH_Error(myPacket)
end if

print chr(PH_ReadByte(@myPacket));
print chr(PH_ReadByte(@myPacket));
print chr(PH_ReadByte(@myPacket));
print chr(PH_ReadByte(@myPacket));
print chr(PH_ReadByte(@myPacket))

if (PH_Error(myPacket) = PH_OK) then
    Print "ok"
else
    if(PH_Error(myPacket) = PH_ERROR_OVERFLOW) then
        print "overflow"
    end if
end if

sleep
