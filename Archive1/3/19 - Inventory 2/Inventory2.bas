'Includes
#include "string.bi"
#include "scrn.bas"
#include "fbgfx.bi"
using fb
randomize timer

print "Up   - AddSlot"
print "Down - SubSlot"
print
print "W - Move Up"
print "S - Move Down"
print "D - Increase Value"
print "A - Decrease Value"

'Make the screen
scrn(800,600,16,0)

'Types
type slotProp
    as ushort Used
    as ushort ID
    as integer value
end type
dim shared as ushort MaxSlot = 10
dim shared as ushort MinSlot = 1
redim shared as slotProp slot(MinSlot to MaxSlot)

'Variables
dim shared as uinteger selected
selected = MinSlot
dim shared as string display
Dim shared as EVENT e
dim as double starttime,endtime,st,sst

function GiveID as uinteger
    static GlobID as uinteger
    GlobID+=1
    return GlobID
end function

Sub Init()
    for i as uinteger = MinSlot to MaxSlot
        with slot(i)
            .Used = 1
            .ID = GiveID()
            .Value = 15*rnd
        end with
    next i
end sub

sub Render()
    cls
    'Loop through our array
    for i as uinteger = lbound(slot) to ubound(slot)
        with slot(i)
            if .used then
                if selected = i then
                    display = ">: " & i & ", " & .ID & " - " & .value
                else
                    display = " : " & i & ", " & .ID & " - " & .value
                end if
            else
                if selected = i then
                    display = ">: (DELETED)"
                else
                    display = " : (DELETED)"
                end if
                
                if i = MaxSlot then
                    MaxSlot-=1
                    redim preserve slot(MinSlot to MaxSlot)
                    if selected > MaxSlot then selected = MaxSlot
                else
                    if slot(i+1).used = 1 then
                        .used = 1
                        .ID = slot(i+1).ID
                        .value = slot(i+1).value
                        
                        slot(i+1).used = 0
                    end if
                end if
            end if
        
            draw string(8*1-8,8*i-8),display
        end with
    next i
end sub

sub AddValue(selected as uinteger)
    with slot(selected)
        .value+=1
    end with
end sub

sub SubValue(selected as uinteger)
    with slot(selected)
        .value-=1
    end with
end sub

sub AddSlot()
    MaxSlot+=1
    redim preserve slot(MinSlot to MaxSlot)
    with slot(MaxSlot)
        .used = 1
        .value = 15*rnd
        .ID = GiveID
    end with
end sub

sub SubSlot()
    if MaxSlot > MinSlot then
        if selected = MaxSlot then selected-=1
        MaxSlot-=1
        redim preserve slot(MinSlot to MaxSlot)
    end if
end sub

sub DelSlot(selected as uinteger)
    with slot(selected)
        .Used = 0
    end with
end sub

sub Controls()
    'New way to handle input
    If (ScreenEvent(@e)) Then
        Select Case e.type
        'On key press
        Case EVENT_KEY_PRESS
            if multikey(sc_escape) then end
            if multikey(sc_up) then AddSlot()
            if multikey(sc_down) then SubSlot()
            
            if multikey(sc_d) then AddValue(selected)
            if multikey(sc_a) then SubValue(selected)
            
            if multikey(sc_w) then if selected > MinSlot then selected-=1
            if multikey(sc_s) then if selected < MaxSlot then selected+=1
            
            if multikey(sc_backspace) then DelSlot(selected)
        end Select
    End If
    
    'Spam increase (debug)
    if multikey(sc_r) then AddSlot()
end sub

Init()

'Main loop
do
    screenlock
    'Render stuff on the screen
    Render()
    
    'Keyboard/Mouse
    Controls()
    
    'Debug stuff ~ Application speed statistics.
    endtime = timer
    
    st = ((endtime - starttime)*1000)-1
    starttime = timer
    line(0,sc.y/2)-(sc.x,sc.y/2)
    line(0,sc.y/2-st)-(sc.x,sc.y/2-st),rgb(255,0,0)
    draw string(8*50-8,8*7-8),"Time(ms): " & format(abs(st),"00.####")
    
    screenunlock
    
    'I will use sleep 1,1 from now on because I learned a new way to control
    'the speed of my applications using 'Timer'
    sleep 1,1
    
loop until multikey(sc_escape)'Exit on 'Escape' press
