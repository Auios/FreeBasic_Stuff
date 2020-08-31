#include "fbgfx.bi"

#define fbc -s gui

using fb

function rand overload() as single
    return rnd()
end function

function rand overload(max as uinteger) as uinteger
    return int(max*rnd())
end function

sub clear_screen(w as integer, h as integer)
    line(0,0)-(w, h), rgb(255, 0, 255),bf
end sub

type planet
    as integer x, y
    as uinteger clr
    as single radius
end type

function make_pixels(count as integer, w as integer, h as integer) as planet ptr
    dim as planet ptr dp = new planet[count]
    for i as integer = 0 to count-1
        dp[i].x = w*rnd()
        dp[i].y = h*rnd()
        dp[i].radius = 16*rnd()
        dp[i].clr = rgb(255*rnd(), 255*rnd(), 255*rnd())
    next i
    return dp
end function

sub move_pixel(dp as planet ptr)
    dim as integer direction = rand(4)
    if direction = 0 then dp->y-=1
    if direction = 1 then dp->y+=1
    if direction = 2 then dp->x-=1
    if direction = 3 then dp->x+=1
end sub

sub draw_pixel(dp as planet ptr)
    pset(dp->x, dp->y), dp->clr
    circle(dp->x, dp->y), dp->radius, dp->clr, ,,,f
end sub


dim as integer screen_width, screen_height
screenInfo(screen_width, screen_height)

dim as integer dp_count = 512
dim as planet ptr dp = make_pixels(dp_count, screen_width, screen_height)
dim as boolean run_app = true

screenRes(screen_width, screen_height, 32, 1, GFX_SHAPED_WINDOW)

while(run_app)
    if(multikey(sc_escape)) then run_app = false
    
    screenLock()
    clear_screen(screen_width, screen_height)
    for i as integer = 0 to dp_count-1
        move_pixel(@dp[i])
        draw_pixel(@dp[i])
    next i
    screenUnlock()
    
    sleep(10, 1)
wend
