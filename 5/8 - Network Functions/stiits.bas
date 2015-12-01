function intToStr(n as integer) as string
    dim as integer index,length
    dim as string nstr,result
    
    nstr = str(n)
    length = len(nstr)
    
    for i as integer = 1 to length
        index = int(n/((length-i)^256)) mod 256
        result+=chr(index)
    next i
    
    return result
end function

function strToInt(n as string) as integer
    dim as integer value,length
    length = len(n)
    
    for i as integer = 1 to length
        value+=255^(length-i)*(asc(n,i))
    next i
    
    return value
end function

dim as string dta = "AB"

print strToInt(dta)
print "===="
print intToStr(strToInt(dta))
print "----"
print cvi("ABC"+string$(4,0))

sleep