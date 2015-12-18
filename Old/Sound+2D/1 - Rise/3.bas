'Headers
'include "scrn.bas"
'include "Fmod2.bi"
#include "fbgfx.bi"
using fb

randomize timer

dim shared as ubyte debug = 1


'Declared subs and functions
declare sub load(as uinteger)
declare sub setSong(as ubyte)
declare function getSong() as ubyte
declare sub nextSong()
declare sub previousSong()
declare sub init(as uinteger)
declare sub controller()
declare sub calc()
declare sub render()

'Create the window and hide the mouse
SetEnviron("fbgfx=GDI")
'scrn(1600,940,,,,"Particles")
setmouse(,,0)

type scrnprop
    as integer x,y
end type

dim as scrnprop sc
sc.x = 800
sc.y = 600
screenres 800,600,32,1,0

'Declare Variables:
'Audio
'dim shared as FSOUND_SAMPLE song(1 to 5)
dim shared as integer songCurr=-1,songMax,songMin,chan

'Debug
dim shared as uinteger c,count,ticks,FPS,disFPS
dim shared as double timeStart
dim shared as ubyte pause = 0

'Colors and seperation space for the loading screen
dim shared as uinteger sep,i=200,o=100
sep=sc.x/8

'Keyboard and mouse events
dim shared as EVENT e

'Particle structure
type entprop
    as ubyte used,alive,r,g,b,tra 'rgba, tra = a
    as single x,y,z 'z decides the radius
    as single vy,wave 'veloctity of y. Wave is used to make all particles have their own individual waveyness
    as ulong clr
end type
dim shared as entprop ent(1 to 1000)

'First thing that is executed.
' setting variables and loading general things used in the program.
' I used to use "Init()" but then I switched to "Load()" which includes Init()
sub load(sim as uinteger)
    'For the FPS
    timeStart = timer
    
    'The loading screen background
    line(0,0)-(sep,sc.y),       rgb(o,o,o),"bf" 'dark gray
    line(sep,0)-(sep*2,sc.y),   rgb(o,o,i),"bf" 'blue
    line(sep*2,0)-(sep*3,sc.y), rgb(o,i,o),"bf" 'green
    line(sep*3,0)-(sep*4,sc.y), rgb(o,i,i),"bf" 'cyan
    line(sep*4,0)-(sep*5,sc.y), rgb(i,o,o),"bf" 'red
    line(sep*5,0)-(sep*6,sc.y), rgb(i,o,i),"bf" 'pink
    line(sep*6,0)-(sep*7,sc.y), rgb(i,i,o),"bf" 'yellow
    line(sep*7,0)-(sep*8,sc.y), rgb(i,i,i),"bf" 'light gray
    
    draw string(5,5),   "~~~Loading~~~",rgb(i,i,i)
    'Load audio
    draw string(5,15),  ">Initiating audio...",rgb(i,i,i)
'    FSOUND_Init(44100,16, FSOUND_INIT_ACCURATEVULEVELS)
'    song(1) = FSOUND_Sample_Load(FSOUND_FREE,"data/bell.mp3",FSOUND_LOOP_NORMAL,0 ,0)
'    song(2) = FSOUND_Sample_Load(FSOUND_FREE,"data/darwinia.mp3",FSOUND_LOOP_NORMAL,0 ,0)
'    song(3) = FSOUND_Sample_Load(FSOUND_FREE,"data/future.mp3",FSOUND_LOOP_NORMAL,0 ,0)
'    song(4) = FSOUND_Sample_Load(FSOUND_FREE,"data/lull.mp3",FSOUND_LOOP_NORMAL,0 ,0)
'    song(5) = FSOUND_Sample_Load(FSOUND_FREE,"data/overtones.mp3",FSOUND_LOOP_NORMAL,0 ,0)
    'Set the song to be played
    setSong(1)
    
    'Give all the particles random starting positions
    draw string(5,25),">Initiating entities...",rgb(i,i,i)
    for i as integer = lbound(ent) to ubound(ent)
        init(i)
    next i
    
    'Simulate the program to nicely space out the particles because
    ' randomizing the particles just was not enough to make it look nice
    draw string(5,35),">Similating program " & sim & " ticks into the future...",rgb(i,i,i)
    for i as integer = 1 to sim
        calc()
    next i
end sub

'Sets the current song. Stops whatever song was being played already.
sub setSong(i as ubyte = 1)
    FSOUND_StopSound(chan)
    songCurr = i
    chan = FSOUND_PlaySound(FSOUND_FREE,song(i))
end sub

'Gets the current song ID
function getSong() as ubyte
    return songCurr
end function

'Does setSong(getSong()+1) while also making sure the next song exists,
' if the song does not exist it will just loop back
sub nextSong()
    setSong(iif(getSong()>=ubound(song),lbound(song),getSong()+1))
