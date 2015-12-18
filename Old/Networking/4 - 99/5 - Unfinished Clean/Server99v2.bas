'===============================================================================
'Headers:

#include "fbgfx.bi"
#include "wshelper.bas"
using fb

randomize timer

'===============================================================================
'Enums:

enum clientStatus
    NotConnected
    WaitAuth
    Playing
end enum

enum
    runServer
    endServer
    
    mu
    md
    ml
    mr
end enum

'===============================================================================
'Structs:

type serverProp
    as integer sock
    as ushort port
    
    as uinteger maxPlayers,playerCount
    as ubyte flag
end type

type clientProp
    as socket sock
    as long IP,port
    
    as zstring*255 smsg,chat
    as ubyte ID
    as ushort x,y
    as double joinTime
    as clientStatus status
end type

type mapProp
    as ubyte ID(1 to 50,1 to 20)
end type

type sendCoords
    as ushort x,y
end type

'===============================================================================
'Variables:

dim shared as clientProp cl(),cltmp
dim shared as serverProp sv
dim shared as mapProp mp

dim as zstring*64 smsg

'===============================================================================
'Declare:

declare sub controller()

declare sub init()
declare sub initNet()
declare sub initSv()
declare sub initVars()
declare sub initMap()

declare sub serverFull()
declare sub addNewClient(i as uinteger)
declare sub putMsg(i as uinteger,byref smsgt as zstring*64)
declare sub getMsg(i as uinteger)

'===============================================================================
'Functions/Subs:

sub controller()
    if multikey(sc_escape) then sv.flag = endServer
end sub

'-------------------------------------------------------------------------------

sub init()
    initNet()
    initSv()
    initVars()
    initMap()
end sub

sub initNet()
    hstart()
end sub

sub initSv()
    with sv
        .port = 28000
        
        .sock = hOpen()
        hBind(.sock,.port)
        hListen(.sock)
    end with
end sub

sub initVars()
    with sv
        .maxPlayers = 8
        .flag = runServer
    end with
end sub

sub initMap()
end sub

'-------------------------------------------------------------------------------

sub serverFull()
    with clTmp
        .sock = haccept(sv.sock,.ip,.port)
        hClose(.sock)
        .sock = 0
    end with
end sub

sub addNewClient(i as uinteger)
    with cl(i)
        .sock = haccept(sv.sock,.ip,.port)
        hsend(.sock,"1",1)
        
        .joinTime = timer
        .ID = i
        .status = waitAuth
    end with
    
    sv.playerCount+=1
end sub

sub putMsg(i as uinteger,byref smsg as zstring*64)
    with cl(i)
        hSend(.sock,smsg,len(smsg))
    end with
end sub

sub getMsg(i as uinteger)
    var buffer = 1024
    with pl(i)
        iresu = hReceive(.sock,.smsg,buffer)
    end with
end sub

'cast(any ptr,@ByteVar)

'===============================================================================
'Main:
print "Setting up server..."

init()
redim shared as clientProp cl(1 to sv.maxPlayers)

print "Running..."
do
    'Check for new clients
    if hSelect(sv.sock) then
        'Check if the server is full
        if sv.playerCount < sv.maxPlayers then
            'Find which slot is empty
            for i as uinteger = lbound(cl) to ubound(cl)
                with cl(i)
                    if .sock = 0 then
                        'Slot is empty
                        print i & " - Client connected"
                        
                        addNewClient(i)
                    end if
                end with
            next i
            
        else
            'Server is full
            print "Server is full!"
            serverFull()
        end if
        
    else
        'Manage existing clients
        for i as uinteger = lbound(cl) to ubound(cl)
            with cl(i)
                if .sock then
                    if hSelect(.sock) then
                        'The client has sent us something
                        getMsg(i)
                    end if
                end if
            end with
        next i
    end if
    
    controller()
    sleep 1,1
loop until sv.flag = endServer

hclose(sv.sock)