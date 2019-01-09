#include "fbgfx.bi"
#include "aulib.bi"

using fb, aulib

type Vertex
    as single x,y
    declare sub Set(x as integer, y as integer)
end type

sub Vertex.Set(x as integer, y as integer)
    this.x = x
    this.y = y
end sub

type Triangle
    as Vertex ptr v = new Vertex[3]
end type

type Polygon
    as Vertex ptr v
    as integer count
    as uinteger clr = rgb(255, 0, 255)
    
    declare constructor(v as Vertex ptr = 0, count as integer = 0, clr as uinteger = rgb(255, 0, 255))
    declare sub Render()
end type

constructor Polygon(v as Vertex ptr, count as integer, clr as uinteger = rgb(255, 0, 255))
    this.v = v
    this.count = count
    this.clr = clr
end constructor

sub Polygon.Render()
    
end sub

dim as AuWindow wnd

wnd.init(800, 600)
wnd.show()

dim as Vertex ptr vertices = new Vertex[3]

vertices[0].Set(376, 153)
vertices[1].Set(518, 387)
vertices[2].Set(206, 421)

dim as Polygon poly = type<Polygon>(vertices, 3, rgb(200, 100, 100))

for i as integer = 0 to 2
    print("(" & vertices[i].x & ", " & vertices[i].y & ")")
next i

poly.Render()

sleep()