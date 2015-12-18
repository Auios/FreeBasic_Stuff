dim a as integer
dim b as string


OPEN "myfile.txt" FOR OUTPUT AS #1
WRITE #1, 1,"Hello, World"
CLOSE #1

OPEN "myfile.txt" FOR INPUT AS #1
INPUT #1, a,b
CLOSE #1
PRINT a,b
sleep

cls
type prop
    as integer x,y
    as string sign
end type
dim shared as prop ent(5)

for i as integer = 0 to 5
    with ent(i)
        .x = 10*rnd
        .y = 10*rnd
        .sign = "ID: " & i
    end with
next i

for i as integer = 0 to 5
    open i & ".txt" for output as #1
    put #1,,ent(i)
    close #1
next i

for i as integer = 0 to 5
    with ent(i)
        .x = 0
        .y = 0
        .sign = ""
    end with
next i

for i as integer = 0 to 5
    open i & ".txt" for input as #1
    get #1,,ent(i)
    close #1
next i

cls
for i as integer = 0 to 5
    with ent(i)
        print .sign
        print .x
        print .y
    end with
next i
sleep
