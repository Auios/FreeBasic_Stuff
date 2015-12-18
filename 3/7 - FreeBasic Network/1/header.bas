#include "fbgfx.bi"
using fb
#include "wshelper.bas"
randomize timer

hstart()

dim shared as integer scrnx,scrny,svfps
scrnx = 800
scrny = 600
svfps = 20

var ServerSocket = hOpen()
var HostIP = "localhost"
'var HostIP = "99.225.166.32"
'var HostIP = "mysoft.zapto.org"
var ServerPort = 28001

Const MaxClients = 32

type ClientInfo
    sock as socket
    IP as long
    Port as long
end type

type ClientData
    as short x,y
    as byte Slot
end type

type ServerData
    as short ConnectedClients
    as byte self
end type