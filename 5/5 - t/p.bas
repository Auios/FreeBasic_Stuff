#include "fbgfx.bi"
#include "scrn.bas"
#include "crt.bi"

using fb

randomize timer

'Screen
printf(!"Init screen\n")
scrn()

'Enums
enum gameState
    runn
end enum

'Structs
type nodeProp
    as single x,y
end type

'Dims
dim as gameState gs
dim as nodeProp pnt(0)

'Subs/Funcs
sub drawBackground()
    line(0,0)-(sc.x,sc.y),rgb(100,100,100),"bf"
end sub

sub initFirstPnt(pnt as nodeProp)
    with pnt
        .x = 0
        .y = sc.y/2
        
        circle(.x,.y),3,rgb(200,200,200),,,,f
    end with
end sub

sub calcNextPnt(pnt() as nodeProp)
    
end sub

'=====Main Code=====

'Init
drawBackground()
initFirstPnt(pnt(0))

'Loop
do
    'Get user input
    var k = inkey()
    select case ucase(k)
    case " "
        print "Space"
    end select
    
loop until multikey(sc_escape)