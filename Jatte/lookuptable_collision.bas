screenres 800,600,32
 
'// Setup
type t_lutIndex
    Outer as integer = -1
    Inner as integer
end type
 
type t_Entity
    x as integer
    y as integer
    team as integer
    vision as integer
    lutIndex as t_lutIndex
end type
dim shared as t_Entity Entity(50000) '// Make it shared so it can be dynamically allocated so we don't get STACK errors
 
type t_lutMap
    Entities as integer
    Ent(255) as integer '// Max of 255 entities in the same region. Max depends on use scenario
end type
dim as t_lutMap lutMap(500)
 
 
'// Dummy variables just to make sure it all compiles
dim as integer entityIndex '// This would be a for loop iterating over all your "bots"
 
 
 
'// When an entity moves
'// Calculate new lut position
dim as integer lutOuter = Entity(entityIndex).X / 50 '// Depends on the max size of your map, higher number means more entities in the same "region"
if lutOuter <> Entity(entityIndex).lutIndex.Outer then '// New lut position is different from the old one
    if Entity(entityIndex).lutIndex.Outer > -1 then '// We already have a stored lut, clear it!
        '// Move last item in the list to this position
        lutMap(Entity(entityIndex).lutIndex.Outer).Ent(Entity(entityIndex).lutIndex.Inner) = lutMap(Entity(entityIndex).lutIndex.Outer).Ent(lutMap(Entity(entityIndex).lutIndex.Outer).Entities)
        lutMap(Entity(entityIndex).lutIndex.Outer).Entities -= 1
    end if
    '// Set the new lut index
    Entity(entityIndex).lutIndex.Outer = lutOuter
   
    '// Add it to the lut map
    lutMap(Entity(entityIndex).lutIndex.Outer).Ent(lutMap(Entity(entityIndex).lutIndex.Outer).Entities) = entityIndex
    lutMap(Entity(entityIndex).lutIndex.Outer).Entities += 1
end if
 
 
'// When we check for collisions
dim as integer _ourTarget = -1
dim as integer _minRange = 2^30 '// We only need this if we want to find the NEAREST entity in range
for _lutOffset as integer = -1 to 1 '// We might want to check more than just one region (But never less than one!) to either side of us, depends on use scenario
    dim as integer _lutIndex = Entity(entityIndex).lutIndex.Outer + _lutOffset
   
    '// Only required if the world wraps around, otherwise we can just skip detection if _lutIndex < 0 or > ubound(lutMap)
    if _lutIndex < 0 then _lutIndex += (ubound(lutMap) + 1)
    if _lutIndex > ubound(lutMap) then _lutIndex = (_lutIndex - 1) - ubound(lutMap)
   
    '// If our world does not wrap around (The X axis in this case) we can wrap our vision check in this IF statement
    'if _lutIndex >= 0 and _lutIndex <= ubound(lutMap) then
   
    '// Perform actual vision check
    if lutMap(_lutIndex).Entities then '// Check if there are any entities here
        for _entityScan as integer = 0 to lutMap(_lutIndex).Entities '// Iterate through them
            if Entity(lutMap(_lutIndex).Ent(_entityScan)).Team <> Entity(entityIndex).Team then '// It's an entity belonging to a different team!
                dim as integer _deltaX = abs(Entity(lutMap(_lutIndex).Ent(_entityScan)).X - Entity(entityIndex).X)
                dim as integer _deltaY = abs(Entity(lutMap(_lutIndex).Ent(_entityScan)).Y - Entity(entityIndex).Y)
                if _deltaX < Entity(entityIndex).Vision and _deltaY < Entity(entityIndex).Vision then '// Early discard
                    dim as integer _Distance = (_deltaX ^ 2 + _deltaY ^ 2)
                   
                    '// We use this code if we want to find the FIRST hostile entity, regardless of its range within our Vision range
                    if _Distance < Entity(entityIndex).Vision ^ 2 then
                        '// We have a collision!
                        _ourTarget = lutMap(_lutIndex).Ent(_entityScan)
                        '// We got it! Let's exit
                        exit for, for
                    end if
                   
                    '// If we want to find the NEAREST hostile entity within range of our vision
                    if _Distance < _minRange then
                        _minRange = _Distance
                        _ourTarget = lutMap(_lutIndex).Ent(_entityScan)
                       
                        '// Do not exit!
                    end if
                end if
            end if
        next
    end if
next
'// We only need to do this if we are looking for the NEAREST hostile entity
if _ourTarget > -1 then
    if (Entity(_ourTarget).X - Entity(entityIndex).X) ^ 2 + (Entity(_ourTarget).Y - Entity(entityIndex).Y) ^ 2 > Entity(entityIndex).Vision ^ 2 then
        _ourTarget = -1 '// It is outside our range
    end if
end if
 
'// Do we have a hit? Do something with it!
if _ourTarget > -1 then
    '// "Shoot her!"
end if

sleep()