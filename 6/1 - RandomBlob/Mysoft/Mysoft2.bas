#define fbc -gen gcc -O 3
 
#include "crt.bi"
#include "fbgfx.bi"
randomize()
 
' > ============= can uncomment/comment these to have different effects =========== <
 
'#define Unbalanced
'#define SlowAcc
 
const scrwid=800,scrhei=600,scrbpp=8
const RandMaxSz=(1 shl 16)-1
 
screenres scrwid,scrhei,scrbpp,fb.gfx_high_priority
 
#define psetx(X,Y,C) pPix[((Y)*scrwid)+(X)]=C
#define pointx(X,Y) pPix[((Y)*scrwid)+(X)]
 
#if scrbpp=8  
  type pixel as ubyte
  const redDot = 18 'rgbx(200,100,100)
  const greenDot = 19 'rgbx(100,200,100)
  const blueDot = 20 'rgbx(100,100,200)
  const bgClr = 17 'rgbx(200,200,200)
  const bgClr32 = 17 'rgb(200,200,200)
  palette redDot,200,100,100
  palette greenDot,100,200,100
  palette blueDot,100,100,200
  palette bgClr,200,200,200
#elseif scrbpp=16
  type pixel as ushort
  #define rgbx(R,G,B) cast(pixel,(((((R) shl 5)+15) shr 8) shl 11)+(((((G) shl 6)+31) shr 8) shl 5)+((((B) shl 5)+15) shr 8))
  const redDot = rgbx(200,100,100)
  const greenDot = rgbx(100,200,100)
  const blueDot = rgbx(100,100,200)
  const bgClr = rgbx(200,200,200)
  const bgClr32 = rgb(200,200,200)
#elseif scrbpp=32  
  type pixel as ulong
  #define rgbx rgb
  const redDot = rgb(200,100,100)
  const greenDot = rgb(100,200,100)
  const blueDot = rgb(100,100,200)
  const bgClr = rgb(200,200,200)
  const bgClr32 = rgb(200,200,200)
#endif
 
dim shared as pixel ptr pPix
 
dim as integer c,iColor,iSwap,iWa=5000
 
pPix = screenptr
line (0,0)-(scrwid-1,scrhei-1),bgClr32,bf
 
for i as integer = 1 to 9
    c = i 'int(8*rnd+1)    
    select case c
    case 1 to 2 'Red
        psetx(int(scrwid*rnd),int(scrhei*rnd),redDot)
    case 3 to 4 'Green
        psetx(int(scrwid*rnd),int(scrhei*rnd),greenDot)
    case 5 to 9 'Blue
        psetx(int(scrwid*rnd),int(scrhei*rnd),blueDot)
    end select
    'psetx(int(scrwid*rnd),int(scrhei*rnd),int(rnd*255))
next i
 
dim as double TMR = timer, SNC = timer
dim as integer iFPS,N
dim shared as byte iRand(RandMaxSz)
for I as integer = 0 to RandMaxSz
  #ifdef Unbalanced
    iRand(I) = int(rnd*20+1)
  #else
    iRand(I) = int(rnd*4+1)
  #endif
next I
 
var iStartX = 0, iEndX = scrwid-1
var iStartY = 0, iEndY = scrhei-1
var iDirectionXY = 1
do  
  N = int(rnd*RandMaxSz)
   
  screenlock
 
  ' swap between "start to end" .... and .... "end to start"
  swap iStartX,iEndX
  swap iStartY,iEndY
  iDirectionXY = -iDirectionXY
 
   
  for y as integer = iStartY to iEndY step iDirectionXY
    for x as integer = iStartX to iEndX step iDirectionXY
      iColor = pointx(x,y)
      if iColor <> bgClr then        
        N = (N+1) and RandMaxSz
        #ifdef Unbalanced
          c = cint(iRand(N))*iColor shr 6
        #else
          c = iRand(N)
        #endif
        select case c
        case 1: if y>   0       then psetx(x,y-1,iColor)
        case 2: if x<(scrwid-1) then psetx(x+1,y,iColor)
        case 3: if y<(scrhei-1) then psetx(x,y+1,iColor)
        case 4: if x>   0       then psetx(x-1,y,iColor)
        end select
      end if        
    next x
  next y  
 
  #ifdef SlowAcc
    if iWa > 1 then sleep (iWa\100): iWa -= 5
  #endif
  'sleep 1,1
  'screensync
 
  screenunlock
  
  'sleep 1,1
 
  iFPS += 1
  if abs(timer-TMR) > 1 then    
    WindowTitle "Life! (" & iFPS & " fps)"
    iFPS = 0: TMR = timer
  end if
loop until inkey = chr(27)
 
end 0