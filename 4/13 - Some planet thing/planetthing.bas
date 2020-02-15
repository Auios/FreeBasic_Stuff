#include "fbgfx.bi"
'#include "scrn.bas"
using fb

var seed = int(timer)
randomize seed
print seed

'scrn(,,,,"Planet Thing")
screenRes(800, 600, 32, 1, 0)

dim shared as single i,j,k,l
dim shared as integer update

type mouseProp
    as integer x,y
end type

type planetProp
    as single x,y
    as single mass
    as uinteger clr
    as uinteger population
    as uinteger troops
end type

type starProp
    as single x,y
    as single mass
    as uinteger clr
end type

dim shared as mouseProp mo
dim shared as planetProp planet(1)
dim shared as starProp star(200)

sub init()
    'Variables
    update = 1
    
    'Stars
    for i = lbound(star) to ubound(star)
        with star(i)
            .x = 800*rnd
            .y = 600*rnd
            .mass = 3*rnd
            .clr = rgba(255,255,255,100*rnd)
        end with
    next i
    
    'Planets
    for i = lbound(planet) to ubound(planet)
        with planet(i)
            .x = 800*rnd
            .y = 600*rnd
            .mass = 50*rnd+25
'            .clr = rgb(255*rnd,255*rnd,255*rnd)
            .clr = rgba(255*rnd,255*rnd,255*rnd,25*rnd+5)
        end with
    next i
end sub

sub controller()
    dim as event e
    if screenEvent(@e) then
        select case e.type
        case event_key_press
        case event_mouse_move
            mo.x = e.x
            mo.y = e.y
        case event_mouse_double_click
            print mo.x,mo.y
            'for i = lbound(planet) to ubound(planet)
                
        end select
        
        While Inkey <> "": Wend
    end if
end sub

sub calc()
    
end sub

sub render()
    if update then
        screenlock
        cls
        
        'Background
        line(0,0)-(800,600),rgb(0,0,0),"bf"
        
        'Stars
        for i = lbound(star) to ubound(star)
            with star(i)
                circle(.x,.y),.mass,.clr,,,,f
            end with
        next i
        
        'Planets
        for i = lbound(planet) to ubound(planet)
            with planet(i)
                circle(.x,.y),.mass,rgba(10,10,10,255),,,,f
                for j as single = .mass to 1 step (.mass / int(-.mass))*2 'I dont know how to explain this: (.z / int(-.z))*2, but the loop decrements and gives it a fuzzy look
                    circle(.x,.y),j,.clr,,,,f
                next j
'                circle(.x,.y),.mass
'                circle(.x,.y),.mass,.clr,,,,f
            end with
        next i
        
        'Filters
        var oifof = 0
            if oifof then
            var zxc = 1
            var dm = 70
            for i = 0 to 600*2 step 1
'                line(i,0)-(0,i),iif(zxc,rgba(10,10,10,dm*rnd),rgba(20,20,20,dm*rnd))
                line(0,i-71*rnd)-(800,i),iif(zxc,rgba(10,10,10,dm*rnd),rgba(20,20,20,dm*rnd))
                zxc = zxc xor 1
            next i
        end if
        
        update = 0
        
        screenunlock
    end if
end sub


'Main()

init()

do
    controller()
    calc()
    render()
    sleep 1,1
loop until multikey(&h01)

end 0
stop
