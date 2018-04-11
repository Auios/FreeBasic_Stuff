#include once "fbgfx.bi"
#include once "gl2d.bi"
#include once "crt.bi"

#include once "fpscounter.bas"
#include once "particle.bas"

using FB, GL2D

randomize(timer())

dim as boolean runApp = true
dim as string k
redim as GL2D.image ptr spr()
dim as event e
dim shared as integer scrnx,scrny
scrnx = 1400
scrny = 900

ScreenInit(scrnx, scrny)
VsyncON()

dim as integer maxParticles = 1000

dim as Particle ptr particles = new Particle[maxParticles]
for i as integer = 0 to maxParticles-1
    particles[i].setPosition(scrnx*rnd(), scrny*rnd())
next i

dim as FPSCounter FPSCnt

while(runApp)
    FPSCnt.start()
    
    if(screenEvent(@e)) then
        select case e.type
        case EVENT_KEY_PRESS
            if(e.scanCode = SC_ESCAPE) then runApp = false
        end select
    end if
    
    for i as integer = 0 to maxParticles-1
        particles[i].move()
    next i
    
    for i as integer = 0 to maxParticles-1
        for j as integer = 0 to maxParticles-1
            if i = j then continue for
            if(particles[i].intersects(particles[j])) then
                particles[i].setHighlight(true)
                exit for
            end if
        next j
    next i
    
    clearScreen()
    begin2D()
        for i as integer = 0 to maxParticles-1
            particles[i].render()
        next i
        
        'Print FPS
        PrintScale(5,5,1,str(FPSCnt.getFPS()))
    end2D()
    
    'limitFPS(60)
    sleep(1,1)
    flip()
    
    FPSCnt.check()
wend

delete[] particles

sleep()