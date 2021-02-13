#include "fbgfx.bi"
#include "crt.bi"

using fb

type Vector2
    as integer x, y
    declare sub setRandom(maxX as integer, maxY as integer)
    declare sub dump()
end type

sub Vector2.setRandom(maxX as integer, maxY as integer)
    this.x = maxX * rnd()
    this.y = maxY * rnd()
end sub

sub Vector2.dump()
    printf(!"%i, %i\n", this.x, this.y)
end sub

type VoroPoint
    position as Vector2
    clr as ulong
    
    declare sub Init()
end type

sub VoroPoint.Init()
    this.position.setRandom(800, 600)
    this.clr = rgb(255*rnd(), 255*rnd(), 255*rnd())
end sub

function getDistance(a as Vector2, b as Vector2) as single
    return sqr((b.y - a.y) ^ 2 + (b.x - a.x) ^ 2)
end function

function getClosestPointToMouse(points as VoroPoint ptr, pointsCount as integer) as integer
    dim as integer current = -1
    
    dim as Vector2 mPos
    dim as integer clip
    getMouse(mPos.x, mPos.y,,,clip)
    
    if(clip = 0) then
        'mPos.dump()
        dim as single closestDistance = &h7FFFFFFF
        for i as integer = 0 to pointsCount - 1
            dim as single distance = getDistance(mPos, points[i].position)
            if(closestDistance > distance) then
                closestDistance = distance
                current = i
            end if
        next i
    end if
    return current
end function

sub renderVoroPoints(points as VoroPoint ptr, count as integer, renderSize as single)
    for i as integer = 0 to count - 1
        circle(points[i].position.x, points[i].position.y), renderSize, points[i].clr,,,,f
        circle(points[i].position.x, points[i].position.y), renderSize, rgb(200, 200, 200)
        'draw string(points[i].x, points[i].y), str(i)
    next i
end sub

function main() as integer
    randomize(timer())
    
    dim as integer pointsCount = 100
    dim as VoroPoint ptr points = new VoroPoint[pointsCount]
    dim as integer closestPoint
    
    for i as integer = 0 to pointsCount - 1
        points[i].Init()
    next i
    
    screenRes(800, 600, 32, 1, 0)
    
    closestPoint = getClosestPointToMouse(points, pointsCount)
    
    for yy as integer = 0 to 600 - 1
        for xx as integer = 0 to 800 - 1
            dim as single closestPoint
            dim as single closestDistance = &h7FFFFFFF
            for i as integer = 0 to pointsCount - 1
                dim as Vector2 ourPosition
                ourPosition.x = xx
                ourPosition.y = yy
                dim as single distance = getDistance(ourPosition, points[i].position)
                if(closestDistance > distance) then
                    closestDistance = distance
                    closestPoint = i
                end if
            next i
            pset(xx, yy), points[closestPoint].clr
        next xx
    next yy
    
    renderVoroPoints(points, pointsCount, 3)
    if(closestPoint >= 0) then
        'printf(!"%i\n", closestPoint)
        circle(points[closestPoint].position.x, points[closestPoint].position.y), 3, rgb(200, 200, 200)
    end if
    
    sleep()
    
    delete[] points

    return 0
end function

end(main())
