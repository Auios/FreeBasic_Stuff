#include "eval.bi"

#define CRLF chr(13) & chr(10)

sub replace(byref s as string, _
            byval f as string, _
            byval w as string)
  dim as string l,r
  dim as integer p=instr(s,f)
  while p>0
    l="":r=""
    if p>1 then l=left(s,p-1)
    if (p+len(f))<len(s) then r=right(s,len(s)-((p-1)+len(f)))
    s=l & w & r
    p=instr(s,f)
  wend
end sub

function evalbasic(byref expr as string) as integer
  expr=lcase(expr)
  replace(expr," and " ," && ")
  replace(expr," or "," || ")
  replace(expr," not" ,"!")
  replace(expr," "  ,""  )
  replace(expr,CRLF ,";;")
  replace(expr,"/'" ,"/*")
  replace(expr,"'/" ,"*/")
  replace(expr,"rem","//")
  replace(expr,"dim",""  )
  replace(expr,"var",""  )
  replace(expr,"'"  ,"//")
  replace(expr,"<>" ,"!=")
  replace(expr,"^"  ,"**")
  replace(expr,":"  ,"," )
  replace(expr,";;" ,";" & CRLF)
  ' ...
  ' ...
  return eval(expr)
end function


dim as string expression= _
"REM is this BASIC?"                    & CRLF & _
"/' simple assignment expressions '/"   & CRLF & _
"dim a=7"                               & CRLF & _
"var b,i=696"                           & CRLF & _
"b = 23"                                & CRLF & _
"/' complex assignment operators '/"    & CRLF & _
"var d = 10: d  = d+b"                  & CRLF & _
"dim e = 11: e *= a"                    & CRLF & _
"var f = 12: f  = f-b"                  & CRLF & _
"dim g = 13: g /= a"                    & CRLF & _
"REM add to memory, "                   & CRLF & _
"REM with parenthesized assignment"     & CRLF & _
"dim h=(1/(c=.05))"                     & CRLF & _
"var LongVariableNames=(a+b)/(a-b)"     & CRLF & _
"var x"                                 & CRLF & _
"x = h/LongVariableNames: var y=1-x"    & CRLF & _
"' Comparison operators"                & CRLF & _
"var x_LE_y    = x<y"                   & CRLF & _
"dim x_LE_EQ_y = x<=y"                  & CRLF & _
"var x_GR_y    = x>y"                   & CRLF & _
"dim x_GR_EQ_y = x>=y,x_NE_y = x<>y"    & CRLF & _
"' Standard math functions"             & CRLF & _
"dim u=sin(x),v=cos(y)"                 & CRLF & _
"var theta=atan2(u,v)"                  & CRLF & _
"var test1 = (x < y and u<>v)"          & CRLF & _
"var test2 = not(x > y or  u<>v)"       & CRLF & _
"' Exponentiation"                      & CRLF & _
"dim w = y^x"                           & CRLF & _
"dim q = -c^-2"

dim as integer ret=EvalBASIC(expression)
if ret=0 then
  if nVariables>0 then
    for i as integer=0 to nVariables-1
      print *lpVars[i].var_name  & "=" & lpVars[i].var_value
    next
  end if
else
  print "error: "  & *lpErrorRecord->err_message & _
        " in line " & lpErrorRecord->err_line   & _
        " column " & lpErrorRecord->err_column
  beep
end if
getkey
end