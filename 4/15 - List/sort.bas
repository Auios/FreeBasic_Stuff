randomize timer

dim shared as integer num(1 to 10)

for i as integer = lbound(num) to ubound(num)
    num(i) = 100*rnd
    print num(i)
next i

print "================"

sub sort(myarray() as integer)
    dim as integer highest
    dim as integer tmp
    
    for i as integer = lbound(myarray) to ubound(myarray)
        for j as integer = i+1 to ubound(myarray)
            if myarray(j) > myarray(i) then
                tmp = myarray(i)
                myarray(i) = myarray(j)
                myarray(j) = tmp
            end if
        next j
    next i
end sub

sort(num())

for i as integer = lbound(num) to ubound(num)
    print num(i)
next i

sleep