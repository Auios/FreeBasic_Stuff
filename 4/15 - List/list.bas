#include "fbgfx.bi"
#include "scrn.bas"
using fb

randomize 1

scrn()

'Variables
dim as integer ff = freefile()
dim as integer i,j,numLines
dim as string buffer(),fileName

dim as double start = timer

filename = "data.txt"

'Functions
function getLineCount(filename as string,ff as integer) as integer
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

'Main loop
do
    screenlock
    cls
    print (timer-start)*1000
    start = timer
    
    print "Getting lines..."
    numLines = getLineCount(fileName,ff) 'Get line count
    redim as string buffer(1 to numLines) 'Resize the array
    print "Lines in file: " & numLines
    
    'Open File
    print ""
    print "Opening file..."
    print ""
    
    if (open(filename for input as #ff)) then 'Error check
        print "Error opening file " & fileName
        sleep
        end -1
    end if
    
    'Go through every line in the file and store it in the buffer
    for i = 1 to numLines
        input #ff,buffer(i)
        print "Line - " & i & ": " & buffer(i) 'print buffer
    next i
    
    close #ff 'Close file

    print
    print "Closing file"
    
    screenunlock
    
    sleep
    
    if multikey(sc_escape) then end 0
loop until multikey(sc_escape)