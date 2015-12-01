#include "crt.bi"
#include "fbgfx.bi"
 
const iSize = 512
const iLevel = 6
 
screenres iSize,iSize
 
function Blend(p0 as integer,p1 as integer,alpha as integer) as integer
   return (p0*(255-alpha) + alpha*p1) shr 8
end function
 
dim shared as ubyte Noise(iSize,iSize)
dim shared as ubyte NoiseB(iSize,iSize)
 
dim as fb.image ptr pNoise
dim as ubyte ptr pPix
pNoise = ImageCreate(iSize,iSize)
pPix = cast(ubyte ptr,pNoise+1)
 
dim as integer iR(8) = {  0, 32, 64,128,255, 64,  0}
dim as integer iG(8) = {255, 16, 32, 64,255,128,  0}
dim as integer iB(8) = {  0,  8, 16, 32,255,255,255}
for iC as integer = 0 to 7  
  for I as integer = 0 to 31
    palette iC*32+I, _
    Blend(iR(iC),iR(iC+1),I*8), _
    Blend(iG(iC),iG(iC+1),I*8), _
    Blend(iB(iC),iB(iC+1),I*8)
  next I
next iC
 
dim as double TMR = timer
 
for Y as integer = 0 to iSize-1
  for X as integer = 0 to iSize-1
    var iC = rnd*255
    Noise(Y,X) = iC
  next X
next Y
 
for C as integer = 0 to iLevel
 
  var iStep = 1 shl C,iAnd = iStep-1
  var iDiv = not iAnd,iSht = 8-C
  var iMid = (iStep shr 1),iPos = 0
 
  for Y as integer = 0 to iSize-1 'Horizontal Linear
    for X as integer = 0 to iSize-1  
      var XX = (X shr C)
      dim as integer C0 = Blend( Noise(Y,XX), Noise(Y,XX+1) ,((X and iAnd) shl iSht) )
      NoiseB(X,Y) = C0    
    next X
  next Y
 
  for Y as integer = 0 to iSize-1 'Vertical Linear
    for X as integer = 0 to iSize-1  
      var XX = (X shr C)
      dim as integer C0 = Blend( NoiseB(Y,XX), NoiseB(Y,XX+1) ,((X and iAnd) shl iSht) )
      pPix[iPos] += C0 shr (iSht-(7-iLevel))
      iPos += 1
    next X
  next Y
 
next C
 
put(0,0),pNoise,pset
color 255,0
print csng((timer-TMR)*1000);"ms"
 
sleep