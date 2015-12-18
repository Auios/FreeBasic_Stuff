#include "scrn.bas"
#include "Fmod2.bi"
#include "fbgfx.bi"
using fb

randomize timer

dim shared as ubyte debug = 1

declare sub load(as uinteger)
declare sub setSong(as ubyte)
declare function getSong() as ubyte
declare sub nextSong()
declare sub previousSong()
declare sub init(as integer)
declare sub controller()
declare sub calc()
declare sub render()

scrn(1)
setmouse(,,0)

dim shared as FSOUND_SAMPLE song(1 to 5)
dim shared as integer songCurr=-1,songMax,songMin,chan
dim shared as any ptr pFFT
dim shared as single ptr pfVU

dim shared as uinteger c,count,ticks,FPS,disFPS
dim shared as double timeStart
dim shared as ubyte pause = 0

dim shared as uinteger sep,i=200,o=100
sep=sc.x/8

dim shared as EVENT e

type entprop
    as ubyte used,alive,r,g,b,tra
    as single x,y,z
    as single vy,wave
    as ulong clr
end type
dim shared as entprop ent(1 to 1000)

sub load(sim as uinteger)
    timeStart = timer
    
    line(0,0)-(sep,sc.y),       rgb(o,o,o),"bf" 'dark gray
    line(sep,0)-(sep*2,sc.y),   rgb(o,o,i),"bf" 'blue
    line(sep*2,0)-(sep*3,sc.y), rgb(o,i,o),"bf" 'green
    line(sep*3,0)-(sep*4,sc.y), rgb(o,i,i),"bf" 'cyan
    line(sep*4,0)-(sep*5,sc.y), rgb(i,o,o),"bf" 'red
    line(sep*5,0)-(sep*6,sc.y), rgb(i,o,i),"bf" 'pink
    line(sep*6,0)-(sep*7,sc.y), rgb(i,i,o),"bf" 'yellow
    line(sep*7,0)-(sep*8,sc.y), rgb(i,i,i),"bf" 'light gray
    
    draw string(5,5),   "~~~Loading~~~",rgb(i,i,i)
    draw string(5,15),  ">Initiating audio...",rgb(i,i,i)
    FSOUND_Init(44100,16, FSOUND_INIT_ACCURATEVULEVELS)
    pFFT = FSOUND_DSP_GetFFTUnit()
    FSOUND_DSP_SetActive(pFFT, 1)
    pfVU = FSOUND_DSP_GetSpectrum()
    song(1) = FSOUND_Sample_Load(FSOUND_FREE,"data/bell.mp3",FSOUND_LOOP_NORMAL,0 ,0)
    song(2) = FSOUND_Sample_Load(FSOUND_FREE,"data/darwinia.mp3",FSOUND_LOOP_NORMAL,0 ,0)
    song(3) = FSOUND_Sample_Load(FSOUND_FREE,"data/future.mp3",FSOUND_LOOP_NORMAL,0 ,0)
    song(4) = FSOUND_Sample_Load(FSOUND_FREE,"data/lull.mp3",FSOUND_LOOP_NORMAL,0 ,0)
    song(5) = FSOUND_Sample_Load(FSOUND_FREE,"data/overtones.mp3",FSOUND_LOOP_NORMAL,0 ,0)
    setSong(1)
    
    draw string(5,25),">Initiating entities...",rgb(i,i,i)
    for i as integer = lbound(ent) to ubound(ent)
        init(i)
    next i
    
    draw string(5,35),">Similating program " & sim & " ticks into the future...",rgb(i,i,i)
    for i as integer = 1 to sim
        calc()
    next i
end sub

sub setSong(i as ubyte = 1)
    FSOUND_StopSound(chan)
    songCurr = i
    chan = FSOUND_PlaySound(FSOUND_FREE,song(i))
end sub

function getSong() as ubyte
    return songCurr
end function

sub nextSong()
    setSong(iif(getSong()>=ubound(song),lbound(song),getSong()+1))
end sub

sub previousSong()
    setSong(iif(getSong()-1<lbound(song),ubound(song),getSong()-1))
end sub

sub init(i as integer)
    with ent(i)
        .x = ((sc.x*2)*rnd)-sc.x/2
        .z = 25*rnd+2
        
        if .used then
            .y = (sc.y*rnd)+sc.y*2
        else
            .y = sc.y*2*rnd
            .used = 1
        end if
        
        .vy = (.z/25)
        .wave = 360*rnd
        .tra = 25*rnd+5
        .r = 255*rnd
        .g = 255*rnd
        .b = 255*rnd
        
        '.clr = rgba(255,75,255*rnd,15)
        .clr = rgba(.r,.g,.b,255/.tra)
    end with
end sub

sub controller()
    if screenevent(@e) then
        select case e.type
        case event_key_release
            if e.scancode = 32 then
                debug = debug xor 1
                disFPS = 0
            end if
            if e.scancode = 77 then nextSong()
            if e.scancode = 75 then previousSong()
            if e.scancode = 57 then pause = pause xor 1
        end select
    end if
end sub

sub calc()
    if pause = 0 then
        count = 0
        for i as integer = lbound(ent) to ubound(ent)
            with ent(i)
                if .x > 0-.z and .x < sc.x+.z and .y > 0-.z then
                    if .y > sc.y+.z then
                        .alive = 0
                        .y-=10
                    else
                        .alive = 1
                        count+=1
                        
                        .y-=(.vy+sin((.x/2+.y)/100)^3+.75)*3
                        .wave+=.002
                        if .wave > 360 then .wave-=.wave
                        .x+=(cos(.y/200)/5+(cos(.wave)/10))*3
                        
                        .z+=.005
                        .vy = (.z/25)
                        
                        if .y < 0-.z then init(i)
                        if .x > sc.x+.z*2 then init(i)
                        if .x < -.z*2 then init(i)
                    end if
                else
                    init(i)
                    .alive = 0
                end if
            end with
        next i
        
        ticks+=1
    end if
end sub

sub render()
    screenlock
    cls
    for i as integer = lbound(ent) to ubound(ent)
        with ent(i)
            for j as single = .z to 1 step (.z / int(-.z))*2
                circle(.x,.y),j,.clr,,,,f
            next j
        end with
    next i
    
    if debug then
        c = rgb(100,200,100)
        if pause then
            draw string(5,5),"Entities being rendered: N/A",rgb(200,100,100)
        else
            draw string(5,5),"Entities being rendered: " & count & "/" & ubound(ent),c
        end if
        draw string(5,15),"Ticks: " & ticks,c
        if disFPS > 0 then
            draw string(5,25),"FPS: " & disFPS,c
        else
            draw string(5,25),"FPS: >Calculating FPS...",rgb(200,100,100)
        end if
        draw string(5,35),"Song: " & getSong(),c
        
        if timer - timeStart > 1 then
            timeStart = timer
            
            disFPS = FPS
            FPS = 0
        else
            FPS+=1
        end if
    end if
    screenunlock
end sub

'for i as integer = lbound(ent) to ubound(ent)
'    init(i)
'next i
load(10000)

do
    controller()
    calc()
    render()
    
    sleep 1,1
loop until multikey(sc_escape)