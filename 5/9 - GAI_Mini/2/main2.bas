'Main2.bas

'=====Defines=====
#define debugMode 1
#define TRUE 1
#define FALSE 0
#define NULL 0

'=====Compile Parameters=====
'define fbc -s gui
    'Commented this parameter so the console window is not disabled
    'Console used for debugging

'=====Headers=====
#include "crt.bi"
#include "fbgfx.bi"
#include "GAIScreen.bi"
#include "GAIMouse.bi"
#include "GAIWindows.bi"

'=====Sources=====
#include "GAIScreen.bas"
#include "GAIMouse.bas"
#include "GAIWindows.bas"

'=====Other=====
randomize timer
using GAIMini

'=====Declares=====

'=====Global Variables=====
dim shared as GAIScreen gaiScr
dim shared as GAIMouse gaiMs
dim shared as GAIWindow gaiWnd

'=====Variables=====
dim as string key 'For keyboard input

'=====Operators=====

'=====Main Code=====
gaiScr.create()

do
    gaiMs.watch()
    
    if gaiMs.button = 1 then
        gaiMs.hold()
        if gaiWnd.mouseOnTitleBar(gaiMs) then
            gaiWnd.setPosition(gaiMs.x-100,gaiMs.y-8) 'Move window with delta x,y
        elseif gaiWnd.mouseOnResizeBar(gaiMs) then
            gaiWnd.setSize(gaiMs.dx,gaiMs.dy)
        end if
    else
        gaiMs.release()
    end if
    
    key = inkey()
    select case key
    case chr(27) 'Escape - Exit loop, end program
        exit do
    case chr(32) 'Space - Debug event
        gaiWnd.setSize(400,300)
    end select
    
    screenlock
        gaiScr.clearScreen()
        if gaiMs.changed() then gaiMs.dump()
        gaiWnd.render()
    screenunlock
    
    sleep 1,1
loop

gaiScr.destroy()

end 0