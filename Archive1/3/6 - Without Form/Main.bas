'Initialization
randomize timer
#include "fbgfx.bi"
using fb

'Variables
dim shared as integer ff
ff = FreeFile
const maxpop = 9999999

dim shared as integer scrnx,scrny
screeninfo scrnx,scrny
screenres scrnx,scrny,32,2,1

dim shared as integer NewWorld,Pop
open "data\info.txt" For binary As #ff
if Err>0 then print "Error reading the file":Sleep:End
get #ff,,NewWorld
get #ff,,Pop
close

type entprop
    as string*32 state
    as integer x,y
end type
dim shared as entprop ent(maxpop)


'Sub write to file
sub FileWrite(i as integer)
    open "data\" & i & ".txt" For binary as #ff
    if Err>0 then print "Error writing the file":Sleep:End
    put #ff,,ent(i)
    close
end sub

'sub read the file
sub FileRead(i as integer)
    open "data\" & i & ".txt" For binary As #ff
    if Err>0 then print "Error reading the file":Sleep:End
    get #ff,,ent(i)
    close
end sub

sub createent()
    if pop <= maxpop then
        pop+=1
        with ent(pop)
            .x = scrnx*rnd
            .y = scrny*rnd
            .state = "ALIVE"
        end with
    end if
end sub

sub destroyent()
    if pop >= 0 then
        with ent(pop)
            .state = "DEAD"
        end with
        pop-=1
    end if
end sub

if newworld <> 1 then
    for i as integer = 0 to pop
        with ent(i)
            .x = scrny*rnd
            .y = scrny*rnd
            .state = "ALIVE"
        end with
    next i
    newworld = 1
else
    for i as integer = 0 to pop
        fileread(i)
    next i
end if

sub renderInfo()
    draw string(5,5),"Pop: " & pop+1
end sub

sub renderEnt(j as integer)
    with ent(j)
        pset(.x,.y)
    end with
end sub

for i as integer = 0 to pop
    if ent(i).state = "DEAD" then
    end if
next i

do
    screenlock
        cls
        for i as integer = 0 to pop
            if ent(i).state = "ALIVE" then
                renderEnt(i)
            end if
        next i
        renderInfo()
    screenunlock
    
    if multikey(sc_equals) then CreateEnt()
    if multikey(sc_minus) then DestroyEnt()
    
    
    sleep 15
loop until multikey(sc_escape)

for i as integer = 0 to pop
    filewrite(i)
next i

open "data\info.txt" For binary As #ff
if Err>0 then print "Error reading the file":Sleep:End
put #ff,,NewWorld
put #ff,,Pop
close