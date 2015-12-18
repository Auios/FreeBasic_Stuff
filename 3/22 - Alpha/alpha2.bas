#include "fbgfx.bi"
using fb
'include "scrn.bas"
type scrProp
    as ushort x,y
    as ushort depth
    as ushort page
    as ushort flag
end type
dim shared as scrProp sc

sub scrn(byref w as ushort,byref h as ushort,byref depth as ushort,byref flag as ushort)
    with sc
        .x = w
        .y = h
        .depth = depth
        .flag = flag
        screenres .x,.y,.depth,1,.flag or GFX_ALPHA_PRIMITIVES
    end with
end sub

randomize timer

scrn(800,600,32,0)

dim as any ptr blur1

blur1 = imagecreate(65,65,rgba(0,0,0,0))

for i as single = 1 to 31 step 1
    circle blur1,(64/2,64/2),i,rgba(255,255,255,10),,,,f
    put(1,1),blur1,alpha    
next i
get(1,1)-(65,65),blur1

put(sc.x/2,sc.y/2),blur1

sleep

imageDestroy blur1

end
