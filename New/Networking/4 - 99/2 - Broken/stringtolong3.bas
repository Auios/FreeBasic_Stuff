dim as string sA = "md."
 
dim TMR as double,Resu as integer
 
#define cvl3(_s_) (cvl(_s_ " ")-&h20000000)
#define StrToLong3(_s_) (*cptr(ulong ptr,strptr(_s_)) and &hFFFFFF)
 
' --------------------------------------------
Resu=0:TMR=timer
for CNT as integer = 0 to 2^24
  select case sA
  case "mu.": Resu = 1
  case "md.": Resu = 2
  end select
next CNT
print "string", csng((timer-TMR)*1000);"ms",Resu
' --------------------------------------------
Resu=0:TMR=timer
for CNT as integer = 0 to 2^24
  select case StrToLong3(sA)
  case cvl3("mu."): Resu = 1
  case cvl3("md."): Resu = 2
  end select
next CNT
print "integer", csng((timer-TMR)*1000);"ms",Resu
' --------------------------------------------
 
sleep