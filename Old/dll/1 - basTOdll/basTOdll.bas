'basTOdll.bas
'Small program to compile .bas files into .dll files
'Written by Auios (Cca)
'October 4th, 2015

'Declares
declare function getExt(fileName as string) as string
declare function basToDLL(fileName as string) as integer

'=====Main function=====
dim as string argv,ext
dim as integer argc,result

argc = __FB_ARGC__

if argc > 1 then
    print "Results:"
    for i as integer = 1 to argc-1
        argv = command(i)
        ext = getExt(argv)
        
        if ext = "bas" then
            print "Converting '" & argv & "' to .dll"
            result = basToDLL(argv)
            if result <> 0 then 
                print "Error, '" & argv & "' could not be compiled!"
            end if
        else
            print "Error, '" & argv & "' not a .bas"
        end if
    next i
    print "Done..."
else
    print "Error: You must click and drag .bas files onto the .exe to produce .dll files!"
end if

print
print "Press any key to exit..."
sleep
end 0

'=====End Main=====

'Get extension
function getExt(fileName as string) as string
    dim as integer strLen = len(fileName)
    dim as string result = "?" 'If no file extension found then this is the
                               'default value
    
    'Search for the file extension from right to left
    for i as integer = strLen to 1 step -1
        if mid(fileName,i,1) = "." then
            result = right(fileName,strLen-i) 'Return file extension
            exit for
        end if
    next i
    
    return result
end function

'Command to compile as -dll
function basToDLL(fileName as string) as integer
    return shell("C:\FreeBasic\fbc.exe -dll " & fileName)
    'return shell("C:\FreeBasic\pre-fbc.exe -dll " & fileName)
end function