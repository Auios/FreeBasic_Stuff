#define fbc -s gui -gen gcc -O 3 -asm intel

#include "crt.bi"
#include "fbgfx.bi"
#include "windows.bi"

dim shared as any ptr pCondGlobal,pMutexRnd
dim shared as integer iCondFinish,iThreads
type IterationStruct
  pMutexStart as any ptr   
  pMutexDone  as any ptr  
  pCondDone   as any ptr
  pThread     as any ptr
  iStartX     as integer
  iStartY     as integer
  iEndX       as integer
  iEndY       as integer
end type
declare sub IterationWork(pIteration as any ptr)

randomize(,3)

' > ============= can uncomment/comment these to have different effects =========== <

'#define Unbalanced
'#define SlowAcc

const scrbpp=8,zoom=1
dim shared as integer scrwid=1280,scrhei=1024
const RandMaxSz=(1 shl 19)-1 '!! (1 shl x) > (scrwid*srchei) !!

screeninfo scrwid,scrhei
screenres scrwid,scrhei,scrbpp,,fb.gfx_high_priority or fb.gfx_shaped_window or fb.gfx_always_on_top

#define psetx(X,Y,C) pPix[((Y)*scrwid)+(X)]=C
#define pointx(X,Y) pPix[((Y)*scrwid)+(X)]

#if scrbpp=8  
  type pixel as ubyte
  const redDot = 17 'rgbx(200,100,100)
  const greenDot = 18 'rgbx(100,200,100)
  const blueDot = 19 'rgbx(100,100,200)
  const blankDot = 20 'rgbx(0,0,0)
  const bgClr = 16 'rgbx(200,200,200)
  const bgClr32 = 16 'rgb(200,200,200)
  palette redDot,200,100,100
  palette greenDot,100,200,100
  palette blueDot,100,100,200
  palette blankDot,0,0,0
  palette bgClr,48,48,48
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


dim shared as pixel ptr pPix,pDither

scope 'Dither ON
  dim as integer TABLE(63) = { _
  01,49,13,61,04,52,16,64, _
  33,17,45,29,36,20,48,32, _
  09,57,05,53,12,60,08,56, _
  41,25,37,21,44,28,40,24, _
  03,51,15,63,02,50,14,62, _
  35,19,47,31,34,18,46,30, _
  11,59,07,55,10,58,06,54, _
  43,27,39,23,42,26,38,22 }
  var iBg = point(0,0): sleep 500,1
  var pTemp = cast(fb.image ptr,ImageCreate(8,8))
  pTemp->Pitch = pTemp->Width*pTemp->Bpp: 
  pDither = cast(pixel ptr,pTemp+1)
  for CNT as integer = 0 to 64
    for I as integer = 0 to 63
      pDither[I] = iif(CNT >= TABLE(I),bgClr,iBg)
    next I
    screenlock
    for Y as integer = 0 to ScrHei-7 step 8
      for X as integer = 0 to ScrWid-7 step 8
        put(X,Y),pTemp,pset
      next X
    next Y    
    screenunlock
    sleep 30,1
  next CNT
  sleep 500,1
end scope    

dim as integer c,iSum,iColor,iSwap,iWa=5000

pPix = screenptr
line (0,0)-(scrwid-1,scrhei-1),bgClr32,bf

for i as integer = 1 to 60
    c = i mod 13 'int(8*rnd+1)    
    select case c
    case 1 to 2 'Red
        psetx(int(scrwid*rnd),int(scrhei*rnd),redDot)
    case 3 to 4 'Green
        psetx(int(scrwid*rnd),int(scrhei*rnd),greenDot)
    case 5 to 6 'blue
        psetx(int(scrwid*rnd),int(scrhei*rnd),blueDot)
    case 0,7 to 12 'Blue
        psetx(int(scrwid*rnd),int(scrhei*rnd),blankDot)
    end select
    'psetx(int(scrwid*rnd),int(scrhei*rnd),int(rnd*255))
next i

dim as double TMR = timer, SNC = timer
dim as integer iFPS,N,iNewFPS
dim shared as byte iRand(RandMaxSz)
for I as integer = 0 to RandMaxSz
  #ifdef Unbalanced
    iRand(I) = int(rnd*20+1)
  #else
    iRand(I) = int(rnd*4+1)
  #endif
next I

