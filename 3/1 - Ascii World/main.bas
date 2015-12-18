#include "fbgfx.bi"
using fb
randomize timer

dim shared as integer scrnx,scrny
screeninfo scrnx,scrny
screenres scrnx,scrny,16,2,1
setmouse(,,0)

dim as integer esclp = 0
do
    cls
    print "---Main Menu---"
    print "1. Load game"
    print "2. New Game"
    print "0. Quit"
    
    dim as string ans
    input "Input: ",ans
    
    select case ans
    case "1"
        
    case "2"
        
    case "0"
        stop
    case else
        print "Invalid input!"
        sleep 500
    end select
loop until esclp = 1