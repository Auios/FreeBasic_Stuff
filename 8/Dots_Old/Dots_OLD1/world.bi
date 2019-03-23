#pragma once

#include "region.bi"

type World
    as integer size
    as integer regionSize
    as Region ptr regions
    
    declare sub create()
end type
