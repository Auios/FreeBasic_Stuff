#pragma once

#include "entity.bi"

type Dot extends entity
    declare function setPosition(x as single, y as single) as boolean
end type

function Dot.setPosition(x as single, y as single) as boolean
    this.position.set(x, y)
    return true
end function
