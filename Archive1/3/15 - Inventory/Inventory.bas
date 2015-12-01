'Headers and stuff
#include "fbgfx.bi"
using fb
randomize timer

'Instructions for the plebs
print "Move selector:"
print ,"Up/Down"
print
print "Add random item:"
print ,"Enter"
print
print "Remove item:"
print ,"Space"

'Make the window
dim shared as integer scrnx,scrny
scrnx = 800
scrny = 600
screenres scrnx,scrny,16,2,0

'Some variables we will be using
dim shared as integer selected
dim shared as double selectedtime

'Array ceilings
dim shared as integer MaxObj = 36

'Types
type objectprop
    as Integer Used
    as integer ID
    as string sign
end type
dim shared as objectprop obj(MaxObj)

'Initiate the first random items for us to play around with
' n = How many initial random items will be added
sub init(n as integer)
    dim as integer sel
    for i as integer = 0 to n
        do
            sel = 11*rnd
            'Looking for a random number
            if sel <> 0 and sel <> 11 then
                with Obj(i)
                    select case sel
                    case 1
                        .ID = sel:.sign = "Keys"
                    case 2
                        .ID = sel:.sign = "Rock"
                    case 3
                        .ID = sel:.sign = "Stick"
                    case 4
                        .ID = sel:.sign = "Gun"
                    case 5
                        .ID = sel:.sign = "Paper"
                    case 6
                        .ID = sel:.sign = "Rope"
                    case 7
                        .ID = sel:.sign = "Bag"
                    case 8
                        .ID = sel:.sign = "Candy"
                    case 9
                        .ID = sel:.sign = "Wrench"
                    case 10
                        .ID = sel:.sign = "Hammer"
                    end select
                    .Used = 1
                    continue for
                end with
            end if
        loop
    next i
end sub

'Add item to the SELected slot, and the TYpe of item to be added
'-1 = Random item
' 0 = Remove item (Not the proper way to remove shit)
sub addItem(sel as integer, ty as integer)
    with obj(sel)
        if ty = -1 then
            do
                ty = 11*rnd
            loop until ty <> 0 and ty <> 11
        end if
        
        select case ty
        case 0
            .Used = 0
            .ID = ty:.sign = ""
        case 1
            .ID = ty:.sign = "Keys"
        case 2
            .ID = ty:.sign = "Rock"
        case 3
            .ID = ty:.sign = "Stick"
        case 4
            .ID = ty:.sign = "Gun"
        case 5
            .ID = ty:.sign = "Paper"
        case 6
            .ID = ty:.sign = "Rope"
        case 7
            .ID = ty:.sign = "Bag"
        case 8
            .ID = ty:.sign = "Candy"
        case 9
            .ID = ty:.sign = "Wrench"
        case 10
            .ID = ty:.sign = "Hammer"
        end select
        .Used = 1
    end with
end sub

'Remove the SELected item. (Proper way to do it)
sub removeItem(sel as integer)
    with obj(sel)
        .Used = 0
        .ID = 0
        .sign = ""
    end with
end sub

'Initiate the random items
init(-1)

selectedtime = timer
do
    screenlock
    cls
    for i as integer = 0 to MaxObj
        with obj(i)
            
            'Is the current slot being rendered marked empty? Yes. So is the next spot empty too?
            if .used = 0 then
                var j = i+1
                if obj(j).used = 1 then 'No, the next spot is not empty, so lets copy that spot to the currently being rendered spot.
                    addItem(i,obj(j).ID) 'Next spot being copied to the current spot
                    removeItem(j) 'Next spot has been obliterated
                end if
            end if
            
            'Lets render our loot now
            if i < 10 then
                if selected = i then
                    print "> (" & i & "): " & .sign," - " & .ID
                    print
                else
                    print "  (" & i & "): " & .sign," - " & .ID
                    print
                end if
            else
                if selected = i then
                    print ">(" & i & "): " & .sign," - " & .ID
                    print
                else
                    print " (" & i & "): " & .sign," - " & .ID
                    print
                end if
            end if
        end with
    next i
    
    'Prevent our users from spamming the add/remove item buttons. They must wait 150ms before adding/removing another item, or moving selector.
    if (timer-selectedtime) > .15 then
        selectedtime = timer
        
        if multikey(sc_up) then if selected > 0 then selected-=1
        if multikey(sc_down) then if selected < MaxObj then selected+=1
        
        with obj(selected)
            if .used = 1 then if multikey(sc_space) then removeItem(Selected)
            if .used = 0 then if multikey(sc_enter) then addItem(Selected,-1)
        end with
    end if
    screenunlock
    
    sleep 10
loop until multikey(sc_escape)