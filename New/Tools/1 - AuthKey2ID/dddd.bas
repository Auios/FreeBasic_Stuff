function IntToStr(iNum as uinteger) as string    
    var sOut = mki(iNum)
    if iNum >= (2^24) then
      cptr(uinteger ptr,@sOut)[1] = 4
    elseif iNum >= (2^16) then
      cptr(uinteger ptr,@sOut)[1] = 3
    elseif iNum >= (2^8) then
      cptr(uinteger ptr,@sOut)[1] = 2
    else
      cptr(uinteger ptr,@sOut)[1] = 1
    end if
    return sOut
end function
 
function StrToInt(sNum as string) as integer
    return cvi(sNum+string(4,0))
end function

var sData = chr(255)+chr(255)+chr(255)
print strToInt(sdata)
print intToStr(strToInt(sdata));"..."
 
sleep