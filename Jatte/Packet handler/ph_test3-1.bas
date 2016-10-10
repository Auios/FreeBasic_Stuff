#include "packethandlers.bi"

dim as PH_Packet myPacket
dim as integer dickButts = 555

myPacket = PH_CreatePacket(RECVBUFFLEN, FALSE)
myPacket.data = cc.buffer
PH_SetMaxRead(myPacket, bytes)
PH_Reset(@myPacket)
do until PH_Error(myPacket) = PH_ERROR_OVERFLOW
    'read data
    var thisData = PH_ReadInteger(@myPacket)
    print thisData
loop

