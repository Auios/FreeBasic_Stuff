#include "fbgfx.bi"
 
const iSize = 512
const iLevel = 6
 
screenres iSize,iSize
 
dim shared as ubyte Noise(iSize,iSize)
 
dim as fb.image ptr pNoise
dim as ubyte ptr pPix
pNoise = ImageCreate(iSize,iSize)
pPix = cast(ubyte ptr,pNoise+1)
 
for C as integer = 0 to 255
  var A = 255,B=255-C
  palette C,B and (not 7),B and (not 7),A and (not 7)
next C
 
for Y as integer = 0 to iSize-1
  for X as integer = 0 to iSize-1
    var iC = rnd*255
    Noise(X,Y) = iC
  next X
next Y
 
 
dim as double TMR = timer
line pNoise,(0,0)-(iSize,iSize),0,bf
 
for C as integer = 0 to iLevel
 
  var iStep = 1 shl C,iAnd = iStep-1
  var iPos=0,iDiv=C+iLevel+1
  #if 1 'crop grid for subsamples
    #define op shr
    var iStepB = 1, iBlk = C
  #else 'scale grid for subsamples
    #define op and
    var iStepB = iStep, iBlk = not iAnd
  #endif
 
  ' *** generate subsamples and add results ***
  for Y as integer = 0 to iSize-1
    var YY = (Y op iBlk), Y1 = (Y and iAnd), Y2 = iStep-Y1    
    var SY = iif((Y+iStep)>=iSize,0,iStepB)
    for X as integer = 0 to iSize-1  
      var XX = (X op iBlk), X1 = (X and iAnd), X2 = iStep-X1
      var SX = iif((X+iStep)>=iSize,0,iStepB)      
      var C1 = cint(Noise(XX   ,YY   ))*X2*Y2
      var C2 = cint(Noise(XX+SX,YY   ))*X1*Y2
      var C3 = cint(Noise(XX   ,YY+SY))*X2*Y1
      var C4 = cint(Noise(XX+SX,YY+SY))*X1*Y1      
      pPix[iPos] += ((C1+C2+C3+C4) shr iDiv): iPos += 1
    next X
  next Y  
   
next C
 
put(0,0),pNoise,pset
locate 1,1: color 255,0
print csng((timer-TMR)*1000);"ms"
 
sleep
 
' *** just some palette randomizing ***
 
dim as integer C
do until multikey(1)  
  locate 2,1: print C
  randomize C: C += 1
  var iStp = 1 shl cint(3+rnd*3)
  var iOR = 0,iOG = 0,iOB = 0
  for C as integer = 0 to 255 step iStp
    var iR = rnd*255,iG=rnd*255,iB=rnd*255
    for I as integer = 0 to (iStp-1)
      var RR = (iOR*(iStp-I)+(iR*I))\iStp
      var GG = (iOG*(iStp-I)+(iG*I))\iStp
      var BB = (iOB*(iStp-I)+(iB*I))\iStp
      palette C+I,RR and (not 15),GG and (not 15),BB and (not 15)
    next I
    iOR = iR: iOG = iG: iOB = iB
  next C
  sleep
loop