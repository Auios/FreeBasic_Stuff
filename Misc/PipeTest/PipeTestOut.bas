dim as ubyte runApp = 1

dim as integer count

while(runApp)
    count+=1
    print count
    
    if(inkey = chr(27)) then runApp = 0
    
    sleep(500,1)
wend
