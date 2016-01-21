#include "wshelper.bas"
#include "fbgfx.bi"
#include "crt.bi"
using fb

enum MessageType
    mtNull        'Zero Message
    mtSign        'containing auth of client (client to server)
    mtSignReply   'reply of the auth (server to client)
    mtData        'contains the updated data (position of the circle)
    mtError       'error message (server to client)
    mtJoin        'client joined (server to client)
    mtPart        'client parted (server to client)
    mtChat        'chat message (any to any)
    mtPosition    'Circle position (client->server->client)
    mtObject
end enum
'temp must delete later..
dim shared as zstring*32 sMsgType(...) = {"mtNull","mtSign","mtSignReply","mtData","mtError","mtJoin","mtPart","mtChat","mtPosition","mtObject"}

type MessageHeader
    iType as short
    iSize as short
    iHash as integer
end type

type ServerProp
    as socket Sock
    as integer Port
    as zstring*13 HostIP    
'    as integer SERVER_MAXPLAYERS
    as integer Players
end type
dim shared as ServerProp Sv

'this still valid seince we will keep there the socket and status
'of the client connection, so this ClientProp is what the server
'will have for each client anyway, so the name also goes here
'and probabily the X,Y as well because the X,Y are the client specific
'data anyway. o xD
'So recombine them? let's do it in a way that we wont need separated structures
#define ThisHeader(a) as MessageHeader header = type(a,0,&hFF01EE02)

type ClientDataProp 'no header because not a message    
    as integer X,Y
    as integer iColor
end type
type ClientSignProp
    as zstring*16 sign 'Name
end type

type tMessageSign
    ThisHeader(mtSign)
    tInfo as ClientSignProp
end type

type tMessageSignReply
    ThisHeader(mtSignReply)
    ID as integer
    'what other possible info is generated by server?
end type

type tMessageError
    ThisHeader(mtError)
    as zstring*64 sMessage
end type

type tMessageChat
    ThisHeader(mtChat)
    as zstring*256 sMessage
end type

type tMessageJoin
    ThisHeader(mtJoin)
    as integer ID
    as zstring*16 sign 'same content as ClientSignProp
end type
type tMessagePart
    ThisHeader(mtPart)
    as integer ID
end type
    
type tMessageUpdatePostion
    ThisHeader(mtPosition)
    as integer ID    'server assigned ID of the player
    tData as ClientDataProp    
end type

type tMessageObject
    ThisHeader(mtObject)
    as integer ID
    as integer X,Y
end type

type ClientProp
    iInUse as integer        'slot in use flag
    iIsAuth as integer       'Client signed in?
    Socket as socket         'socket for this client
    pBuff as any ptr         'buffer for receiving messages
    iMsgSz as integer        'total size of reading message
    iMsgRead as integer      'amount read of message
    tInfo as ClientSignProp  'sign info for the client (name?)
    tData as ClientDataProp  'game data for the client
end type

'Simple Defines
#define hSendStruct(s,a) a.header.iSize=sizeof(a):hSend(s, cast(any ptr,@a), sizeof(a))
#define hSendToAll(a) SendMessageToAllExcept(iSlot,@a,sizeof(a))

'Simple Constants
const MAX_MESSAGE_SIZE = 1024 '1kb? yeah it's a up limit, what if you send 
'some icon or whatever but it may be small you can tune it to whatever is the 
'actual biggest size of packet later :) als with 1kb you have a maximum 
'message (chat) of 996 chars. I see.
const SERVER_FPS = 25
const PI180 = atn(1)/45

const SERVER_MAXPLAYERS = 32