'function intToStr(n as integer) as string
'    //psudo code
'    int index = 0
'    string nstr = (string)n
'    string result
'    for(int i = 0; i < nstr.length(); i++)
'        index = (int)floor(n/((nstr.length()-(i+1))^32) % 32)
'        result = result + //Function to get char from ascii number <index>
'    next i
'    return result
'end function

function blid_to_auth(blid as ulong) as string
    dim as integer index = 0
    dim as string nstr = str(blid)
    dim as string result = ""
    for i as integer = 0 to len(nstr)-1
        index = int(blid / ((len(nstr)-(i+1)) XOR 32) MOD 32)
        result+=chr(index)
    next i
    return result
end function

print(blid_to_auth(4669)) ' Should be AAET7
sleep()