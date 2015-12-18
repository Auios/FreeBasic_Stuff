'Version 

#define fbc -a res\res.obj

randomize 0

#include "al/al.bi"
#include "al/alut.bi"
#include "vbcompat.bi"
#include "fbgfx.bi"

'-------------------------------------------------------------------------------Main Code

'Start window
dim shared as integer scrnx,scrny,fs,scr_mode

print
print "================"
print "~~~Resolution~~~"
print "1. (400x300), 0"
print "2. (640x480), n"
print "3. (800x600), n"
print "4.  (Native), 1"
print
print "0. Exit"
print "---------------"
input "scr_mode: ", scr_mode
if scr_mode > 4 then print "Error":sleep:stop
select case scr_mode
case 0
    end 0
case 2 to 3
    input "Fullscreen: (fs),(0 or 1) ",fs
end select

sub CreateWindow()
    
    select case scr_mode
    case 1
        scrnx = 400
        scrny = 300
        fs = 0
    case 2
        scrnx = 640
        scrny = 480
    case 3
        scrnx = 800
        scrny = 600
    case 4
        screeninfo scrnx,scrny
        fs = 1
    end select
    screenres scrnx,scrny,16,2,fs
end sub

const pi = atn(1)*4

dim shared as integer check,id,worldSize

declare sub InitWorld(SpawnRadius as single)
declare sub Controller()
declare sub Camera()
declare sub Render()

declare function Dist_2d(x1 as single,y1 as single,x2 as single,y2 as single) as single
declare function Dist_1d(a as single,b as single) as single

'~~~Types

type LynkProp 'Entity Properties
    as string*10 ID
    as integer exist
    as single x,y,sx,sy,sr
    as uinteger clr
    as single energy,food
    as integer population
end type
const maxLynk = 500
dim shared as LynkProp Lynk(maxLynk)

type cameraProp 'Camera Properties
    as single px,py
    as integer mx,my,omx,omy
    as single dmx,dmy
    as integer btn,oldwheel,wheel,distwheel,clip
    as integer result,check,near,t_near,sel
    as single zoom
end type
dim shared as cameraProp cam
cam.zoom = 1

'~~~Subs

sub InitWorld(SpawnRadius as single) 'Initialization before loop
    print "Loading Lynks... (" & MaxLynk & ")"
    for i as integer = 0 to MaxLynk
        with Lynk(i)
            if .exist = 0 then
                do
                    'ID = int(3*rnd)
                    ID = 0
                    check = 0
                    select case id
                    case 0 'Circle
                        .ID = "Circle"
                        check = 1
                        exit do
'                    case 1
'                        .ID = "Square"
'                        check = 1
                    end select
                loop until check = 1
                .exist = 1
                .clr = rgb(255*rnd,255*rnd,255*rnd)
                
                check = 0
                do
                    if i = 0 then 'Put the first Lynk somewhere in the middle.
                        .x = 300*rnd
                        .y = 150*rnd
                        .energy = 100*rnd+15
                    else
                        var theta = (360*rnd)*pi/180
                        
                        .x = (SpawnRadius*rnd)*cos(theta)
                        .y = (SpawnRadius*rnd)*sin(theta)
                        .energy = 100*rnd+15
                    end if
                    
                    for j as integer = 0 to MaxLynk
                        if Lynk(j).exist = 0 then check = 1
                        
                        if j <> i then if abs(dist_2d(.x,.y,Lynk(j).x,Lynk(j).y)) < .energy + Lynk(j).energy then exit for
                        if j = MaxLynk then check = 1
                    next j
                    if multikey(fb.sc_escape) then stop
                loop until check = 1
            end if
        end with
        print "--->Lynk: " & i
    next i
    
    cam.sel = 0
    cam.near = -1
    cam.zoom = 0.001
    print "Done..."
end sub

sub Controller() 'Keyboard input
    with cam
        if multikey(fb.sc_lshift) then
            if multikey(fb.sc_w) then .py+=5
            if multikey(fb.sc_s) then .py-=5
            if multikey(fb.sc_a) then .px+=5
            if multikey(fb.sc_d) then .px-=5
        else
            if multikey(fb.sc_w) then .py+=3
            if multikey(fb.sc_s) then .py-=3
            if multikey(fb.sc_a) then .px+=3
            if multikey(fb.sc_d) then .px-=3
        end if
        
        if multikey(fb.sc_space) then .sel = 0
    end with
end sub

'Mouse wheel
sub MouseWheel()
    with cam
        if .oldwheel <> .wheel then
            .distwheel = Dist_1d(.oldwheel,.wheel)
            
            .zoom*=1+(.distwheel/10)
            
            .oldwheel = .wheel
        end if
        
        'Prevent from zooming too far in or out. If zoomed in too far then program will lag and/or crash.
        var zoomout = .001
        var zoomin = 1
        
        if .zoom <zoomout then .zoom=zoomout
        if .zoom >zoomin then .zoom=zoomin
    end with
end sub

'Left click (Outdated)
'sub LeftClick()
'    for i as integer = 0 to maxLynk
'        with Lynk(i)
'            if .exist = 0 then continue for
'            
'            if abs(dist_2d(cam.mx,cam.my,.sx,.sy)) < .sr+50 then
'                cam.near = i
'                cam.sel = 1
'                exit for
'            else
'                cam.sel = 0
'            end if
'        end with
'    next i
'end sub

