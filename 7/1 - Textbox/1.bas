screenres 640,480,32
color rgb(0,0,0),rgb(240,240,240):cls

dim shared as integer mx,my,mb

' GLOBAL VARIABLES USED BY TEXTBOX ROUTINES DrawTextBox and EditTextBox
dim shared as integer cursor,posX,shiftX

type TextBox
    as integer x
    as integer y
    as integer w
    as integer h
    as string  t
    as integer a   'active
    as integer j   'justify left = 0 /center = 1/right = 2
end type

posX   = 0   'first position
cursor = 0   

sub drawTextBox(tb as textBox)

    screenlock()
    'clear rectangle
    line (tb.x,tb.y)-(tb.x+tb.w+8,tb.y+tb.h),rgb(255,255,255),bf
    'draw border
    line (tb.x,tb.y)-(tb.x+tb.w+8,tb.y+tb.h),rgb(127,127,127),b
    line (tb.x+1,tb.y+1)-(tb.x+tb.w+7,tb.y+tb.h-1),rgb(127,127,127),b
    'two horizontal lines
    line (tb.x,tb.y+tb.h)-(tb.x+tb.w+8,tb.y+tb.h),rgb(195,195,195)
    line (tb.x+1,tb.y+tb.h-1)-(tb.x+tb.w+8,tb.y+tb.h-1),rgb(195,195,195)
    'two vertical lines
    line (tb.x+tb.w+8,  tb.y+2)-(tb.x+tb.w+8,tb.y+tb.h),rgb(195,195,195)
    line (tb.x+tb.w+7,  tb.y+2)-(tb.x+tb.w+7,tb.y+tb.h),rgb(195,195,195)
    
    'keep cursor within the box
    if cursor > posX+tb.w/8 then
        posX = posX + 1
    end if
    
    if cursor < posX+1 then
        if posX>0 then
            posX = posX - 1
        end if
    end if

    if len(tb.t)*8 > tb.w or tb.j = 0 then
        draw string (tb.x+4,tb.y+4),mid(tb.t,posX+1,tb.w\8)    
        if tb.a = 1 then
            line (tb.x+cursor*8+4-posX*8,tb.y+2)-(tb.x+cursor*8+4-posX*8,tb.y + 14),rgb(10,10,10)  'draw cursor
        end if
    else
        if tb.j = 1 then shiftX = tb.w\2-len(tb.t)*8/2
        if tb.j = 2 then shiftX = tb.w-len(tb.t)*8
        draw string (tb.x+4+shiftX,tb.y+4),tb.t
        if tb.a = 1 then
            line (tb.x+cursor*8+4+shiftX,tb.y+2)-(tb.x+cursor*8+4+shiftX,tb.y + 14),rgb(10,10,10)  'draw cursor
        end if
    end if

    screenunlock()
    
end sub

sub editTextBox(tb as TextBox)
    dim as string key
    dim as integer ascKey

    cursor =(mx - tb.x)\8+posX
    if cursor > len(tb.t) then
        cursor = len(tb.t)
    end if
    while mb=1
        getmouse mx,my,,mb
    wend
    tb.a = 1 'activate
    
    do
        getmouse mx,my,,mb
        if mb=1 then
            if  mx>tb.x and mx<tb.x+tb.w and my>tb.y and my<tb.y+tb.h then
                cursor =(mx - tb.x)\8+posX
                if cursor > len(tb.t) then
                    cursor = len(tb.t)
                end if
                while mb=1
                    getmouse mx,my,,mb
                wend
            end if
        end if
        
        key = inkey
        if key<>"" then
            if len(key)>1 then
                ascKey = asc(right(key,1))
                if ascKey = 75 then  'CURSOR LEFT
                    if cursor > 0 then
                        cursor = cursor -1 
                    end if
                end if
                if ascKey = 77 then  'CURSOR RIGHT
                    if cursor < len(tb.t) then
                        cursor = cursor + 1
                    end if
                end if
                if ascKey = 83 then 'DELETE
                    tb.t = left(tb.t,cursor) + right(tb.t,len(tb.t)-cursor-1)
                end if
            else
                ascKey = asc(key)
                if asc(key)=8 then
                    if cursor > 0 then  'BACKSPACE
                        tb.t = left(tb.t,cursor-1) + mid(tb.t,cursor+1,len(tb.t)-cursor)
                        cursor = cursor - 1
                    end if
                else
                    if ascKey<>9 and ascKey<>27 and ascKey<>13 then  'TAB, ESC, ENTER
                        tb.t = left(tb.t,cursor) + key + right(tb.t,len(tb.t)-cursor)
                        cursor = cursor + 1
                    end if
                end if
            end if
        end if
    
        drawTextBox(tb)
  
        sleep 2
    
    loop until asc(key)=13 or ascKey=9 or ascKey=27 or mb=1 'ENTER, TAB, ESC
    
    tb.a = 0 'deactivate
    
end sub


'========================  USE OF TEXTBOX EXAMPLE ===========================

dim shared as textBox tb1  'create a textbox tb1

'initialize its properties
tb1.x = 40          
tb1.y = 100
tb1.w = 20*8        'wide enough for 20 characters 8 pixels wide
tb1.h = 16
tb1.t = ""
tb1.a = 0
tb1.j = 0

sub update()
    screenlock
    cls
    drawTextBox(tb1)
    screenunlock
end sub

'     --- MAIN ---

do
    getmouse mx,my,,mb

    'test if left mouse button down over text box
    if mb=1 and mx>tb1.x and mx<tb1.x+tb1.w and my>tb1.y and my<tb1.y+tb1.h then
        editTextBox(tb1)
    end if

    update()  'update the display
    while(inkey <> ""):wend
    sleep 2
    
loop until multikey(&H01)