#include once "fbgfx.bi"
using fb
randomize timer

dim as integer scrnx,scrny
'screenres 1600,900,8,2,1    'Computer Lab
    'Netbook
'screenres 1024,768,8,2,1
'screenres 950,600,8,2,1
'screenres 800,600,8,2,1
'screenres 640,480,8,2,1
screeninfo scrnx,scrny
screenres scrnx,scrny,8,2,1
dim as integer x,y,col,mode,max

x=0
y=scrny
mode=0
max=1
col=0

do
    'col+=1
    'if col > 31 then col = 16
    col=255*rnd
    
    for i as integer = 1 to max
        line(x,y)-(scrnx,scrny),col
        
        select case mode
        case 0
            y-=1
            if y=0 then
                mode=1
                x=0
                y=0
            end if
        case 1
            x+=1
            if x=scrnx then
                'x=0
                y=scrny
                mode=0
            end if
        end select
        
        if multikey(sc_escape) then exit for
        
    next
loop until x=scrnx or multikey(sc_escape)
sleep
screen 0
end 0