#include "eval.bi"


dim as integer ret=eval("result=sin(0.5*cos(3.14))+100.0/25.0")
if ret=0 then
  if nVariables>0 then
    for i as integer=0 to nVariables-1
      print *lpVars[i].var_name  & "=" & lpVars[i].var_value
    next
  end if
else
  print "error: " & *lpErrorRecord->err_message & " in line " & lpErrorRecord->err_line
end if
getkey
end

