#include "fbgfx.bi"
using fb
#include "wshelper.bi"
randomize timer

hstart()

dim shared as integer scrnx,scrny,svfps
scrnx = 800
scrny = 600
svfps = 20

dim shared as integer ans
dim shared as string HostIP

var ServerSocket = hOpen()
var ServerPort = 28000

Const MaxClients = 32

type ClientInfo
    sock as socket
    IP as long
    Port as long
end type

type ClientData
    as string*10 sign
    as short x,y
    as uinteger clr
    as short size
    as byte Slot
end type

dim shared as string chat

type ServerData
    as short ConnectedClients
    as byte self
end type

sub renderUser(xx as short,yy as short,size as short,clr as uinteger,sign as string)
    var iLen = len(sign)
    var mult = 1.5
    circle(xx,yy),size,clr
    draw string(xx-(iLen*3.7),yy-size-10),sign 'Center Above
end sub

function GetStr(pretext as string,x as integer,y as integer,mode as integer) as string
    dim as string sKey,sText
    do
        sKey = inkey()
        select case asc(sKey)
        case 8
            if len(sText) then sText = left$(sText,len(sText)-1)
            sText += " "
            if len(sText) then sText = left$(sText,len(sText)-1)
        case 13
            return sText
        case 27
            return "NULL"
        case else
            if len(sText) < 60 then sText += sKey
        end select
        
        screenlock
        select case mode
        case 1
            locate(y,x):print pretext & sText
        case 2
            draw string(x,y),pretext & sText
        end select
        
        screenunlock
    loop until multikey(sc_escape)
end function

