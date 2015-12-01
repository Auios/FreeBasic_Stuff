#include "fbgfx.bi"
using fb

randomize 1

dim as string fileName,buffer(),buffer2()
dim as integer ff = freefile, numlines

'Functions
function getLineCount(fileName as string,ff as integer) as integer
    dim as uinteger cnt 'count variable
    dim as string buffer 'temporary buffer
    if (open(fileName for input as #ff)) then 'Error check
        print "function getLineCount()"
        print "Error opening file " & fileName
        sleep
        return -1
    end if
    
    do 'Loop to collect each line
        input #ff,buffer
        cnt+=1
    loop until eof(ff)
    
    close #ff
    return cnt
end function

function fOutput(fileName as string,outb() as string,ff as integer) as integer
    if (open(fileName for Output as #ff)) then 'Error check
        print "function fOutput()"
        print "Error opening file " & fileName
        sleep
        return -1
    end if
    
    dim as string tmp
    
    for i as integer = lbound(outb,1) to ubound(outb,1)
        tmp = ""
        for j as integer = lbound(outb,2) to ubound(outb,2)
            if outb(i,j) <> "" then
                tmp+=""+chr(valint(outb(i,j)) xor 2000)
            end if
        next j
        print #ff, tmp
    next i
    
    
    close #ff
    return 0
end function

function fInput(fileName as string,buffer() as string,ff as integer) as integer
    redim as string buffer(1 to getLineCount(fileName,ff))
    
    if (open(fileName for input as #ff)) then 'Error check
        print "function fInput()"
        print "Error opening file " & fileName
        sleep
        return -1
    end if
    
    for i as integer = lbound(buffer) to ubound(buffer)
        input #ff,buffer(i)
    next i
    
    close #ff
    return 0
end function

'================================================


fileName = "data.txt"
fInput(fileName,buffer(),ff)

print "====="

dim as integer omg = 0
for i as integer = lbound(buffer) to ubound(buffer)
    var lenn = len(buffer(i))
    if lenn > omg then omg = lenn
next i
redim as string buffer2(1 to ubound(buffer),1 to omg)

for i as integer = lbound(buffer) to ubound(buffer)
    print buffer(i)
    for j as integer = 1 to len(buffer(i))
        dim as string tmp = mid(buffer(i),j,1)
        print tmp,asc(tmp)
        buffer2(i,j) = str(asc(tmp))
    next j
next i

fOutput("data2.txt",buffer2(),ff)

sleep