'Left click
sub LeftClick2()
    for i as integer = 0 to maxLynk
        with Lynk(i)
            if .exist = 0 then continue for
            
            if cam.sel = 1 then
                if abs(dist_2d(cam.mx,cam.my,.sx,.sy)) - .sr+50 < abs(dist_2d(cam.mx,cam.my,Lynk(cam.near).sx,Lynk(cam.near).sy)) - Lynk(cam.near).sr+50 then
                    cam.near = i
                    if abs(dist_2d(cam.mx,cam.my,.sx,.sy)) < .sr+50 then
                        cam.sel = 1
                        continue for
                    else
                        cam.sel = 0
                    end if
                end if
            else
                if abs(dist_2d(cam.mx,cam.my,.sx,.sy)) < .sr+50 then
                    cam.near = i
                    cam.sel = 1
                    continue for
                else
                    cam.sel = 0
                end if
            end if
        end with
    next i
end sub

'Right click
sub RightClick()
    with cam
        .dmx = Dist_1d(.omx,.mx)/.zoom
        .dmy = Dist_1d(.omy,.my)/.zoom
        
        .px+=.dmx
        .py+=.dmy
    end with
end sub

'Secret :)
dim shared as integer osht
sub MiddleClick()
    osht = 1
end sub

sub Camera() 'Scrolling and mouse functions
    osht = 0
    with cam
        'Get mouse position on screen
        .result = GetMouse(.mx,.my,.wheel,.btn,.clip)
        
        'Check if mouse is even on screen
        if .result = 0 then 'Mouse is on screen, so let's change stuff
            'Handle mouse wheel for zooming
            MouseWheel()
            
            'Handle mouse buttons being pressed
            select case .btn
            case 1 'Left click
                LeftClick2()
                
            case 2 'Right click
                'Get distance of the dragging and translate the camera coordinates. p = position, d = distance, m = mouse, o = old
                RightClick()
                
            case 3 'Both Left and Right click
                LeftClick2()
                RightClick()
                
            case 4
                MiddleClick()
                
            case 5
                LeftClick2()
                MiddleClick()
                
            case 6
                RightClick()
                MiddleClick()
                
            case 7
                LeftClick2()
                RightClick()
                MiddleClick()
                
            end select
            
            .omx = .mx
            .omy = .my
        end if
    end with
end sub

sub Render() 'Render stuff to the window
    screenlock
        cls
        'Render Lynks
        var sizer = 1
        for i as integer = 0 to MaxLynk
            with Lynk(i)
                if .exist = 1 then
                    select case .ID
                    case "Circle"
                        .sx = (.x+cam.px)*cam.zoom+scrnx/2
                        .sy = (.y+cam.py)*cam.zoom+scrny/2
                        .sr = (.energy*sizer)*(cam.zoom)
                        circle(.sx,.sy),.sr,.clr,,,,f
                    end select
                end if
            end with
        next i
        
        'Display border of the universe
        circle((0+cam.px)*cam.zoom+scrnx/2,(0+cam.py)*cam.zoom+scrny/2),WorldSize*(cam.zoom)
        
        'Render Text/Debug
        with cam
            
            'Is a Lynk selected?
            if .sel = 1 then 'Yes, so display the information of the selected Lynk
                if .result = 0 then if .near > -1 then line(.mx,.my)-(Lynk(.near).sx,Lynk(.near).sy)
                line(scrnx/3,scrny-40)-((scrnx/3)*2,scrny),rgb(0,0,255),"bf"
                draw string((scrnx/3)+5,scrny-35),"Energy: " & format(Lynk(cam.near).energy,"0.00")
                
            end if
            
            'Display debug information
            draw string(5, 5),"Btn: " & .btn
            draw string(5,15),"Dist_x: " & Dist_1d(.omx,.mx)
            draw string(5,25),"Dist_y: " & Dist_1d(.omy,.my)
            draw string(5,35),"px: " & .px
            draw string(5,45),"py: " & .py
            draw string(5,55),"Zoom: " & .zoom
            draw string(5,65),"Result: " & .result
            
            'Render the mouse pointer
            if .result = 0 then
                var sz = 1
                line(.mx-sz,.my-sz)-(.mx+sz,.my+sz),,"bf"
                circle(.mx,.my),3
            end if
        end with
        
        'Easter egg! omgomg!!!
        if osht = 1 then
            for i as integer = 0 to 100
                draw string(scrnx*rnd,scrny*rnd),"SECRET_BUTTON",rgb(255*rnd,255*rnd,255*rnd)
            next i
        end if
    screenunlock
end sub

'~~~Math
function Dist_2d(x1 as single,y1 as single,x2 as single,y2 as single) as single
    return sqr(((x2-x1)*(x2-x1))+((y2-y1)*(y2-y1)))
end function

function Dist_1d(a as single,b as single) as single
    return b-a
end function

'-------------------------------------------------------------------------------Main Loop

WorldSize = 250000
InitWorld(WorldSize)

CreateWindow()

SetMouse(,,0,)
do
    Controller()
    Camera()
    Render()
    
    sleep 15
loop until multikey(fb.sc_escape)

screen 0

end 0

'World's best loop 2014 ^