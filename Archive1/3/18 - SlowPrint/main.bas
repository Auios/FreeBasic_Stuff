#include "fbgfx.bi"
using fb

dim shared as integer scrnx,scrny
scrnx = 800
scrny = 600
screenres scrnx,scrny,16

randomize timer

sub SlowPrint(x as integer, y as integer,message as string, delay as integer)
    for i as integer = 0 to len(message)
        locate(y,x):print left(message,i)
        sleep delay,1
    next i
end sub

sleep

SlowPrint(0,1,"They tried to kill your daughter...",100)
sleep 500,1
SlowPrint(0,2,"You wonder if that clown will ever stop staring at you...",100)
sleep 500,1
SlowPrint(0,3,"A man from behind you executes your brother to your left...",100)
sleep 500,1
SlowPrint(0,4,"You pass out",100)
sleep 500,1

getkey
sleep
