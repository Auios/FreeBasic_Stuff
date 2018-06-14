#include once "List.bas"



type Point
    as integer x
    as integer y
    
    declare constructor()
    declare constructor(x as integer, y as integer)
end type

constructor Point()
    this.x = 0
    this.y = 0
end constructor

constructor Point(x as integer, y as integer)
    this.x = x
    this.y = y
end constructor

type Node
    as Point pos
    as integer data
    
    declare constructor()
    declare constructor(pos as Point, data as integer)
end type

constructor Node()
    this.data = 0
end constructor

constructor Node(pos as point, data as integer)
    this.pos = pos
    this.data = data
end constructor

DeclareList(object)

type QuadTree
    as Point topLeft
    as Point botRight
    
    as Node ptr n
    
    as QuadTree ptr topLeftTree
    as QuadTree ptr topRightTree
    as QuadTree ptr botLeftTree
    as QuadTree ptr botRightTree
    
    declare constructor()
    declare constructor(topLeft as Point, botRight as Point)
    
    declare sub insert(node as Node ptr)
    declare function search(p as Point) as Node ptr
    declare function inBoundary(p as Point) as boolean

end type

constructor QuadTree()
    this.topLeft = type<Point>(0, 0)
    this.botRight = type<Point>(0, 0)
    this.n = null
    this.topLeftTree = null
    this.topRightTree = null
    this.topLeftTree = null
    this.topRightTree = null
end constructor

constructor QuadTree(topLeft as Point, botRight as Point)
    this.n = null
    this.topLeftTree = null
    this.topRightTree = null
    this.botLeftTree = null
    this.botRightTree = null
    this.topLeft = topLeft
    this.botRight = botRight
end constructor

'Insert a node into the quadtree
sub QuadTree.Insert(node as Node ptr)
    if(node = null) then return
    
    'Current quad cannot contain it
    if(NOT inBoundary(node->pos)) then return
    
    'We are at a quad of unit area
    'We cannot subdivide this quad further
    if(abs(this.topLeft.x - this.botRight.x) <= 1 AND abs(this.topLeft.y - this.botRight.y) <= 1) then
        if(this.n = null) then n = node
        return
    end if
    
    if((this.topLeft.x + this.botRight.x) / 2 >= node->pos.x) then
        if((this.topLeft.y + this.botRight.y) / 2 >= node->pos.y) then
            'Indicates topLeftTree
            if(this.topLeftTree = null) then
                topLeftTree = @type<QuadTree>(type<Point>(this.topLeft.x, this.topLeft.y), type<Point>((this.topLeft.x + this.botRight.x) / 2, (this.topLeft.y + this.botRight.y) / 2))
                topLeftTree->insert(node)
            end if
        else
            'Indicates botLeftTree
            if(this.botLeftTree = null) then
                this.botLeftTree = @type<QuadTree>(type<Point>(this.topLeft.x, (this.topLeft.y + this.botRight.y) / 2), type<Point>((this.topLeft.x + this.botRight.x) / 2, this.botRight.y))
                this.botLeftTree->insert(node)
            end if
        end if
    else
        if((this.topLeft.y + this.botRight.y) / 2 >= node->pos.y) then
            'Indicates topRightTree
            if(this.topRightTree = null) then
                this.topRightTree = @type<QuadTree>(type<Point>((this.topLeft.x + this.botRight.x) / 2, this.topLeft.y),  type<Point>(this.botRight.x, (this.topLeft.y + this.botRight.y) / 2 ))
                this.topRightTree->insert(node)
            end if
        else
            'Indicates botRightTree
            if(this.botRightTree = null) then
                this.botRightTree = @type<QuadTree>(type<Point>((this.topLeft.x + this.botRight.x) / 2, (this.topLeft.y + this.botRight.y) / 2), type<Point>(this.botRight.x, this.botRight.y))
                this.botRightTree->insert(node)
            end if
        end if
    end if
end sub

'Find a node in a quadtree
function search(p as Point) as Node ptr
    'Current quad cannot contain it
    if(NOT this.inBoundary(p)) then return null
    
    'We are at a quad of unit length
    'We cannot subdivide this quad further
    if(this.n <> null) then return n
    
    if((this.topLeft.x + this.botRight.x) / 2 >= p.x) then
        
end function

function inBoundary(p as Point) as boolean
    
end function

sleep()