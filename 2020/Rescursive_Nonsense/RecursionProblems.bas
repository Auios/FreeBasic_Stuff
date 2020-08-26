function summation(x as integer) as integer
    return iif(x>0,x+summation(x-1),0)
end function

function grid_paths(x as integer, y as integer) as integer
    return iif(x = 1 ORELSE y = 1, 1, grid_paths(x-1, y) + grid_paths(x, y-1))
end function

print summation(3)
print grid_paths(4, 4)

sleep()
