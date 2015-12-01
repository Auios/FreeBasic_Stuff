#include "crt.bi"

#define PutBuff(A_) *cptr(TypeOf(A_) ptr ,pBuff+iPos) = A_ : iPos += sizeof(typeof(A_))
'#define GetBuff(A_) A_ = *cptr(TypeOf(A_) ptr, pbuff) : sbuff = right(sbuff,len(sbuff)-sizeof(A_)) : iPos-=sizeof(A_)
'#define GetBuff(A_) A_ = *cptr(TypeOf(A_) ptr, pbuff) : iPos-=sizeof(A_)
#define GetBuff(A_) A_ = *cptr(TypeOf(A_) ptr, pbuff) : memcpy(pBuff,pBuff+sizeof(A_),iPos-sizeof(A_)) : iPos-=sizeof(A_)
'#define GetBuff(A_) if iPos >= sizeof(A_) then A_ = *cptr(TypeOf(A_) ptr, pbuff) : memcpy(pBuff,pBuff+sizeof(A_),iPos-sizeof(A_)) : iPos-=sizeof(A_)
'#define ClsBuff() sbuff = space(16):ipos = 0
#define ClsBuff() ipos = 0

'myShort = *cptr(short ptr, pBuff)

'*cptr(tBuffA ptr, pBuff) = type(7,10,20,30): pBuff += sizeof(tBuff)
'*cptr(tBuffB ptr, pBuff) = type(4,1,2,3): pBuff += sizeof(tBuff)

'if hSelect(Sock,1) then hSend(...)

dim as integer ipos=0
dim as string sBuff = space(16)
dim as any ptr pBuff = strptr(sBuff)

'=====

dim as short x = 75
dim as short myShort = 5

print
print "Put"
x+=1
putbuff(x)
print "Pos: " & iPos
print sbuff & "..." & len(sbuff)
print myShort

print
print "Get"
getbuff(myShort)
print "Pos: " & iPos
print sbuff & "..." & len(sbuff)
print myShort

print
print "Put"
x+=1
putbuff(x)
print "Pos: " & iPos
print sbuff & "..." & len(sbuff)
print myShort

print
print "Get"
getbuff(myShort)
print "Pos: " & iPos
print sbuff & "..." & len(sbuff)
print myShort

print
print "Put"
x+=1
putbuff(x)
print "Pos: " & iPos
print sbuff & "..." & len(sbuff)
print myShort

print
print "Get"
getbuff(myShort)
print "Pos: " & iPos
print sbuff & "..." & len(sbuff)
print myShort
sleep
