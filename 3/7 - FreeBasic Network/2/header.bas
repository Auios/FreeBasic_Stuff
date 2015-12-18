#include "fbgfx.bi"
using fb
#include "wshelper.bas"
randomize timer

hstart()

dim shared as integer scrnx,scrny,svfps
scrnx = 800
scrny = 600
svfps = 20

dim shared as integer ans
dim shared as string HostIP

var ServerSocket = hOpen()
var ServerPort = 28001

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