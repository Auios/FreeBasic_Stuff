'main.bas
#define fbc -s gui

#include "fbgfx.bi"

#include "GAIWindow.bi"

#include "GAIWindow.bas"

randomize timer

type screenP
    as integer x,y
end type

type mouseProp
    as integer result,x,y,wheel,buttons
end type

type windowProp
    private:
        as integer x,y,w,h
        as string title
    public:
        declare sub init()
        declare sub render()
        
        as byte isShowing,update
end type

sub windowProp.init()
    with this
        .update = 1
        .isShowing = 0
        .x = 300
        .y = 300
        .w = 200
        .h = 100
        
        .title = "Application Window"
    end with
end sub

sub windowProp.render()
    var titleBarSpace = 12
    var dragBarSpace = 10
    
    with this
        .update = 0
        line(.x,.y)-(.x+.w,.y+.h),rgb(200,200,200),bf
        line(.x,.y+titleBarSpace)-(.x+.w,.y+titleBarSpace),rgb(100,100,100)
        line(.x+.w-dragBarSpace,.y+.h)-(.x+.w,.y+.h-dragBarSpace),rgb(100,100,100)
        line(.x+.w-dragBarSpace/2,.y+.h)-(.x+.w,.y+.h-dragBarSpace/2),rgb(100,100,100)
        line(.x,.y)-(.x+.w,.y+.h),rgb(100,100,100),b
        draw string(x+6,y+2),.title,rgb(50,50,50)
    end with
end sub

dim shared as screenP sc
dim shared as mouseProp ms
dim shared as windowProp wn

sub printMouse(ms as mouseProp)
    with ms
        print .result
        print .x
        print .y
        print .wheel
        print .buttons
    end with
end sub

with sc
    screeninfo .x,.y
    screenres .x,.y,32,1,fb.GFX_SHAPED_WINDOW or fb.GFX_HIGH_PRIORITY
    line(0,0)-(.x-1,.y-1),rgb(255,0,255),bf
end with

wn.init()

do
    with ms
        .result = getMouse(.x,.y,.wheel,.buttons)
    end with
    
    var k = inkey()
    select case k
    case chr(27)
        exit do
    case chr(32)
        wn.isShowing = wn.IsShowing xor 1
    end select
    
    'loop here
    if wn.isShowing or wn.update then
        screenlock
        cls
        line(0,0)-(sc.x-1,sc.y-1),rgb(255,0,255),bf
        if wn.isShowing then wn.render()
        printMouse(ms)
        
        screenunlock
    end if
    
    sleep 1,1
loop

screen 0
end 0