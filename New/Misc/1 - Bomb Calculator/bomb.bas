
#include "fbgfx.bi"
using fb
randomize timer

dim shared as integer scrnx,scrny
screeninfo scrnx,scrny
screenres scrnx,scrny,16,2,1

dim as integer game=1
dim as integer total = 500,selected,already(1 to total)
dim as integer bomb,remain=total
dim as uinteger white = rgb(255,255,255)
dim as integer wins,loses

do
    bomb = total*rnd
    game = 1
    total = 500
    selected = 0
    bomb = 0
    remain = total

    for i as integer = 1 to total
        already(i)=0
    next


    do
        selected=total*rnd
        
        if already(selected)=0 then
            already(selected)=1
            remain-=1
            
            screenlock
            cls
            draw string(5,5),"Remaining: " & remain,white
            draw string(5,15),"Safe: " & selected,white
            draw string(5,25),"Wins/Loses(" & wins & "/" & loses & ")"
            screenunlock
        end if
        
        if remain = 0 then game = 0
        if selected = bomb then game=-1
        
        sleep 1
    loop until game=0 or game = -1 or multikey(sc_escape)
    
    if game = -1 then
        cls
        draw string(5,5),"Remaining: " & remain,white
        draw string(5,15),selected & " = Bomb: " & bomb,white
        draw string(scrnx/2,scrny/2),"Bomb",white
        loses+=1
    end if
    
    if game = 0 then
        cls
        draw string(5,5),"Remaining: " & remain,white
        draw string(5,15),selected & " = Safe",white
        draw string(scrnx/2,scrny/2),"Safe",white
        wins+=1
    end if
    sleep 100
loop until multikey(sc_escape)