screenres(800,600,32,1,0)

sub drawCircle(x as integer, y as integer, r as integer, c as uinteger)
    dim as integer xx = r - 1, yy, dx = 1, dy = 1
    dim as integer e = dx - (r shl 1)
    
    while(xx >= yy)
        pset(x + xx, y + yy), c
        pset(x + yy, y + xx), c
        pset(x - yy, y + xx), c
        pset(x - xx, y + yy), c
        pset(x - xx, y - yy), c
        pset(x - yy, y - xx), c
        pset(x + yy, y - xx), c
        pset(x + xx, y - yy), c
        
        if(e <= 0) then
            yy += 1
            e += dy
            dy += 2
        end if
        
        if(e > 0) then
            xx -= 1
            dx += 2
            e += dx - (r shl 1)
        end if
    wend
end sub

circle(50,50),100,rgb(200,100,100)
'circle(125,50),25,rgb(100,200,100)
drawCircle(325, 50, 100, rgb(100, 200, 100))

sleep()