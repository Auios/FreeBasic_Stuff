#include once "gl2d.bi"

using GL2D

type Particle
    as single x,y,r
    as boolean highlight
    as uinteger clr
    
    declare constructor()
    declare sub setPosition(x as single, y as single)
    declare sub setColor(clr as uinteger)
    declare sub setHighlight(highlight as boolean)
    declare sub move()
    declare sub render()
    declare function getDistance(other as Particle) as single
    declare function intersects(other as Particle) as boolean
end type

constructor Particle()
    this.r = 8
    this.highlight = false
end constructor

sub Particle.setPosition(x as single, y as single)
    this.x = x
    this.y = y
end sub

sub Particle.setColor(clr as uinteger)
    this.clr = clr
end sub

sub Particle.setHighlight(highlight as boolean)
    this.highlight = highlight
end sub

sub Particle.move()
    this.x+=2*rnd()-1
    this.y+=2*rnd()-1
end sub

sub Particle.render()
    if(this.highlight) then
        this.setHighlight(false)
        this.setColor(GL2D_RGB(200,200,200))
    else
        this.setColor(GL2D_RGB(100,100,100))
    end if
    
    circleFilled(this.x, this.y, this.r, this.clr)
end sub

function Particle.getDistance(other as Particle) as single
    dim as single dx = other.x-this.x
    dim as single dy = other.y-this.y
    return sqr(abs((dx*dx)+(dy*dy)))
end function

function Particle.intersects(other as Particle) as boolean
    return (this.getDistance(other) < this.r + other.r)
end function

