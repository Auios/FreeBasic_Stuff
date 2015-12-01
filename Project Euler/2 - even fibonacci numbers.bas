dim as integer a,b,c,sum
a = 0
b = 1

while c < 4000000
    c = a+b
    a = b
    b = c
    color 15:print c
    if frac(c/2) = 0 then
        color 11:print c
        sum+=c
    end if
wend

color 14:print "Total: " & sum
sleep