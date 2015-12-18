'Blockland Chat Server
'v.1

'Headers

#include "fbgfx.bi"
#include "wshelper.bas"
#include "scrn.bas"
#include "crt.bi"
#include "string.bi"

using fb

'Enums

enum clientStatus
    notConnected
    waitAuth
    chatting
end enum

'Structs

type serverProp
    as socket sock
    as long port
    
    as zstring*1024 cmd
    as integer iResu
    
    as ulong maxClients,connectedClients
end type

type clientProp
    as socket sock
    as long ip,port
    as zstring*16 sip
    
    as zstring*2048 smsg
    as zstring*1 cmd
    as zstring*16 nme
    as zstring*1024 chat
    
    as clientStatus status
    
    as ubyte inUse
end type

'Variables

dim as serverprop sv
dim as clientprop tcl,cl(1 to 100)
dim as string buffer = space(1024)

'Subs/Funcs

sub initServer(sv as serverprop,cl() as clientProp)
    'Quick setup for server stuff
    with sv
        .sock = hOpen()
        .port = 27000
        
        .maxClients = ubound(cl)
    end with
end sub

sub initNetwork(sv as serverProp)
    'Quick setup for network stuff
    hStart()
    
    with sv
        hBind(.sock,.port)
        hListen(.sock)
    end with
end sub

sub putMsg(cl as clientProp,smsg as string)
    'Send message to client(i)
    with cl
        .smsg = smsg & !"\r\n"
        hSend(.sock,.smsg,len(.smsg))
    end with
end sub

sub getMsg(cl as clientProp,sv as serverProp)
    'Get message from client(i)
    with cl
        sv.iResu = hReceive(.sock,cast(any ptr,@.smsg),1024)
        .smsg = left(.smsg,sv.iresu-2)
        .cmd = left(.smsg,1)
        .smsg = right(.smsg,(len(.smsg)-len(.cmd))-1)
    end with
end sub

putMsgAll(smsg as string)
    for i as ulong = lbound(cl) to ubound(cl)
        with cl(i)
            if .inUse = 1 then
                hSend(.sock,cast(any ptr,@sv.cmd),len(sv.cmd))
            end if
        end with
    next i
end sub

sub chatMessage(cl as clientProp)
    with cl
        .nme = left(.smsg,instr(.smsg,!"\t")-1)
        .smsg = right(.smsg,(len(.smsg)-len(.nme))-1)
        .chat = .smsg
    end with
end sub

sub shutdownServer(sv as serverProp,cl() as clientProp)
    'Shutdown server, send "4" (Shutdown) to all connected clients (If any)
    print "Shutting down..."
    if sv.connectedClients >= 1 then
        for i as ulong = lbound(cl) to ubound(cl)
            with cl(i)
                if .inUse = 1 then
                    print "Cl." & i & " - Disconnected..."
                    putMsg(cl(i),"4")
                    hClose(.sock)
                end if
            end with
        next i
    end if
    
    with sv
        hClose(.sock)
        hShutdown()
    end with
end sub

sub connectClientServerFull(cl as clientProp,sv as serverProp)
    'Server is full, connect client, send "3" (Server full) and disconnect client
    with cl
        .sock = hAccept(sv.sock,.ip,.port)
        putMsg(cl,"3")
        hClose(.sock)
        .sock = 0
        .ip = 0
        .port = 0
    end with
end sub

sub connectClient(cl as clientProp,sv as serverProp)
    'Connect the client to the server. Send client "7" (Request auth)
    with cl
        .sock = hAccept(sv.sock,.ip,.port)
        putmsg(cl,"7")
        
        .inUse = 1
        
        .status = waitAuth
    end with
    
    sv.connectedClients+=1
end sub

sub disconnectClient(cl as clientProp,sv as serverProp)
    'Disconnect the client properly. Send client "5" (Kicked/Removed)
    with cl
        putMsg(cl,"5")
        hClose(.sock)
        .inUse = 0
        .status = notConnected
        .ip = 0
        .port = 0
    end with
    
    sv.connectedClients-=1
end sub

'Init

print "Init Server"
initServer(sv,cl())
print "Init Network"
initNetwork(sv)
print "Server running..."

'Main loop

do
    'Check for new clients trying to connect
    if hSelect(sv.sock) then
        'Check if server is full
        if sv.connectedClients >= sv.maxClients then
            'Server is full
            print "Cl.? - Server full..."
            connectClientServerFull(tCl,sv)
        else
            'Server is not full
            for i as ulong = lbound(cl) to ubound(cl)
                'Find open slot
                with cl(i)
                    if .inUse = 0 then
                        print "Cl." & i & " - Connected..."
                        connectClient(cl(i),sv)
                        exit for
                    end if
                end with
            next i
        end if
    else
        'Manage existing clients
        for i as ulong = lbound(cl) to ubound(cl)
            with cl(i)
                if .inUse = 1 then
                    if hSelect(.sock) then
                        'Client has sent us data
                        getMsg(cl(i),sv)
                        
                        
                        if sv.iResu <= 0 then
                            'Client disconnected
                            print "Cl." & i & " - Disconnected..."
                            disconnectClient(cl(i),sv)
                        else
                            
                            select case .status
                            case waitAuth
                                if .cmd = "8" then
                                    'Client sent correct auth
                                    print "Cl." & i & " - Authenticated..."
                                    .status = chatting
                                    .cmd = !"1\r\n"
                                    hSend(.sock,cast(any ptr,@.cmd),len(.cmd))
                                    
                                else
                                    'Client did not send correct auth
                                    print "Cl." & i & " - Bad auth..."
                                    print "Cl." & i & ": " & .cmd
                                    .cmd = "2\r\n"
                                    hSend(.sock,cast(any ptr,@.cmd),len(.cmd))
                                end if
                                exit select
                                
                            case chatting
                                var fst = left(.cmd,1)
                                select case fst
                                case "6" 'Client chat
                                    chatMessage(cl(i))
                                    
                                case "9" 'Disconnect client
                                    print "Cl." & i & " - Disconnected..."
                                    disconnectClient(cl(i),sv)
                                    
                                case else
                                    print "Cl." & i & " - ? - " & .cmd
                                end select
                            end select
                        end if
                    end if
                end if
            end with
        next i
    end if
    
    do
        var k = inkey()
        if len(k) = 0 then exit do
        var ik = cint(k[0])
        if ik = 255 then ik = -k[1]
        select case ik
        case asc("t"),asc("T")
            putMsgAll(!"6\tDau\tHello world!\r\n")
            
        case 27
            exit do,do
        end select
    loop
    
    sleep 1,1
loop

shutdownServer(sv,cl())