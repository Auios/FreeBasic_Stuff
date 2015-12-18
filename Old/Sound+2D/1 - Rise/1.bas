#include "aulib.bi"
'include "Fmod2.bi"
#include "fbgfx.bi"
using fb

randomize timer

dim as string fileName = ""
var song=int(5*rnd+1)
select case song
case 1
    fileName="Bell.mp3"
case 2
    fileName="Darwinia.mp3"
case 3
    fileName="Future.mp3"
case 4
    fileName="Lull.mp3"
case 5
    fileName="Overtones.mp3"
case else
    print "Error"
    sleep
    stop
end select

'FSOUND_Init(44100, 16, FSOUND_INIT_ACCURATEVULEVELS)
'dim as FSOUND_SAMPLE MySound
'MySound = FSOUND_Sample_Load(FSOUND_FREE,"data/"+FileName,FSOUND_LOOP_NORMAL,0 ,0)
'VAR iChannel = FSOUND_PlaySound(FSOUND_FREE, MySound)

scrn(1)
setmouse(,,0)

type entprop
    as ubyte used
    as single x,y,z
    as single vy,wave
    as ulong clr
end type
dim shared as entprop ent(1000)

sub init(i as integer)
    with ent(i)
        .x = ((sc.x*2)*rnd)-sc.x/2
        .z = 25*rnd+5
        
        if .used then
            .y = sc.y*rnd+sc.y+.z*2
        else
            .y = sc.y*2*rnd
            .used = 1
        end if
        
        .vy = (.z/25)
        .wave = 360*rnd
        
        '.clr = rgba(255,75,255*rnd,15)
        .clr = rgba(255*rnd,255*rnd,255*rnd,10)
    end with
end sub

sub calc()
    for i as integer = lbound(ent) to ubound(ent)
        with ent(i)
            .y-=.vy
            .wave+=.002
            if .wave > 360 then .wave-=.wave
            .x=.x+cos(.y/200)/5+(cos(.wave)/10)
            
            if .y < 0-.z then init(i)
        end with
    next i
end sub

sub render()
    screenlock
    cls
    for i as integer = lbound(ent) to ubound(ent)
        with ent(i)
            if .z >= 20 then
                for j as single = .z to 1 step -.z/20
                    circle(.x,.y),j,.clr,,,,f
                next j
            elseif .z >= 10 and .z < 20 then
                for j as single = .z to 1 step -.z/10
                    circle(.x,.y),j,.clr,,,,f
                next j
            elseif .z > 2 and .z < 10 then
                for j as single = .z to 1 step -.z/5
                    circle(.x,.y),j,.clr,,,,f
                next j
            elseif .z <= 2 then
                for j as single = .z to 1 step -.z/2
                    circle(.x,.y),j,.clr,,,,f
                next j
            end if
        end with
    next i
    screenunlock
end sub

for i as integer = lbound(ent) to ubound(ent)
    init(i)
next i

do
    calc()
    render()
    
    sleep 1,1
loop until multikey(sc_escape)