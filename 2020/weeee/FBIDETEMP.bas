#include "fbgfx.bi"
#include "creature.bi"

#define fbc -s gui

using fb

sub clearScreen(w as integer, h as integer)
    line(0,0)-(w, h), rgb(255, 0, 255),bf
end sub

dim as boolean runApp = true

dim as integer scrnx, scrny
'scrnx = 800
'scrny = 600
screenInfo(scrnx, scrny)

screenRes(scrnx, scrny, 32, 1, GFX_SHAPED_WINDOW)

dim as any ptr rightSprite = imageCreate(8, 13)
bload("right.bmp", rightSprite)
dim as any ptr leftSprite = imageCreate(8, 13)
bload("left.bmp", leftSprite)

dim as integer count = 100
dim as Creature ptr c = new Creature[count]

for i as integer = 0 to count-1
    c[i].init(leftSprite, rightSprite, scrnx, scrny)
next i

while(runApp)
    if(multikey(sc_escape)) then runApp = false
    
    for i as integer = 0 to count-1
        c[i].update()
    next i
    
    screenLock()
    clearScreen(scrnx, scrny)
    for i as integer = 0 to count-1
        c[i].render()
    next i
    screenUnlock()
    sleep(1, 1)
wend

imageDestroy(leftSprite)
imageDestroy(rightSprite)