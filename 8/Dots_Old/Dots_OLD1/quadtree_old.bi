#pragma once

#include "AuPoint.bi"
#include "Entity.bi"

#define QT_CAP 8

type QuadTree
    as integer depth
    as AuPoint topLeft, botRight
    
    as uinteger count
    as Entity ptr n
    
    as QuadTree ptr topLeftTree
    as QuadTree ptr topRightTree
    as QuadTree ptr botLeftTree
    as QuadTree ptr botRightTree
    
    declare constructor()
    declare constructor(topLeft as AuPoint, botRight as AuPoint)
    declare function inBoundary(p as AuPoint) as boolean
    declare function subDivide() as boolean
    declare function insert(ent as Entity ptr) as boolean
    declare function findNearest(p as AuPoint) as Entity ptr
end type

constructor QuadTree()
    count = 0
    n = new Entity[QT_CAP]
end constructor

constructor QuadTree(topLeft as AuPoint, botRight as AuPoint)
    this.topLeft = topLeft
    this.botRight = botRight
    count = 0
    n = new Entity[QT_CAP]
end constructor

function QuadTree.inBoundary(p as AuPoint) as boolean
    dim as boolean result = false
    if(p.x >= topLeft.x AND p.x <= botRight.x AND p.y >= topLeft.y AND p.y <= botRight.y) then result = true
    return result
end function

function QuadTree.subDivide() as boolean
    topLeftTree = new QuadTree(type<AuPoint>(topLeft), type<AuPoint>((topLeft.x + botRight.x)/2, (topLeft.y + botRight.y)/2))
    botLeftTree = new QuadTree(type<AuPoint>(topLeft.x, (topLeft.y + botRight.y)/2), type<AuPoint>((topLeft.x + botRight.x)/2, botRight.y))
    topRightTree = new QuadTree(type<AuPoint>((topLeft.x + botRight.x)/2, topLeft.y), type<AuPoint>(botRight.x, (topLeft.y + botRight.y)/2))
    botRightTree = new QuadTree(type<AuPoint>((topLeft.x + botRight.x)/2, (topLeft.y + botRight.y)/2), type<AuPoint>(botRight))
    
    if(count) then
        for i as integer = 0 to count-1
            if(topLeftTree->insert(@n[i])) then
                n[i] = 0
                continue for
            end if
            if(topRightTree->insert(@n[i])) then
                n[i] = 0
                continue for
            end if
            if(botLeftTree->insert(@n[i])) then
                n[i] = 0
                continue for
            end if
            if(botRightTree->insert(@n[i])) then
                n[i] = 0
                continue for
            end if
        next i
    end if
end function

function QuadTree.insert(ent as Entity ptr) as boolean
    if(ent = 0) then return false
    if(NOT inBoundary(ent->position)) then return false
    
    if(abs(topLeft.x - botRight.x <= 1 AND abs(topLeft.y - botRight.y) <= 1)) then
        if(n = 0) then
            n = ent
            return true
        end if
    end if
    
    'Find out which quad to insert into
    if(ent->position.x <= (topLeft.x + botRight.x)/2) then
        'Left
        if(ent->position.y <= (topLeft.y + botRight.y)/2) then
            'Top
            topLeftTree = new QuadTree(type<AuPoint>(topLeft), type<AuPoint>((topLeft.x + botRight.x)/2, (topLeft.y + botRight.y)/2))
            topLeftTree->insert(ent)
        else
            'Bottom
            botLeftTree = new QuadTree(type<AuPoint>(topLeft.x, (topLeft.y + botRight.y)/2), type<AuPoint>((topLeft.x + botRight.x)/2, botRight.y))
            botLeftTree->insert(ent)
        end if
    else
        'Right
        if(ent->position.y <= (topLeft.y + botRight.y)/2) then
            'Top
            topRightTree = new QuadTree(type<AuPoint>((topLeft.x + botRight.x)/2, topLeft.y), type<AuPoint>(botRight.x, (topLeft.y + botRight.y)/2))
            topRightTree->insert(ent)
        else
            'Bottom
            botRightTree = new QuadTree(type<AuPoint>((topLeft.x + botRight.x)/2, (topLeft.y + botRight.y)/2), type<AuPoint>(botRight))
            botRightTree->insert(ent)
        end if
    end if
    return true
end function

function QuadTree.findNearest(p as AuPoint) as Entity ptr
    if(NOT inBoundary(p)) then return 0
end function