' ******** Creating Work Threads ********
iThreads = valint(environ("NUMBER_OF_PROCESSORS"))
if iThreads < 1 then iThreads = 3
pCondGlobal = CondCreate():pMutexRnd = MutexCreate()
dim as IterationStruct tCore(iThreads)
for I as integer = 0 to iThreads-1
  with tCore(I)
    .pMutexStart = MutexCreate()    
    .pMutexDone = MutexCreate()
    .pCondDone = CondCreate()
    .iStartX = 1: .iEndX = scrwid-2
    .iStartY = (scrhei\iThreads)*I
    .iEndY = .iStartY+((scrhei\iThreads)-1)
    if I=0 then .iStartY = 1 
    if I=(iThreads-1) then .iEndY = scrhei-2
    mutexlock(.pMutexDone)
    .pThread = ThreadCreate(@IterationWork,@tCore(I))  
    CondWait(.pCondDone,.pMutexDone)
  end with
next I

do  
    
  screenlock
  
  ' swap between "start to end" .... and .... "end to start"
  for iRep as integer = -1 to iWa>500
    
    for CNT as integer = 0 to iThreads-1
      mutexlock(tCore(CNT).pMutexStart)
    next CNT
    CondBroadCast(pCondGlobal)
    for CNT as integer = 0 to iThreads-1
      mutexunlock(tCore(CNT).pMutexStart)
    next CNT    
    for CNT as integer = 0 to iThreads-1
      CondWait(tCore(CNT).pCondDone,tCore(CNT).pMutexDone)    
    next CNT
    
  next iRep
  
  if iNewFps then
    circle(ScrWid-52,28),48,bgClr32,,,.5,f  
    draw string (ScrWid-88,24),iThreads & " Fps: " & iNewFPS,15
  end if
  
  screenunlock
  
  #ifdef SlowAcc
    if iWa > 1 then sleep (iWa\100): iWa -= 5
  #endif
  sleep 1,1
  'screensync
  
  iFPS += 1
  if abs(timer-TMR) > 1 then    
    iNewFps=iif(iWa>500,iFps,iFps*2): iFPS = 0: TMR = timer
    WindowTitle "Life! (" & iNewFPS & " fps) " & iThreads
  end if
  
loop until inkey = chr(27)

iCondFinish = 1
CondBroadCast(pCondGlobal)
for CNT as integer = 0 to 3
  ThreadWait(tCore(CNT).pThread)
next CNT

end 0

sub IterationWork(pIteration as any ptr)
  with *cptr(IterationStruct ptr,pIteration)    
    mutexlock(.pMutexStart)
    dim as integer iStartX = .iStartX
    dim as integer iEndX   = .iEndX
    dim as integer iStartY = .iStartY
    dim as integer iEndY   = .iEndY
    dim as integer iDirectionXY = 1    
    var pPix = ..pPix 'make a local copy
    var scrwid = ..scrwid
    var pMutexDone = .pMutexDone
    var pCondDone = .pCondDone
    var pMutexStart = .pMutexStart
    
  do
    
    mutexlock(pMutexDone)
    CondSignal(pCondDone)
    mutexunlock(pMutexDone)
    CondWait(pCondGlobal, pMutexStart)
    if iCondFinish then exit do
    
    mutexlock(pMutexRnd)
    var N = cint(int(rnd*RandMaxSz))
    mutexunlock(pMutexRnd)
    swap iStartX,iEndX : swap iStartY,iEndY
    iDirectionXY = -iDirectionXY    
      
    for y as integer = iStartY to iEndY step iDirectionXY      
      for x as integer = iStartX to iEndX step iDirectionXY
        dim as pixel iColor = pointx(x,y)
        if iColor <> bgClr then        
          N = (N+1) and RandMaxSz
          #ifdef Unbalanced
          dim as integer c = cint(iRand(N))*iColor shr 6
          #else
          dim as integer c = iRand(N)
          #endif
          select case c
          case 1: psetx(x,y-1,iColor)
          case 2: psetx(x+1,y,iColor)
          case 3: psetx(x,y+1,iColor)
          case 4: psetx(x-1,y,iColor)
          end select
        end if        
      next x
    next y
    
  loop
  end with
  
  with *cptr(IterationStruct ptr,pIteration)
    mutexunlock(.pMutexStart): mutexdestroy(.pMutexStart): .pMutexStart = 0
    mutexunlock(.pMutexDone): mutexdestroy(.pMutexDone): .pMutexDone = 0    
    CondDestroy(.pCondDone): .pCondDone = 0    
  end with
    
 
end sub
      