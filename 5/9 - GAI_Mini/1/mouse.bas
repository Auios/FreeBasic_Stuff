#include "fbgfx.bi"

screen 11

type mouseProp
    as integer result,x,y,wheel,buttons
end type

dim shared as mouseProp ms

do
    with ms
        .result = getMouse(.x,.y,.wheel,.buttons)
        
        screenlock
        cls
        
        print .result
        print .x
        print .y
        print .wheel
        print .buttons
        screenunlock
    end with
    
    sleep 1,1
loop until multikey(fb.sc_escape)

screen 0
end 0