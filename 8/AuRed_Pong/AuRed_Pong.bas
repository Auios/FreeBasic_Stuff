#include "fbgfx.bi"
#include "crt.bi"
#include once "aulib/window.bi"
#include "wshelper.bi"

#include "Client.bi"
#include "Box.bi"
#include "Pong.bi"
#include "Paddle.bi"

using fb, aulib

sub dPrint(s as string, stp as boolean)
    printf(!"DEBUG: '%s'\n", s)
    if(stp) then sleep()
end sub

function clamp(v as integer, mini as integer, maxi as integer) as integer
    if(v < mini) then v = mini
    if(v > maxi) then v = maxi
    return v
end function

'function toHexData(v as integer, size as integer) as string
function toHexData(v as integer, lngth as integer) as string
    dim as zstring ptr buffer = allocate(lngth+1)
    sprintf(buffer, "%0" & str(lngth) + "x", v)
    return *buffer
end function

'(x / screen_width) * 1000

function pongToBuffer(p as pong, wdth as integer, hght as integer, maxi as integer) as string
    dim as string buffer
    buffer = "s"
    buffer+=toHexData(clamp(p.bx.x, 0, maxi), 4)
    buffer+=toHexData(clamp(p.bx.y, 0, maxi), 4)
    buffer+=toHexData(clamp(p.vx/10, 0, maxi), 4)
    buffer+=toHexData(clamp(p.vy/10, 0, maxi), 4)
    buffer+=toHexData(clamp(p.bx.w, 0, maxi), 4)
    buffer+=toHexData(clamp(p.r, 0, 255), 2)
    buffer+=toHexData(clamp(p.g, 0, 255), 2)
    buffer+=toHexData(clamp(p.b, 0, 255), 2)
    return buffer + !"t\r\n"
end function

function bufferToPong(buffer as string) as pong
    dim as pong p
    p.bx.x = strtoul(mid(buffer, 2, 4), 0, 16)
    p.bx.x = 0
    p.bx.y = strtoul(mid(buffer, 6, 4), 0, 16)
    p.vx = strtoul(mid(buffer, 10, 4), 0, 16) * 10
    p.vy = strtoul(mid(buffer, 14, 4), 0, 16) * 10
    p.bx.w = strtoul(mid(buffer, 18, 4), 0, 16)
    p.r = strtoul(mid(buffer, 22, 2), 0, 16)
    p.g = strtoul(mid(buffer, 24, 2), 0, 16)
    p.b = strtoul(mid(buffer, 26, 2), 0, 16)
    return p
end function

function sendData(sock as SOCKET, buffer as string) as boolean
    if(sock) then hSend(sock, buffer, len(buffer))
    return iif(sock, true, false)
end function

function receiveData(sock as SOCKET) as string
    if(sock) then
        dim as string buffer = space(4 + 5*4 + 6)
        dim as integer result = hReceive(sock, buffer, len(buffer))
        if(result <= 0) then buffer = ""
        return buffer
    end if
    return ""
end function

function randomizePong(p as pong, maxi as integer) as pong
    p.vx = ((50000*rnd()-25000)*0.5)+50000
    p.vy = ((50000*rnd()-25000)*0.5)+50000
    p.bx.w = (maxi/50)*rnd() + maxi/50
    p.r = 255*rnd()
    p.g = 255*rnd()
    p.b = 255*rnd()
    return p
end function

'function isColliding(p as pong, pad as paddle)

sub renderPong(p as pong, wdth as integer, hght as integer, maxi as integer)
    line((p.bx.x/maxi)*wdth-(p.bx.w/maxi)*wdth, (p.bx.y/maxi)*hght-(p.bx.w/maxi)*hght)-((p.bx.x/maxi)*wdth+(p.bx.w/maxi)*wdth, (p.bx.y/maxi)*wdth+(p.bx.w/maxi)*hght), rgb(p.r, p.g, p.b), bf
end sub

