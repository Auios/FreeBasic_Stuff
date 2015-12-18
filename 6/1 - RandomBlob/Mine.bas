randomize()

screenres(800,600,16,1,0)

dim as any ptr buffer = screenPtr()
dim as integer w,h,bpp,pitch

dim as uinteger redDot = rgb(192,96,96)
dim as uinteger greenDot = rgb(96,192,96)
dim as uinteger blueDot = rgb(96,96,192)
dim as uinteger bgClr = rgb(192,192,192)
dim as uinteger testClr
dim as integer c

pset(0,0),redDot: redDot = point(0,0)
pset(0,0),greenDot: greenDot = point(0,0)
pset(0,0),blueDot: blueDot = point(0,0)

screeninfo(w,h,,bpp,pitch)

line(0,0)-(799,599),bgClr,bf

for i as integer = 1 to 50
    c = int(3*rnd+1)
    
    if(c=1)then pset(800*rnd,600*rnd),redDot
    if(c=2)then pset(800*rnd,600*rnd),greenDot
    if(c=3)then pset(800*rnd,600*rnd),blueDot
next i

do
    for y as integer = 0 to 599
        for x as integer = 0 to 799
            c = int(4*rnd+1)
            
            testClr = point(x,y)
            
            if(testClr = redDot) then
                if(c=1)then pset(x,y-1),redDot
                if(c=2)then pset(x+1,y),redDot
                if(c=3)then pset(x,y+1),redDot  
                if(c=4)then pset(x-1,y),redDot
                continue for
            end if
            
            if(testClr = greenDot) then
                if(c=1)then pset(x,y-1),greenDot
                if(c=2)then pset(x+1,y),greenDot
                if(c=3)then pset(x,y+1),greenDot
                if(c=4)then pset(x-1,y),greenDot
                continue for
            end if
            
            if(testClr = blueDot) then
                if(c=1)then pset(x,y-1),blueDot
                if(c=2)then pset(x+1,y),blueDot
                if(c=3)then pset(x,y+1),blueDot
                if(c=4)then pset(x-1,y),blueDot
                continue for
            end if
        next x
    next y
loop until inkey = chr(27)

end 0