#include "fbgfx.bi"

using fb

type planet
    as single mass
    as single x, y
    as single vx, vy
    as uinteger clr
end type

function planet_create() as planet
    dim as single max_vel = 500
    dim as single max_mass = 5
    dim as single min_mass = 2
    dim as planet p
    p.mass = max_mass*rnd() + min_mass
    p.x = 800*rnd()
    p.y = 600*rnd()
    p.vx = max_vel*rnd()-max_vel/2
    p.vy = max_vel*rnd()-max_vel/2
    p.clr = rgb(255*rnd, 255*rnd, 255*rnd)
    return p
end function

sub planet_update(p as planet ptr, dt as single)
    dim as single push_force = 50
    if(p->x < 0+50) then p->vx+=push_force*dt
    if(p->y < 0+50) then p->vy+=push_force*dt
    if(p->x > 800-50) then p->vx-=push_force*dt
    if(p->y > 600-50) then p->vy-=push_force*dt
    p->x+=p->vx*dt
    p->y+=p->vy*dt
end sub

sub planet_render(p as planet ptr)
    circle(p->x, p->y), p->mass, p->clr,,,, f
    line(p->x, p->y)-(p->x+p->vx, p->y+p->vy)
end sub

dim as event e
dim as boolean run_app = true

screenRes(800, 600, 32, 1, 0)

dim as ushort planet_count = 100
dim as planet ptr planets = new planet[planet_count]
for i as integer = 0 to planet_count-1
    planets[i] = planet_create()
next i

dim as single last_time = timer()
dim as single curr_time
dim as single dt

while(run_app)
    curr_time = timer()
    dt = curr_time - last_time
    if(screenEvent(@e)) then
        select case e.type
        case EVENT_KEY_RELEASE
            if(e.scancode = SC_ESCAPE) then run_app = false
        end select
    end if
    
    for i as integer = 0 to planet_count-1
        planet_update(@planets[i], dt)
    next i
    
    screenLock()
    cls()
    line(50,50)-(800-50, 600-50),, b
    for i as integer = 0 to planet_count-1
        planet_render(@planets[i])
    next i
    screenUnlock()
    
    sleep(1,1)
    last_time = curr_time
wend
