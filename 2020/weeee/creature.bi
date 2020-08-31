#pragma once

type Creature
    as integer x, y
    as any ptr sprite
    as any ptr leftSprite
    as any ptr rightSprite
    
    declare sub init(leftSprite as any ptr, rightSprite as any ptr, maxX as integer, maxY as integer)
    declare sub setPos(x as integer, y as integer)
    declare sub move(x as integer, y as integer)
    declare sub update()
    declare sub render()
end type

sub Creature.init(leftSprite as any ptr, rightSprite as any ptr, maxX as integer, maxY as integer)
    this.leftSprite = leftSprite
    this.rightSprite = rightSprite
    this.sprite = rightSprite
    this.x = maxX*rnd()
    this.y = maxY*rnd()
end sub

sub Creature.setPos(x as integer, y as integer)
    this.x = x
    this.y = y
end sub

sub Creature.move(x as integer, y as integer)
    this.x+=x
    this.y+=y
end sub

sub Creature.update()
    dim as integer r = int(4*rnd())
    select case(r)
    case 0 ' Up
        this.move(0, -1)
    case 1 ' Right
        this.move(1, 0)
        this.sprite = this.rightSprite
    case 2 ' Down
        this.move(0, 1)
    case 3 ' Left
        this.move(-1, 0)
        this.sprite = this.leftSprite
    end select
end sub

sub Creature.render()
    put(this.x, this.y), this.sprite, trans
end sub
