#include "fbgfx.bi"
using fb
randomize timer

dim shared as integer scrnx,scrny
screeninfo scrnx,scrny
screenres scrnx,scrny,16,2,1

dim shared as integer delay=15

type screendata
    as integer north    = 0
    as integer south    = scrny
    as integer east     = 0
    as integer west     = scrnx
end type
dim shared scr as screendata

type colors
    as uinteger white   = rgb(255,255,255)
    as uinteger black   = rgb(0,0,0)
    as uinteger red     = rgb(255,0,0)
    as uinteger green   = rgb(0,255,0)
    as uinteger blue    = rgb(0,0,255)
    as uinteger orange  = rgb(255,150,0)
    as uinteger purple  = rgb(255,0,255)
    as uinteger brown   = rgb(139,69,19)
end type
dim shared col as colors
