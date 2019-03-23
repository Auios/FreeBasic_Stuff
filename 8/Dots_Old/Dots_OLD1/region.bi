#pragma once

#include "pnt.bi"
#include "entity.bi"
#include "dot.bi"

type dotNode
    as dotNode ptr nxt, prv
    as dot ptr n
    
    declare constructor()
    declare constructor(n as dot ptr)
end type

constructor dotNode()
end constructor

constructor dotNode(n as dot ptr)
    this.n = n
end constructor

type Region
    as Pnt topLeft, botRight
    
    as integer count
    as dotNode ptr first, last
    
    declare constructor()
    declare constructor(topLeft as Pnt, botRight as Pnt)
    declare destructor()
    
    declare sub init()
    
    declare function inBoundary(p as Pnt) as boolean
    declare function add(n as Dot ptr) as boolean
    declare function remove(n as Dot ptr) as boolean
end type

constructor Region()
end constructor

constructor Region(topLeft as Pnt, botRight as Pnt)
    this.topLeft = topLeft
    this.botRight = botRight
end constructor

destructor Region()
    dim as dotNote curr = first->nxt
end destructor

function Region.inBoundary(p as Pnt) as boolean
    return p.x >= topLeft.x AND p.x < botRight.x AND p.y >= topLeft.y AND p.y < botRight.y
end function

sub Region.init()
    first = new dotNode
    last = new dotNode
    first->nxt = last
    last->prv = first
end sub

function Region.add(n as Dot ptr) as boolean
    dim as dotNode ptr newNode = new dotNode(n)
    newNode->nxt = last
    newNode->prv = last->prv
    last->prv->nxt = newNode
    last->prv = newNode
    
    count+=1
    
    return true
end function

function Region.remove(n as Dot ptr) as boolean
    dim as dotNode ptr curr = first->nxt
    dim as boolean result = false
    while(curr <> last)
        if(curr->n = n) then
            count-=1
            result = true
            curr->prv->nxt = curr->nxt
            curr->nxt->prv = curr->prv
            exit while
        end if
    wend
    return result
end function
