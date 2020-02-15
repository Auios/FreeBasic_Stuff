'#include "scrn.bas"
#include "fbgfx.bi"
using fb

randomize timer

'scrn(1)
screenRes(800, 600, 32, 1, 0)

dim shared as integer pause = 0 'When you press space it will pause the game.
dim shared as double start 'For timer.
dim shared as single cx,cy 'Sad attempt to get the center of the triangle.
dim shared as single avgx,avgy '10/1/2015 - My better attempt to get the center of the triangle
dim shared as byte pageDisplay = 2,pageWork = 1

dim as ushort min,max 'Easy to manipulate initial program array.
min = 1
max = 3

'The corners of the triangle.
type jointprop
    as single x,y
    as single vx,vy
    as single force
    
    as ushort tag
    
    declare constructor
end type
dim shared as jointprop joint(min to max)

constructor jointprop
    this.x = 800*rnd
    this.y = 600*rnd
    this.force = 50
    this.tag = 0
end constructor

sub newtri()' Gives new random values to push the triangle in various directions.
    start = timer
    
    for i as integer = lbound(joint) to ubound(joint)
        with joint(i)
            'Random forces
            .vx = .force*rnd-.force/2
            .vy = .force*rnd-.force/2
        end with
    next i
end sub

sub controller()' Get user input
    if multikey(sc_space) then pause = 1
end sub

sub math()' Do calculations and border control here.
    avgX = 0
    avgY = 0
    
    for i as integer = lbound(joint) to ubound(joint)
        with joint(i)
            
            'Move corners
            .x+=.vx
            .y+=.vy
            
            'Get average x,y
            avgX+=.x
            avgY+=.y
            
            'Border check
            if .x < 0 or .x > 800 then .x-=.vx:.vx*=-1
            if .y < 0 or .y > 600 then .y-=.vy:.vy*=-1
            
            'Diminish velocity
            .vx*=.95
            .vy*=.95
            
            'Sad attempt to get the center of triangle
            if i = ubound(joint) then
                cx+=.x
                cx/=i
                
                cy+=.y
                cy/=i
            else
                cx+=.x
                cy+=.y
            end if
            
            'A different sad attempt to ASSIGN tags on corners.
            
        end with
    next i
    
    avgX/=ubound(joint)
    avgY/=ubound(joint)
    
    pageWork = pageWork xor 3
    pageDisplay = pageDisplay xor 3
end sub

sub render()
    screenSet(pageWork,pageDisplay)
    cls
    
    for i as integer = lbound(joint) to ubound(joint)
        var j = i+1
        if j > ubound(joint) then j = lbound(joint)
        
        with joint(i)
            line(.x,.y)-(joint(j).x,joint(j).y),rgb(255,255,255)
            
        end with
    next i
    
    'Trying to find a way to fill the triangle. Idk how
'    for y as integer = 0 to 600
'        for x as integer = 0 to 800
'            if point(x,y) = rgb(255,255,255) then
'                line(0,y)-(x,y),rgb(100,100,100)
'                exit for
'            end if
'        next x
'    next y
    
    '10/1/2015
    'I found a way to fill the center! :D
    paint(avgX,avgY),rgb(200,200,200),rgb(255,255,255)
    
    screenSet(pageWork xor 3,pageDisplay xor 3)
    screenSync
    Flip
end sub

do
    'Wait some time before kicking the triangle
    if timer - start > 2*rnd+.5 then newtri()
    
    controller()
    math()
    
    screenlock
    render()
    screenunlock
    
    'Pause (This should be inside a function/sub)
    if pause then
        sleep
        pause = 0
    else
        sleep 1,1
    end if
loop until multikey(sc_escape)

'RIP 2015
screen 0
end 0