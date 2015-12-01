dim as integer sum

for i as integer = 1 to 999
    if frac(i/3) = 0 or frac(i/5) = 0 then
        sum+=i
        print i
    end if
next i

print sum

sleep