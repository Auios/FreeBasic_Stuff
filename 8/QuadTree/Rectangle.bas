#pragma once


#include "Vector2.bas"

type Rectangle
    as Vector2 position
    as Vector2 scale
    
    declare constructor()
    declare constructor(position as Vector2)
    declare constructor(position as Vector2, scale as Vector2)
    
    declare sub SetPosition(x as single, y as single)
    declare sub SetPosition(value as Vector2)
    declare sub SetScale(x as single, y as single)
    declare sub SetScale(value as Vector2)
end type

'Constructors

constructor Rectangle()
    this.scale = type<Vector2>(1, 1)
end constructor

constructor Rectangle(position as Vector2)
    this.position = position
    this.scale = type<Vector2>(1, 1)
end constructor

constructor Rectangle(position as Vector2, scale as Vector2)
    this.position = position
    this.scale = scale
end constructor

'Methods

sub Rectangle.SetPosition(x as single, y as single)
    this.position = type<Vector2>(x,y)
end sub
