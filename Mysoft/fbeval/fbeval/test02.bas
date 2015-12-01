#include "eval.bi"
dim as string expression= _
!"/* simple assignment expressions */\n" & _
!"a =  7;\n" & _
!"b = 23;\n" & _
!"/* complex assignment operators */\n" & _
!"d = 10, d += b;\n" & _
!"e = 11, e *= a;\n" & _
!"f = 12, f -= b;\n" & _
!"g = 13, g /= a;\n" & _
!"/* add to memory, with parenthesized assignment */\n" & _
!"h += (1/(c=.05));\n" & _
!"LongVariableNamesAreOK = (a+b)/(a-b);\n" & _
!"x = h/LongVariableNamesAreOK, y = 1-x;\n" & _
!"// Comparison operators\n" & _
!"xLTy = x<y;\n" & _
!"xLEy = x<=y;\n" & _
!"xGTy = x>y;\n" & _
!"xGEy = x>=y;\n" & _
!"xNEy = x!=y;\n" & _
!"xeqy = x==y;\n" & _
!"// Conditional expressions are supported\n" & _
!"test = !(x < y  && u != v) ? y : x >= z ? z : 1 ;\n" & _
!"// Standard math functions\n" & _
!"u=sin(x), v = cos(y);\n" & _
!"theta = atan2(u,v);\n" & _
!"//checkInversion\n" & _
!"ok = (phi = atan2(sin(theta),cos(theta))) == theta;\n" & _
!"// Exponentiation\n" & _
!"w = y**x;\n" & _
!"q = -c**-2;\n"

dim as integer ret=eval(expression)
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