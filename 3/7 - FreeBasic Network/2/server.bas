#include "header.bas"

print "Server started..."

hBind(ServerSocket,ServerPort)
hListen(ServerSocket)

dim shared as ClientInfo cl_info(MaxClients)
dim shared as ClientData cl(MaxClients)
dim shared as ServerData sv

locate 6,1

do
    if hSelect(ServerSocket) then                                               'Check for New Connections
        for i as integer = 1 to MaxClients
            with Cl_Info(i)
                if .sock = 0 then
                    .sock = haccept(ServerSocket,.IP,.Port)
                    hReceive(.Sock,cast(any ptr,@cl(i)), sizeof(cl(i)))
                    
                    cl(i).slot = i
                    cl(i).x = scrnx*rnd
                    cl(i).y = scrny*rnd
                    cl(i).size = 30*rnd+15
                    
                    print "Client #" & i & " Connected: " & hIPtoString(.IP)
                    hsend(.Sock,cast(any ptr,@cl(i)), sizeof(cl(i)))
                    
                    sv.ConnectedClients+=1
                    exit for
                end if
            end with
        next i
    end if
    
    for i as integer = 1 to MaxClients                                          'Check for received data
        with Cl_Info(i)
            if .Sock andalso hSelect(.Sock) then
                var iResult = hReceive(.Sock,cast(any ptr,@cl(i)), sizeof(cl(i)))
                if iResult <= 0 then
                    hClose(.Sock)
                    .Sock = 0
                    print "Client #" & i & " DISCONNECTED"
                    sv.ConnectedClients-=1
                else
                    hSend(.Sock,cast(any ptr,@sv), sizeof(sv))
                    if sv.ConnectedClients > 1 then
                        dim as ClientData clst(sv.ConnectedClients-2)
                        var cnum = 0
                        for j as integer = 1 to MaxClients
                            if j <> i andalso Cl_Info(j).sock <> 0 then
                                clst(cnum) = cl(j): cnum += 1
                            end if
                        next j
                        hSend(.Sock,cast(any ptr,@clst(0)), sizeof(ClientData)*cnum)
                    end if
                end if
            end if
        end with
    next i
    
    #if 1
    var iLin = csrlin(),iCol = pos()
    locate 1,1,0
    print "Connections: " & sv.ConnectedClients
    var iTemp = 0
    locate 2,1: print string(80*4,32);
    for i as integer = 1 to MaxClients
        with cl(i)
            if Cl_Info(i).sock then
                iTemp += 1
                locate(2,10*iTemp-9):print "x: " & .x
                locate(3,10*iTemp-9):print "y: " & .y
                locate(4,10*iTemp-9):print "#: " & i
            end if
        end with
    next i
    locate iLin,iCol
    #endif
    
    sleep 1,1
    
    do                                                                          'Process Keys...
      var sKey = inkey()
      if len(sKey) then
        var iKey = cint(sKey[0])
        if iKey=255 then iKey = -sKey[1]
        select case iKey
        case 27,asc("q"),asc("Q"): exit do,do 'Quit
        end select
      else
        exit do
      end if
    loop
loop

hClose(ServerSocket)