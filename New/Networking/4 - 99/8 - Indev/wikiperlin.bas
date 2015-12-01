#include "scrn.bas"

scrn()

dim shared as single Gradient(sc.x,sc.y,1)

sub fillGrad()
    for x as integer = lbound(gradient,1) to ubound(gradient,1)
        for y as integer = lbound(gradient,2) to ubound(gradient,2)
            for z as integer = lbound(gradient,3) to ubound(gradient,3)
                gradient(x,y,z) = 1*rnd
            next z
        next y
    next x
end sub

fillGrad()

function lerp(a0 as single, a1 as single, w as single) as single
    return (1-w)*a0+w*a1
end function

function dotGridGradient(ix as integer, iy as integer, x as single, y as single) as single
    
    dim as single dx = x-ix
    dim as single dy = y-iy
    
    return (dx*Gradient(iy,ix,0) + dy*Gradient(iy,ix,1))
end function

function perlin(x as single, y as single) as single
    dim as integer x0 = iif(x>0.0,cint(fix(x)),cint(fix(x))-1)
    dim as integer x1 = x0+1
    dim as integer y0 = iif(y>0.0,cint(fix(y)),cint(fix(y))-1)
    dim as integer y1 = y0+1
    
    dim as single sx = x-cdbl(x0)
    dim as single sy = y-cdbl(y0)
    
    dim as single n0,n1,ix0,ix1,value
    n0 = dotGridGradient(x0,y0,x,y)
    n1 = dotGridGradient(x1,y0,x,y)
    ix0 = lerp(n0,n1,sx)
    n0 = dotGridGradient(x0,y1,x,y)
    n1 = dotGridGradient(x1,y1,x,y)
    ix1 = lerp(n0,n1,sx)
    value = lerp(ix0,ix1,sy)
    
    return value
end function

for y as integer = 1 to sc.y-1
    for x as integer = 1 to sc.x-1
        dim as single clr = 255*perlin(x,y)
        pset(x,y),rgb(clr,clr,clr)
    next x
next y

sleep