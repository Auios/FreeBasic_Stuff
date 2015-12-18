#define fbc -s gui

#include "header.bas"

screenres scrnx,scrny,8

dim as ClientData me,OldMe
dim as ClientData cl(MaxClients)
dim as ClientData OldCl(MaxClients)
dim as ServerData sv

print "Attempting to connect to host..."

var MyIP = hResolve(HostIP)

var iResu = hConnect(ServerSocket,MyIP,ServerPort) 'socket/ip/port
if iResu then
    print "Connected..."
else
    print "Connection failed..."
    sleep:stop
end if

hReceive(ServerSocket,cast(any ptr,@me), sizeof(me))
for i as integer = 1 to MaxClients
  cl(i).slot = -1: oldcl(i).slot = -1
next i

do
    
    static as double dSvFps
    if abs(timer-dSvFps) > 1 then
      dSvFps = timer
    else
      if (timer-dSvFps) > 1/svfps then          
        hSend(ServerSocket, cast(any ptr,@me), sizeof(me))            
        with me
          if multikey(sc_lshift) then
              if multikey(sc_w) then .y-=9
              if multikey(sc_s) then .y+=9
              if multikey(sc_a) then .x-=9
              if multikey(sc_d) then .x+=9
          else
              if multikey(sc_w) then .y-=3
              if multikey(sc_s) then .y+=3
              if multikey(sc_a) then .x-=3
              if multikey(sc_d) then .x+=3
          end if
        end with            
      end if          
    end if
    
    if hSelect(ServerSocket) then        
      var iResult = hReceive(ServerSocket,cast(any ptr,@sv), sizeof(sv))
      if iResult then
        for i as integer = 1 to MaxClients
          cl(i).slot = -1
        next i
        for i as integer = 1 to sv.ConnectedClients-1
            dim as ClientData tTempCli
            iResult = hReceive(ServerSocket,cast(any ptr,@tTempCli), sizeof(tTempCli))
            if iResult <= 0 then exit for
            cl(tTempCli.slot) = tTempCli            
        next i
      end if      
      if iResult <=0 then
        print "Disconnected"
        hClose(ServerSocket)
        sleep: stop
    end if
      
    end if
        
    screenlock
      line(0,0)-(scrnx,scrny),0,bf
      for CNT as integer = 1 to MaxClients
        if cl(CNT).Slot <> -1 then
          if oldCl(CNT).Slot <> cl(CNT).Slot then
            OldCl(CNT) = cl(CNT)
          else
            with oldCl(CNT)
              .x = (.x+cl(CNT).x) shr 1
              .y = (.y+cl(CNT).y) shr 1
              circle(.x,.y),15,15
            end with
          end if
        end if
      next CNT
      
      with OldMe
        .x = (.x+me.x) shr 1
        .y = (.y+me.y) shr 1
        circle(.x,.y),15,10
      end with
      
    screenunlock
    
    static as double dSync
    if abs(timer-dSync) > .5 then
      dSync = timer
    else
      while (timer-dSync) < 1/60
        sleep 1,1
      wend
      dSync += 1/60
    end if
    
    do    
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