sub renderPaddle(pad as paddle, wdth as integer, hght as integer, maxi as integer)
    line((pad.bx.x/maxi)*wdth-(pad.bx.w/maxi)*wdth,(pad.bx.y/maxi)*hght-(pad.bx.h/maxi)*hght)-((pad.bx.x/maxi)*wdth+(pad.bx.w/maxi)*wdth,(pad.bx.y/maxi)*hght+(pad.bx.h/maxi)*hght),rgb(200, 200, 200), bf
end sub

dim as boolean runApp = true

dim as SOCKET serverSocket = hOpen()
dim as ulong port = 28000
hBind(serverSocket, port)
hListen(serverSocket)

dim as client cl

'Wait for connection
print("Waiting for connection...")
while(inkey() <> chr(27))
    if(hSelect(serverSocket)) then
        cl.sock = hAccept(serverSocket, cl.IP, cl.port)
        exit while
    end if
    printf(".")
    sleep(10, 1)
wend

printf(!"\nStarting game!\n")

if(cl.sock OR true) then
    print("" & hIPtoString(cl.IP) & ":" & cl.port)
    
    dim as paddle pad
    pad.bx.x = 9000
    pad.bx.y = 5000
    pad.bx.w = 250
    pad.bx.h = 1000
    pad.speed = 6000
    
    dim as pong p
    p.bx.x = 5000
    p.bx.y = 5000
    p.bx.w = 200
    p.bx.h = 200
    p.vx = 45000
    p.vy = 45000
    p.r = 200
    p.g = 100
    p.b = 200
    
    dim as boolean havePong = true
    
    dim as single timeStart
    dim as single dt
    
    dim as AuWindow wnd
    wnd.init(512, 512, 32, 1, 0, "Pong!")
    wnd.show()
    
    while(runApp)
        timeStart = timer()
        if(multikey(sc_escape)) then runApp = false
        
        if(multikey(sc_w)) then pad.bx.y-=pad.speed*dt
        if(multikey(sc_s)) then pad.bx.y+=pad.speed*dt
        if(multikey(sc_a)) then pad.bx.x-=pad.speed*dt
        if(multikey(sc_d)) then pad.bx.x+=pad.speed*dt
        if(multikey(sc_space)) then sleep()
        if(multikey(sc_r)) then
            p.bx.w+=10
            p.bx.h+=10
        end if
        if(multikey(sc_f)) then
            p.bx.w-=10
            p.bx.h-=10
        end if
        if(multikey(sc_g)) then p = randomizePong(p, 10000)
        
        if(havePong) then
            'Update our pong and get ready to send data
            p.bx.x+=(p.vx-50000)*dt
            p.bx.y+=(p.vy-50000)*dt
            
            if(p.bx.y < 0) then
                p.bx.y = 0
                p.vy = 100000-p.vy
            elseif(p.bx.y > 10000) then
                p.bx.y = 10000
                p.vy = 100000-p.vy
            end if
            
            if(p.bx.x > pad.bx.x-pad.bx.w AND p.bx.x < pad.bx.x+pad.bx.w AND p.bx.y > pad.bx.y-pad.bx.h AND p.bx.y < pad.bx.y+pad.bx.h) then
                p.bx.x = pad.bx.x-pad.bx.w
                p.vx = 100000-p.vx
            elseif(p.bx.x > 10000) then
                p.bx.x = 10000
                p.vx = 100000-p.vx
            elseif(p.bx.x <= 0) then
                havePong = false
                dim as string buffer = pongToBuffer(p, wnd.wdth, wnd.hght, 10000)
                sendData(cl.sock, buffer)
                printf(!"Sent: '%s'\n", buffer)
            end if
        else
            'We should be listening for incoming data
            if(hSelect(cl.sock)) then
                dim as string buffer = receiveData(cl.sock)
                if(len(buffer)) then
                    p = bufferToPong(buffer)
                    havePong = true
                    printf(!"Received: '%s'\n", buffer)
                else
                    printf(!"Client disconnected...\n")
                    sleep()
                    runApp = false
                end if
            end if
        end if
        
        screenLock()
        cls()
        renderPaddle(pad, 512, 512, 10000)
        if(havePong) then
            renderPong(p, 512, 512, 10000)
        end if
        screenUnlock()
        sleep(1, 1)
        dt = timer()-timeStart
    wend
end if

hClose(serverSocket)
end(0)
