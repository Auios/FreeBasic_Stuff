#pragma once

type Box
    as integer x,y
    as integer w, h
    
    declare constructor()
    declare constructor(x as integer, y as integer, w as integer, h as integer)
end type

constructor Box()
end constructor

constructor Box(x as integer, y as integer, w as integer, h as integer)
    this.x = x
    this.y = y
    this.w = w
    this.h = h
end constructor

function isColliding(a as Box, b as Box) as boolean
    return false
end function
