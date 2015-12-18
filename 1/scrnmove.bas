#include "fbgfx.bi"
'include "color16.bi"
using fb

declare sub menu

type screenprop
    as integer x,y
    as integer centerx,centery
    as integer colorbit = 16
    as integer pages = 2
    as integer full = 1
    as double posx,posy
    as double speed
end type
dim shared as screenprop scr

screeninfo scr.x,scr.y
screenres scr.x,scr.y,scr.colorbit,scr.pages,scr.full

scr.centerx = scr.x/2
scr.centery = scr.y/2

type mouseprop
    as integer result
    as double x
    as double y
    as integer show
end type
dim shared as mouseprop mo

mo.show = 0
mo.result = setmouse(,,mo.show)

type playerprop
    as double x
    as double y
    as double size
    as uinteger clr
    as double renx,reny
    as double speed
    as double xx
    as double yy
    as string nme
end type
dim shared as playerprop pl
pl.x = int(scr.x/2)
pl.y = int(scr.y/2)

dim shared as double zz
sub controls
    if multikey(sc_lshift) then
        zz = pl.speed/1.5
    else
        zz = 0
    end if
    
    if multikey(sc_w) then
        pl.y-=pl.speed-zz
        scr.posy-=scr.speed-zz
    end if
    if multikey(sc_s) then
        pl.y+=pl.speed-zz
        scr.posy+=scr.speed-zz
    end if
    if multikey(sc_d) then
        pl.x+=pl.speed-zz
        scr.posx+=scr.speed-zz
    end if
    if multikey(sc_a) then
        pl.x-=pl.speed-zz
        scr.posx-=scr.speed
    end if
    
    if multikey(sc_q) then menu
end sub

type objectprop
    as double x,y
    as double size
    as uinteger clr
    as integer id
    as string nme
end type

dim shared as integer max = 500,id

dim shared as objectprop obj(0 to max)
sub intgenerate
    for id = 0 to max
        obj(id).x = ((4*scr.x)*rnd)-(2*scr.x)
        obj(id).y = ((4*scr.y)*rnd)-(2*scr.y)
        obj(id).size = (25*rnd)+5
        obj(id).clr = rgb(255*rnd,255*rnd,255*rnd)
        obj(id).id = id
        obj(id).nme = ""&id
    next
end sub
intgenerate

dim shared as string inff
dim shared as integer infflen
sub renderworld
    for id = 0 to max
        circle(obj(id).x-scr.posx,obj(id).y-scr.posy),obj(id).size,obj(id).clr
        draw string((obj(id).x-scr.posx)+obj(id).size+5,(obj(id).y-scr.posy)-obj(id).size-5),obj(id).nme,clr.white
    next
    
    pl.xx = pl.x-scr.posx
    pl.yy = pl.y-scr.posy
    
    line(-2*scr.x-scr.posx,-2*scr.y-scr.posy)-(2*scr.x-scr.posx,2*scr.y-scr.posy),clr.white,"b"
    
    circle(int(pl.xx),int(pl.yy)),int(pl.size),pl.clr
    line(int(pl.xx-pl.size),int(pl.yy))-(int(pl.xx+pl.size),int(pl.yy)),pl.clr
    line(int(pl.xx),int(pl.yy-pl.size))-(int(pl.xx),int(pl.yy+pl.size)),pl.clr
    draw string(int(pl.xx+pl.size+5),int(pl.yy-pl.size-5)),pl.nme,clr.white
    
    inff = "x: " & int(pl.x) & "," & int(pl.y)
    infflen = len(inff)
    
    line(0,0)-(infflen*8.7,15),clr.blue,"bf"
    draw string(5,5),inff,clr.white
end sub

dim shared as integer delay = 5
scr.speed = 1
pl.speed = 1
pl.clr = clr.green
pl.size = 10
pl.nme = "Auios"

do
    Controls
    
    screenlock
        cls
        renderworld
    screenunlock
    
    sleep delay
    
loop until multikey(sc_escape)

dim shared as integer r,g,b
dim shared as string nme
dim shared as string ans
sub menu
    cls
    
    Do Until Inkey = "":Loop
    
    print "(1) Move Object"
    print "(2) Find Object"
    print "(3) Name Object"
    print "(4) Color Object"
    print "(0) Simulation"
    input ans
    print
    
    select case ans
    case "0"
        exit select
        
    case "1"
        print "Name:"
        input nme
        for id = 0 to max
            if obj(id).nme = nme then exit for
        next
        print
        
        print "X:"
        input obj(id).x
        print
        
        print "Y:"
        input obj(id).y
        
        menu
        
    case "2"
        print "Name:"
        input nme
        for id = 0 to max
            if obj(id).nme = nme then exit for
        next
        
        pl.x = obj(id).x
        pl.y = obj(id).y
        
        menu
        
    case "3"
        print "Name:"
        input nme
        for id = 0 to max
            if obj(id).nme = nme then exit for
        next
        print
        
        print "New Name:"
        input obj(id).nme
        
        menu
        
    case "4"
        print "Name:"
        for id = 0 to max
            if obj(id).nme = nme then exit for
        next
        print
        
        print "Red:"
        input r
        print
        
        print "Green:"
        input g
        print
        
        print "Blue:"
        input b
        print
        
        obj(id).clr = rgb(r,g,b)
        
        menu
    end select
end sub