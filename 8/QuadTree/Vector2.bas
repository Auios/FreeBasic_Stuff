#pragma once

type Vector2
    as single x,y
    
    declare constructor()
    declare constructor(x as single, y as single)
    declare constructor(value as Vector2)
    
    declare sub Set(x as single, y as single)
    declare sub Set(value as Vector2)
    declare function Offset(x as single, y as single) as Vector2
    declare function Offset(value as Vector2) as Vector2
    
    declare function ToString() as string
    declare function GetLength() as single
end type

'Constructors

constructor Vector2()
    this.x = 0
    this.y = 0
end constructor

constructor Vector2(x as single, y as single)
    this.x = x
    this.y = y
end constructor

constructor Vector2(value as Vector2)
    this = value
end constructor

'Methods

sub Vector2.Set(x as single, y as single)
    this.x = x
    this.y = y
end sub

sub Vector2.Set(value as Vector2)
    this = value
end sub

function Vector2.Offset(x as single, y as single) as Vector2
    return type<Vector2>(this.x+x,this.y+y)
end function

function Vector2.Offset(value as Vector2) as Vector2
    return type<Vector2>(this.x+value.x,this.y+value.y)
end function

function Vector2.ToString() as string
    return "[" & this.x & ", " & this.y & "]"
end function

function Vector2.GetLength() as single
    return this.x * this.x + this.y * this.y
end function