end sub

'does setSong(getSong()-1) while also making sure the previous song exists,
' if the song does not exist it will just loop forward
sub previousSong()
    setSong(iif(getSong()-1<lbound(song),ubound(song),getSong()-1))
end sub

'This is called when a particle goes off screen or if the particle was
' never constructed before (.used)
sub init(i as uinteger)
    with ent(i)
        .x = ((sc.x*2)*rnd)-sc.x/2
        .z = 25*rnd+2
        
        if .used then
            .y = (sc.y*rnd)+sc.y*2
        else
            .y = sc.y*2*rnd
            .used = 1
        end if
        
        .vy = (.z/25) 'Velocity is based on .z and then muffled by dividing .z by a number.
        .wave = 360*rnd
        .tra = 25*rnd+5
        .r = 255*rnd
        .g = 255*rnd
        .b = 255*rnd
        
        .clr = rgba(.r,.g,.b,255/.tra) 'We need to make alpha very light because it will make it look fuzzy later on
    end with
end sub

'Get the user input
sub controller()
    if screenevent(@e) then
        select case e.type
        case event_key_release
            if e.scancode = 32 then '(D)
                debug = debug xor 1 'Toggle debug
                disFPS = 0
            end if
            if e.scancode = 77 then nextSong() '(RIGHT)
            if e.scancode = 75 then previousSong() '(LEFT)
            if e.scancode = 57 then pause = pause xor 1 '(SPACE) Toggle pause
        end select
    end if
end sub

sub calc()
    if pause = 0 then 'If pause then dont run anything here. This also means we can't calculate how many entities are being rendered...
        count = 0
        for i as integer = lbound(ent) to ubound(ent)
            with ent(i)
                if .x > 0-.z and .x < sc.x+.z and .y > 0-.z then 'Check if it's within the boundaries of the screen, but is allowed to be greater than sc.y
                    if .y > sc.y+.z then 'If it's below the screen then don't do fancy calculations on changing its position
                        .alive = 0
                        .y-=10
                    else 'Well it's position is on our screen now, so put effort into finding its new position
                        .alive = 1 'Tell us it's being rendered
                        count+=1 'Add it to the debug data
                        
                        .y-=(.vy+sin((.x/2+.y)/100)^3+.75)*3 'If you change the last number *n then it will increase speed. Could be programmed to make it
                                                             ' run faster if FPS is lower. That way the FPS does not control the visual speed of the program
                        .wave+=.002
                        if .wave > 360 then .wave-=.wave 'Could have used mod, but was getting strange results
                        .x+=(cos(.y/200)/5+(cos(.wave)/10))*3
                        
                        .z+=.005 'I have to make the particles grow or else they get stuck in the folds of the equation.
                        .vy = (.z/25) 'You can disable this to see what I mean
                        
                        'If the particles leave our view then respawn them.
                        if .y < 0-.z then init(i)
                        if .x > sc.x+.z*2 then init(i)
                        if .x < -.z*2 then init(i)
                    end if
                else 'If they are not then respawn them
                    init(i)
                    .alive = 0
                end if
            end with
        next i
        
        ticks+=1 'How many times 'Calc' was called.
    end if
end sub

'Render everything
sub render()
    screenlock
    cls
    
    'Render the particle based on its .z
    for i as integer = lbound(ent) to ubound(ent)
        with ent(i)
            for j as single = .z to 1 step (.z / int(-.z))*2 'I dont know how to explain this: (.z / int(-.z))*2, but the loop decrements and gives it a fuzzy look
                circle(.x,.y),j,.clr,,,,f
            next j
        end with
    next i
    
    if debug then 'If debug is enabled
        c = rgb(100,200,100)
        if pause then
            draw string(5,5),"Rendered Entities: N/A",rgb(200,100,100)
        else
            draw string(5,5),"Rendered Entities: " & count & "/" & ubound(ent),c
        end if
        draw string(5,15),"Ticks: " & ticks,c
        if disFPS > 0 then
            draw string(5,25),"FPS: " & disFPS,c
        else
            draw string(5,25),"FPS: >Getting FPS...",rgb(200,100,100)
        end if
        draw string(5,35),"Song: " & getSong(),c
        
        'Get FPS
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

'Load(Call calc # times)
'If I simply did for i; init(i); next i... then it'd look dumb when the program first runs
' I tried to make it evenly distribute when I first initiate all particles but failed to make it look good.
' So I figured just simulating the program for a long time would be a good solution, and it is.
load(10000)

'Main loop
do
    controller()
    calc()
    render()
    
    sleep 1,1
loop until multikey(sc_escape)

'Mysoft didnt include any examples for destroying fmod samples, so I'm gonna assume not closing anything is fine...
'...I hope...