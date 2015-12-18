'Librarys
#include "fbgfx.bi"
using fb

'Random function
randomize timer

'Display instructions on console
print "R. Reset"
print "C. Select color"
print "P. Toggle rainbow"

'Screen variable information get
dim as integer                              scrnx,scrny,depth,pitch,rate,driver
ScreenRes 800,600,8,2,0
screeninfo                                  scrnx,scrny,depth,pitch,rate,driver

'Declare all program variables
dim as integer                              x,y,notice,rainbow=0
dim as integer                              col,colset,colsave
dim as integer                              mox,moy,res,pres,wheel,clip

dim as integer                              temp,temp1
dim as string                               control
Dim As integer Ptr                          img

'Setting default variables
x       = 0
y       = 0
notice  = 0
col     = 0
temp    = 32
control = "RESET"

'Main program loop
do
    'Getting mouse information
    res     = getmouse  (mox,moy,wheel,clip)
    pres    = point     (mox,moy)
    
    if wheel < 0 then setmouse,,,0
    
    'User input controls
    if multikey (sc_r)       then control = "RESET"
    if multikey (sc_c)       then control = "COLOR"
    if multikey (sc_p)       then control = "RAINBOW"
    if multikey (sc_escape)  then control = "END"
    
    'After rainbow is disabled this will get the original color before enabled rainbow
    if control = "RAINBOW" and rainbow = 0 then temp1=colset
    
    'Clear key buffer
    While Inkey <> "": Wend
    
    'Case controled activity
    select case control
    
    'Displays information and checks variables
    case "MAIN"
        
        'Clear key buffer
        While Inkey <> "": Wend
        
        'Clear display
        screenlock
        line (0,0) - (90,75),40,"bf"
        
        'Print display
        draw string (5,5), "X:"         & mox
        draw string (5,15),"Y:"         & moy
        draw string (5,25),"Color:"     & pres
        draw string (5,35),"Mouse:"     & (res-1) * -1
        draw string (5,45),"Clip:"      & clip
        draw string (5,55),"Wheel:"     & wheel
        draw string (5,65),"Color:"     & colset
        screenunlock
        
        'Check is mouse button is true and then paints square
        if clip = 1 and wheel <> 0 then
            wheel -= 1
            line (mox-wheel,moy-wheel) - (mox+wheel,moy+wheel),colset,bf
        end if
        
        'Checks for rainbow mode
        if rainbow = 1 then
            if temp < 32 then temp = 32
            if colset > temp + (23) then colset = temp
            sleep 1
            colset += 1
        end if
        
        'Wait 5ms
        sleep 5
        
    'Resets the screen back to default
    case "RESET"
        
        'Clear key buffer
        While Inkey <> "": Wend
        
        'Reset main variables back to default
        x       = 0
        y       = 0
        notice  = 0
        col     = 0
        
        'Paints the screen
        do
            screenlock
            line (x,y) - (x,scrny),col
            x +=1
            
            if x = notice + 10 then
                notice  = x
                col    += 1
            end if
            
            screenunlock
        loop until x > scrnx
        
        'Mode, main
        control = "MAIN"
        
    'Custom color selecting script
    case "COLOR"
        
        'Clear key buffer
        While Inkey <> "": Wend
        
        'Checks for rainbow mode. If true then disable custom color mode
        if rainbow = 0 then
            get (0,0) - (scrnx,scrny),img
            draw string (5,85),"Color:" & colset
            input col
        end if
        
        'Mode, main
        control = "MAIN"
        
    'Rainbow script
    case "RAINBOW"
        
        'Clear key buffer
        While Inkey <> "": Wend
        
        'Resets color
        colset          = temp1
        
        'Toggle functions
        select case rainbow
        case 0
            rainbow     = 1
            colsave     = colset
        case 1
            rainbow     = 0
            colset      = colsave
        end select
        
        'Mode, main
        control = "MAIN"
    end select
loop until control = "END"