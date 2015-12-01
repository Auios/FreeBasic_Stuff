#include once "fbgfx.bi"
using fb
randomize timer

dim shared as integer gravityexist = 0

dim shared as integer scrnx,scrny
screeninfo scrnx,scrny
screenres scrnx,scrny,8,1,1


sub north(byval x as integer,byref y as integer)
    dim as integer col = point(x,y-1)
    
    if y-1 > 0 and col = 0 then
        if gravityexist = 1 then y-=2
        if gravityexist = 0 then y-=1
    end if
end sub

sub south(byval x as integer, byref y as integer, byval max as integer)
    dim as integer col = point(x,y+1)
    
    if y+1 > 0 and col = 0 and y+1 < max then
        y+=1
    end if
end sub

sub west(byref x as integer,byval y as integer)
    dim as integer col = point(x-1,y)
    
    if x-1 > 0 and col = 0 then
        x-=1
    end if
end sub

sub east(byref x as integer, byval y as integer, byval max as integer)
    dim as integer col = point(x+1,y)
    
    if x+1 > 0 and col = 0 and  x+1 < max then
        x+=1
    end if
end sub


sub subup(byval x as integer,byval y as integer,byref carry as integer,byref carrycol as integer)
    dim as integer col
    y-=1
    
    col=point(x,y)
    While multikey(sc_up) = -1: Wend
    
    select case carry
    case 0
        if col > 0 then
            carry=1
            carrycol=col
            pset(x,y),0
        end if
        exit select
    case 1
        if col = 0 then
            carry=0
            pset(x,y),carrycol
        end if
        exit select
    end select
end sub

sub subdown(byval x as integer,byval y as integer,byref carry as integer,byref carrycol as integer)
    dim as integer col
    y+=1
    
    col=point(x,y)
    While multikey(sc_down) = -1: Wend
    
    select case carry
    case 0
        if col > 0 then
            carry=1
            carrycol=col
            pset(x,y),0
        end if
        exit select
    case 1
        if col = 0 then
            carry=0
            pset(x,y),carrycol
        end if
        exit select
    end select

end sub

sub subleft(byval x as integer,byval y as integer,byref carry as integer,byref carrycol as integer)
    dim as integer col
    x-=1
    
    col=point(x,y)
    While multikey(sc_left) = -1: Wend
    
    select case carry
    case 0
        if col > 0 then
            carry=1
            carrycol=col
            pset(x,y),0
        end if
        exit select
    case 1
        if col = 0 then
            carry=0
            pset(x,y),carrycol
        end if
        exit select
    end select

end sub

sub subright(byval x as integer,byval y as integer,byref carry as integer,byref carrycol as integer)
    dim as integer col
    x+=1
    
    col=point(x,y)
    While multikey(sc_right) = -1: Wend
    
    select case carry
    case 0
        if col > 0 then
            carry=1
            carrycol=col
            pset(x,y),0
        end if
        exit select
    case 1
        if col = 0 then
            carry=0
            pset(x,y),carrycol
        end if
        exit select
    end select

end sub


sub createmap(byval max as integer)
    dim as integer char,col,x,y,numchars
    
    do
        char = 1000*rnd
        x=scrnx*rnd
        y=scrny*rnd
        col = 50*rnd
        
        draw string(x,y),chr(char),col
        
        numchars+=1
    loop until numchars=max
end sub

sub gravity(byval x as integer,byref y as integer)
    dim as integer col = point(x,y+1)
    
    if col = 0 then
        y+=1
    end if
end sub


sub projup(byval x as integer,byval y as integer)
    While multikey(sc_i) = -1: Wend
    
    y-=1
    dim as integer yy,col = point(x,y)
    
    do
        yy=y
        y-=1
        
        screenlock
            pset(x,y),80
            pset(x,yy),0
        screenunlock
        
        sleep 25
    loop while y > 0 and col = 0
    pset(x,y),0
end sub

sub projdown(byval x as integer,byval y as integer,byval scrny as integer)
    While multikey(sc_k) = -1: Wend
    
    y+=1
    dim as integer yy,col = point(x,y)
    
    do
        yy=y
        y+=1
        
        screenlock
            pset(x,y),80
            pset(x,yy),0
        screenunlock
        
        sleep 25
    loop while y < scrny and col = 0
    pset(x,y),0
end sub

sub projleft(byval x as integer,byval y as integer)
    While multikey(sc_j) = -1: Wend
    
    x-=1
    dim as integer xx,col = point(x,y)
    
    do
        xx=x
        x-=1
        
        screenlock
            pset(x,y),80
            pset(xx,y),0
        screenunlock
        
        sleep 25
    loop while y > 0 and col = 0
    pset(x,y),0
end sub

sub projright(byval x as integer,byval y as integer,byval scrnx as integer)
    While multikey(sc_l) = -1: Wend
    
    x+=1
    dim as integer xx,col = point(x,y)
    
    do
        
        xx=x
        x+=1
        
        screenlock
            pset(x,y),80
            pset(xx,y),0
        screenunlock
        
        sleep 25
    loop while y < scrnx and col = 0
    pset(x,y),0
end sub

dim as integer max = 5
dim as integer x(max),y(max)
dim as integer col,carry,carrycol

dim as integer pointresult,mouseresult,clip

dim as integer temp(max)

col = 32
temp(0)=0

screenlock
createmap(1000)
screenunlock


do
    mouseresult=getmouse(x(5),y(5),clip)
    
    if multikey(sc_up) then subup(x(0),y(0),carry,carrycol)
    if multikey(sc_down) then subdown(x(0),y(0),carry,carrycol)
    if multikey(sc_right) then subright(x(0),y(0),carry,carrycol)
    if multikey(sc_left) then subleft(x(0),y(0),carry,carrycol)
    
    if multikey(sc_i) then projup(x(0),y(0))
    if multikey(sc_k) then projdown(x(0),y(0),scrny)
    if multikey(sc_j) then projleft(x(0),y(0))
    if multikey(sc_l) then projright(x(0),y(0),scrnx)
    
    x(1)=x(0)
    y(1)=y(0)
    
    screenlock
        if multikey(sc_w) then north(x(0),y(0))
        if multikey(sc_d) then east(x(0),y(0),scrnx)
        if multikey(sc_s) then south(x(0),y(0),scrny)
        if multikey(sc_a) then west(x(0),y(0))
        
        pset(x(1),y(1)),0
        
        if multikey(sc_space) then
            pset(x(0),y(0)),0
            
            x(0)=x(5)
            y(0)=y(5)
        end if
        
        if gravityexist = 1 then gravity(x(0),y(0))
        pset(x(0),y(0)),rgb(255,255,255)
        
        line(0,0)-(100,35),32,"bf"
        draw string(5,5),"Carry: " & carry
        draw string(5,15),"X: " & x(0)
        draw string(5,25),"Y: " & y(0)
    screenunlock
    
    sleep 75,1
loop until multikey(sc_escape)

screen 0

end 0