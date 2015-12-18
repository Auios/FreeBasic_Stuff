#include "fbgfx.bi"
using fb

dim as integer ans
dim as string text

do
    cls
    print "1. Write to file"
    print "2. Read from file"
    print "0. Exit"
    input "",ans
    
    select case ans
    case 1'Write
        cls
        print "Write: "
        open "data.txt" for output as #1
        input "",text
        write #1,text
        close #1
    case 2'Read
        cls
        print "The file contains: "
        open "data.txt" for input as #1
        line input #1,text
        print "",text
        close #1
        sleep
    case 0
        stop
    end select
loop until multikey(sc_escape)