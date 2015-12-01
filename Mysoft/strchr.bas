#include "crt.bi"
 
var sMessage = !"5\tCca\tHello guys\r\n"
 
dim as zstring ptr pNext,pStart = strptr(sMessage)
do  
  pNext = strchr(pStart,asc(!"\t"))
  if pNext then *cptr(ubyte ptr,pNext)=0
 
  print *pStart
 
  pStart = pNext+1  
loop while pNext
 
sleep