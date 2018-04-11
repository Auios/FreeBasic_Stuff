function getUserKey(username as string) as ubyte
    dim as ubyte key
    dim as integer userNo
    for i as integer = 0 to len(username)-1
        userNo+=username[i]
    next i
    key = (userNo*username[0]) MOD 256
    if(key = 0) then key = 123
    return key
end function

function encryptPassword(username as string, password as string) as string
    dim as ubyte key
    dim as string userStr, passStr, fullup
    
    key = getUserKey(username)
    
    'userStr
    for i as integer = 0 to len(username)-1
        userStr+=chr(username[i] XOR key MOD 256)
    next i
    
    'passStr
    for i as integer = 0 to len(password)-1
        passStr+=chr(password[i] XOR key MOD 256)
    next i
    
    'fullup
    fullup = userStr & passStr
    for i as integer = 0 to len(fullup)-1
        fullup[i] = fullup[i] XOR key*2 MOD 256
    next i
    
    return fullup
end function

dim as string username, password
username = "Auios"
password = "5018Aduioa?"

print(encryptPassword(username, password))
print username & password

sleep()