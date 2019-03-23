#pragma once

type Pnt
    as single x,y
    
    declare constructor()
    declare constructor(x as single, y as single)
    declare constructor(p as Pnt)
    declare sub set(x as single, y as single)
    declare sub set(p as Pnt)
    declare sub offset(distance as single)
    declare sub offset(p as Pnt, distance as single)
end type

constructor Pnt()
end constructor

constructor Pnt(x as single, y as single)
    this.x = x
    this.y = y
end constructor

constructor Pnt(p as Pnt)
    this.x = p.x
    this.y = p.y
end constructor

sub Pnt.set(x as single, y as single)
    this.x = x
    this.y = y
end sub

sub Pnt.set(p as Pnt)
    this.x = p.x
    this.y = p.y
end sub

sub Pnt.offset(distance as single)
    this.x+=distance
    this.y+=distance
end sub

sub Pnt.offset(p as Pnt, distance as single)
    this.x = p.x + distance
    this.y = p.y + distance
end sub

