'define fbc -s gui

#include "header.bas"

screenres scrnx,scrny,8

dim as ClientData me,OldMe
dim as ClientData cl(MaxClients)
dim as ClientData OldCl(MaxClients)
dim as ServerData sv

input "Name: ", me.sign
print "-----"
print "1. Localhost"
print "2. Cca's Server"
print "3. Mysoft's Server"
print "4. Newnham"
input "Select server: ", ans
select case ans
case 1
    HostIP = "localhost"
case 2
    HostIP = "99.225.166.32"
case 3
    HostIP = "mysoft.zapto.org"
case 4
    HostIP = "142.204.16.32"
end select

print "Attempting to connect to host..."

var MyIP = hResolve(HostIP)

var iResu = hConnect(ServerSocket,MyIP,ServerPort)'socket/ip/port
if iResu then
    print "Connected..."
else
    print "Connection failed..."
    sleep:stop
end if

hSend(ServerSocket, cast(any ptr,@me), sizeof(me))
hReceive(ServerSocket,cast(any ptr,@me), sizeof(me))

OldMe = me

for i as integer = 1 to MaxClients
    cl(i).slot = -1
    oldcl(i).slot = -1
next i

do
    screenlock
    static as double dSvFps
    if abs(timer-dSvFps) > 1 then
        dSvFps = timer
    else
        if (timer-dSvFps) > 1/svfps then
'            me = CheckEdge(me)
            hSend(ServerSocket, cast(any ptr,@me), sizeof(me))
            with me
                if multikey(sc_lshift) then
                    if multikey(sc_w) then .y-=5: if .y < 0 then OldMe.y += scrny:.y += scrny
                    if multikey(sc_s) then .y+=5: if .y >= scrny then OldMe.y -= scrny:.y -= scrny
                    if multikey(sc_a) then .x-=5: if .x < 0 then OldMe.x += scrnx:.x += scrnx
                    if multikey(sc_d) then .x+=5: if .x >= scrnx then OldMe.x -= scrnx:.x -= scrnx
                else
                    if multikey(sc_w) then .y-=3: if .y < 0 then OldMe.y += scrny:.y += scrny
                    if multikey(sc_s) then .y+=3: if .y >= scrny then OldMe.y -= scrny:.y -= scrny
                    if multikey(sc_a) then .x-=3: if .x < 0 then OldMe.x += scrnx:.x += scrnx
                    if multikey(sc_d) then .x+=3: if .x >= scrnx then OldMe.x -= scrnx:.x -= scrnx
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
    
    
    line(0,0)-(scrnx,scrny),0,bf
    for CNT as integer = 1 to MaxClients
        if cl(CNT).Slot <> -1 then
            if oldCl(CNT).Slot <> cl(CNT).Slot then
                OldCl(CNT) = cl(CNT)
            else
            with oldCl(CNT)                                                     'Render Other Clients
                .x = (.x+cl(CNT).x) shr 1
                .y = (.y+cl(CNT).y) shr 1
                
                for X as integer = -scrnx to scrnx step scrnx
                    for Y as integer = -scrny to scrny step scrny
                        RenderUser(.x+X,.y+Y,.size,.clr,.sign)
                    next Y
                next X
            end with
          end if
        end if
    next CNT
    
    with OldMe                                                                  'Render Self
        .x = (.x+me.x) shr 1
        .y = (.y+me.y) shr 1
        
        for X as integer = -scrnx to scrnx step scrnx
            for Y as integer = -scrny to scrny step scrny
                RenderUser(.x+X,.y+Y,.size,.clr,.sign)
            next Y
        next X
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
            case 27,asc("q"),asc("Q"): exit do,do                               'Quit
            end select
        else
            exit do
        end if
    loop
    
loop

hClose(ServerSocket)