function encryptString(s as string, key as ubyte = 123) as string
    dim as string newStr
    if(key = 0) then key = 123
    for i as integer = 0 to len(s)-1
        newStr+=chr(s[i] XOR key)
    next i
    return newStr
end function

function decryptString(s as string, key as ubyte = 123) as string
    return encryptString(s,key)
end function

print encryptString("5018Aduioa?")
print decryptString(encryptString("5018Aduioa?"))
sleep