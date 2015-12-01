dim as double n,i=2,large
n = 600851475143
print "Numer: " & n
while n>1
    if n mod i = 0 then
        if i > large then
            color 11:print i
            large = i
        end if
        color 15:print i
        n/=i
    else
        i+=1
    end if
wend

print "Largest prime: " & large

sleep