#define fbc -s gui
 
' ----------------------- Procedure to Set a different name -----------------------
 
sub SetExecutableName(sName as string)  
  var sAppName = command$(0), sDesiredName = sName
  'In case Name is empty
  if len(sName)=0 then sName = "Null"
  'Clean Name from invalid characters
  for CNT as integer = 0 to len(sName)-1    
    select case sName[CNT]
    case 0 to 31,92,47,42,58,63,34,60,62,124
      sDesiredName[CNT] = asc("_")
    end select
  next CNT
  'App Name is started with desired name?
  if right$(sAppName,len(sDesiredName)) = sDesiredName then
    ' Get Original name and rename it back
    var sTemp = environ("__AppOrgName__")  
    SetEnviron("__AppOrgName__=")
    name sAppName as sTemp
  else
    ' Get full path for new filename (same folder)
    var iA = instrrev(sAppName,!"\\"), iB = instrrev(sAppName,"/")
    if iB > iA then iA = iB
    var sNewName = left$(sAppName,iA)+sDesiredName
    ' Does a file with that name already exists?? (try to rename it out)
    for CNT as integer = 1 to 10
      if name(sAppName,sNewName) then
        name(sNewName,sNewName+".bk" & CNT): continue for
      end if
      if CNT < 10 then exit for else stop
    next CNT    
    ' Dynamically Load GetProcessA() function
    dim CallProcess as function (as zstring ptr,as zstring ptr,as long,as long,as long,as long,as long,as long,as any ptr,as any ptr) as integer
    var hKernel = dylibload("kernel32.dll")
    CallProcess = dylibsymbol(hKernel,"CreateProcessA")    
    ' Call the newly renamed process now with desired name
    dim as integer tStart(16) = {68}, tInfo(3)    
    SetEnviron("__AppOrgName__=" & sAppName & "")    
    CallProcess(0,""""+sNewName+""" "+command$,0,0,0,0,0,0,@tStart(0),@tInfo(0))  
    ' Done... quit the first instance.
    stop
  end if
end sub
 
' -------------- Usage Example (must be first thing being executed) ---------------
 
SetExecutableName("c:\Nigga's Dream ινσϊ.exe|sort >output.txt")
screenres 640,480
print "Done..."
sleep