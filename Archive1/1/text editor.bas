screenres 1080,500,32,2
screenset 1,0
color rgb(0,0,0),rgb(255,255,255) 'black ink, white paper
cls      'execute color statement

dim shared as integer xBox,yBox
xBox = 100
yBox = 100
dim shared as string  strKey
dim shared as integer ascKey
dim shared as integer ptr1
dim shared as integer ptr2
dim shared as integer start    'first character to print from
start = 0

ptr1 = 0
ptr2 = 79

dim shared as integer text(80)
'fill text with dots
for i as integer = 0 to 79
    text(i)=asc(".")
next i

sub printText()
    dim as integer scrPtrX
    cls
    line (xBox,yBox)-(xBox+21*8,yBox+16),rgb(0,0,255),b
    locate 1,1
    for i as integer = 0 to 79
        draw string (i*8,0), chr(text(i))
    next i
    draw string (ptr1*8,8),"^"
    draw string (ptr1*8,16),"ptr1"
    draw string (ptr2*8,8),"^"
    draw string (ptr2*8,16),"ptr2"

    scrPtrX = 0   'pointer to screen
    
    color rgb(255,0,0)
    if ptr1>0 then
        for i as integer = start to ptr1-1
            draw string (scrPtrX*8+xBox+4,yBox+4), chr(text(i))
            scrPtrX = scrPtrX+1
        next i
    end if
    
    draw string(ptr1*8+xBox+4-start*8,yBox+4), "_"
    
    color rgb(0,255,0)   
    if ptr2 < 79 then
        for i as integer = ptr2+1 to 79
            if scrPtrX < 20 then
                draw string (scrPtrX*8+xBox+4,yBox+4), chr(text(i))
                scrPtrX = scrPtrX+1
            end if
        next i
    end if
    
    color rgb(0,0,0)
    locate 10,1
    print "start =";start
    
    locate 20,2
    print "HIT ENTER TO EXIT DEMO ..."
    
    locate 1,80
    color rgb(255,0,0)
    print "  <-- this is 80 bytes of memory"
    color rgb(0,0,0)
    screencopy   
end sub

    
sub editString()
    
    do

        strKey = inkey
        ascKey = asc(strKey)

        if strKey <> "" then
           ascKey = asc(strKey)
           if ascKey = 255 then
                
               ascKey = asc(right(strKey,1))
                If ascKey = 75 Then             'MOVE CURSOR LEFT
                    if ptr1 <>0 then
                        text(ptr1)=asc(".")  'erase for display
                        ptr1 = ptr1 - 1
                        text(ptr2)=text(ptr1)
                        ptr2 = ptr2 - 1                        
                    end if
                end if
      
                If ascKey = 77 Then
                    if ptr2 < 79 then         'MOVER CURSOR RIGHT
                        ptr2 = ptr2 + 1
                        text(ptr1)=text(ptr2)
                        text(ptr2)=asc(".")  'erase for display
                        ptr1 = ptr1 + 1
                    end if
                end if
                
                if ascKey = 83 then  'delete key
                    if ptr2 < 79 then
                        text(ptr2)=asc(".")  'erase for display
                        ptr2 = ptr2 + 1
                    end if
                end if

            else
                
                if ascKey = 8 then  'backspace
                    if ptr1 > 0 then
                        ptr1 = ptr1 - 1
                    end if
                else
                    if ascKey<>13 and ascKey<>9 and ascKey<> 27 then
                        text(ptr1)=ascKey
                        ptr1 = ptr1 + 1
                    end if
                end if
            
            end if
        end if

        if ptr1>start+19 then
            start = start + 1
        end if
        if ptr1 < start then
            start = start - 1
        end if
        
        printText()

        
    loop until ascKey = 13

end sub

editString()