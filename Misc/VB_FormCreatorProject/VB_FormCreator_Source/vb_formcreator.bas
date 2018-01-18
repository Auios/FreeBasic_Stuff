#include "vbFile.bas"
#include "file.bi"

dim as vbFile f
dim as string fileName = "formData.csv"
dim as string prevFormName
dim as string formName, className, eventName
dim as integer cnt
'dim as hWnd hwnd
dim as integer argc = __FB_ARGC__
dim as zstring ptr ptr argv = __FB_ARGV__

if(argv = 1) then fileName = *argv[1]

if(fileExists(fileName)) then
    open fileName for input as #1
else
    print "Error, file does not exist! [" & fileName & "]"
    sleep()
    end(0)
end if

while(NOT EOF(1))
    input #1, formName, className, eventName, cnt
    
    if(prevFormName <> formName) then
        if(prevFormName <> "") then
            f.generate()
            f.resetSelf()
        end if
        
        print "New form: " & formName
        f.fileName = formName
    end if
    f.addJob(f.fileName, className, eventName, cnt)
    print ">",formName, className, eventName, cnt
    prevFormName = formName
wend
f.generate()

'print *argv[0]
'ShellExecute(hwnd,"open",NULL,NULL,*argv[0],SW_SHOWNORMAL)

close #1

sleep()