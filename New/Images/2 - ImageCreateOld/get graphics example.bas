 #include "fbgfx.bi"
 using fb
 
dim as integer scrnx,scrny
screeninfo scrnx,scrny
screenres scrnx,scrny,16,2,0

dim as fb.image ptr line1,stars 'create the original image and name it line1
dim as integer x = 0,y=240

line1 = imageCreate(1,64)
stars = imagecreate(scrnx,scrny)

for i as integer = 1 to 500
    pset(scrnx*rnd,scrny*rnd)
next
get(0,0)-(scrnx-1,scrny-1),stars

line(0,240)-(64,240) 'draw the initial line we will make line1
Get(0,240)-(64,240),line1

sleep
'Put the line down on the screen
Do
    screenlock
    Put (x,y), line1
    put (0,0),stars
    screenunlock
    
    if multikey(sc_d) then x += 1
    if multikey(sc_a) then x -= 1
    if multikey(sc_w) then y -= 1
    if multikey(sc_s) then y += 1
    
    sleep(5)
    'cls
Loop until multikey(sc_escape)
sleep