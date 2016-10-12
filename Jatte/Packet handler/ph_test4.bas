#include "packethandler.bi"

dim as PH_Packet myPacket


myPacket = PH_CreatePacket()
if PH_Error(myPacket) then
print "Error: "& PH_Error(myPacket)
end if

PH_AddHeader(@myPacket, 50)
PH_AddString(@myPacket, "Auios")
PH_AddByte(@myPAcket, 5)
PH_AddHeader(@myPacket, 55)
PH_AddInteger(@myPacket, 768)


PH_Reset(@myPacket)

'Good
do until PH_Error(@myPacket)
    dim as integer serialType = PH_GetType(@myPacket)
    if serialType = 50 then
    dim as string _name = PH_ReadString(@myPacket)
    dim as integer age = PH_ReadByte(@myPacket)
    print _name &" is "& age &" years old!"
    elseif serialType = 55 then
    print "This is 768 = "& PH_ReadInteger(@myPacket)
    end if
loop

'Bad
'do until PH_Error(@myPacket)
'    dim as integer serialType = PH_GetType(@myPacket)
'        if serialType = 50 then
'        print PH_ReadString(@myPacket) &" is "& PH_ReadByte(@myPacket) &" years old!"
'    elseif serialType = 55 then
'        print "This is 768 = "& PH_ReadInteger(@myPacket)
'    end if
'loop

sleep
