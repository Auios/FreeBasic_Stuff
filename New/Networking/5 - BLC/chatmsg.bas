#include "crt.bi"

'Structs

type clientprop
    as string smsg,cmd,nme,chat
end type

'Variables

dim as clientProp cl

'Subs/Funcs

sub chatMsg(cl as clientProp)
    with cl
        .cmd = left(.smsg,1)
        .smsg = right(.smsg,(len(.smsg)-len(.cmd))-1)
        .nme = left(.smsg,instr(.smsg,!"\t")-1)
        .smsg = right(.smsg,(len(.smsg)-len(.nme))-1)
        .chat = .smsg
    end with
end sub

'Main loop

cl.smsg = !"5\tCca\tHello guys"

chatMsg(cl)

print cl.cmd & "..."
print cl.nme & "..."
print cl.chat & "..."

print

print cl.nme & ": " & cl.chat

sleep