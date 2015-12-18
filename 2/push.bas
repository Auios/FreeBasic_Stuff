#include "fbgfx.bi"
using fb
randomize timer
 
dim shared as integer scrnx,scrny,workpages,fullscreen
fullscreen = 0
workpages = 1
scrnx = 800
scrny = 600
screenres scrnx,scrny,16,workpages,fullscreen

type PlayerProp
    as integer x,y
    as integer size
    as integer speed
    as uinteger clr
    as string name
end type
dim shared as PlayerProp Pl
 
type EnvironmentProp
    as integer x,y
    as integer size
    as uinteger clr
end type

dim shared as integer EnvironmentCount = 20
dim shared as EnvironmentProp Env(EnvironmentCount)
dim shared as integer Loopdistance = 20
dim shared as integer Coli
dim shared as integer Tab_Input
dim shared as string Cmd

sub Collision()
    for i as integer = 0 to EnvironmentCount
        with Env(i)
            'Collision for the player
            Coli = 0
            
            if pl.x + pl.size - 0.2 >= .x - .size and pl.x + pl.size + 0.2 <= .x + .size and pl.y >= .y - (.size + (pl.size / 2)) and pl.y <= .y + (.size + (pl.size / 2)) then .x += pl.speed:Coli = 1 'pl.x -= pl.speed 'Right-Side
            if pl.x - pl.size + 0.3 <= .x + .size and pl.x - pl.size - 0.3 >= .x - .size and pl.y >= .y - (.size + (pl.size / 2)) and pl.y <= .y + (.size + (pl.size / 2)) then .x -= pl.speed:Coli = 1 'pl.x += pl.speed 'Left-Side
            if pl.y + pl.size - 0.3 >= .y - .size and pl.y + pl.size + 0.3 <= .y + .size and pl.x >= .x - (.size + (pl.size / 2)) and pl.x <= .x + (.size + (pl.size / 2)) then .y += pl.speed:Coli = 1 'pl.y -= pl.speed 'Bottom-Side
            if pl.y - pl.size + 0.2 <= .y + .size and pl.y - pl.size - 0.2 >= .y - .size and pl.x >= .x - (.size + (pl.size / 2)) and pl.x <= .x + (.size + (pl.size / 2)) then .y -= pl.speed:Coli = 1 'pl.y += pl.speed 'Top-Side
            
            if pl.x - pl.size-Loopdistance > scrnx then pl.x = -pl.size-Loopdistance
            if pl.x + pl.size+Loopdistance < 0 then pl.x = scrnx + pl.size+Loopdistance
            if pl.y - pl.size-Loopdistance > scrny then pl.y = -pl.size-3
            if pl.y + pl.size+Loopdistance < 0 then pl.y = scrny + pl.size+Loopdistance
            
        end with
    next i
end sub

sub Controller()
    with Pl
        if multikey(sc_w) then .y -= .speed
        if multikey(sc_a) then .x -= .speed
        if multikey(sc_s) then .y += .speed
        if multikey(sc_d) then .x += .speed
    end with
end sub
 
sub Environment()
    for i as integer = 0 to EnvironmentCount
        with Env(i)
            line(.x-.size,.y-.size)-(.x+.size,.y+.size),.Clr,"bf"
        end with
    next i
end sub
 
sub Render()
    with Pl
        screenlock
            cls
            Environment()
            line(.x-.size,.y-.size)-(.x+.size,.y+.size),.Clr,"bf"
            circle(.x,.y),.size,rgb(255,255,255)
            draw String(.x + .size - len(.name) * 4, .y - .size - 10), .name
        screenunlock
    end with
end sub
 
sub Initialize()
    
    with Pl
        .x = scrnx * rnd
        .y = scrny * rnd
        .speed = 3
        .clr = rgb(255, 255, 255)
        .size = 5
        input "Name: ",.name
    end with
    for i as integer = 0 to EnvironmentCount
        with Env(i)
            .x = scrnx * rnd
            .y = scrny * rnd
            .size = 15 * rnd + 10
            .clr = rgb(255*rnd, 255*rnd, 255*rnd)
        end with
    next i
end sub

Initialize()
do
    Controller()
    Collision()
    Render()
    sleep 15
loop until multikey(sc_escape)
sleep