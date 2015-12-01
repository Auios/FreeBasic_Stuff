#include "windows.bi"

dim shared GameBuf as uinteger ptr,GameRect as rect,CurRect as rect
dim shared as hwnd GameWnd,DeskWnd
dim shared as zstring*256 WinTit
dim shared as integer ObjX(64),ObjY(64),ObjC(64),ObjCount,TempCount
dim shared as uinteger iBkColor,iBlack=0,iWhite=&hFFFFFF
dim shared as uinteger iGreen=&h00FF00,iRed=&hFF0000

sub CaptureScreen(OutBuf as any ptr)
  static as hdc GameDC,MyDC,DeskDC
  static as hbitmap MyBMP
  static as BitmapInfo BmpInfo  
  if GameDC = 0 then GameDC = GetDC(GameWnd)
  if MyDC   = 0 then MyDC   = CreateCompatibleDC(GameDC)
  if MyBMP  = 0 then MyBMP  = CreateCompatibleBitmap(GameDC,800,600)  
  SelectObject(MyDC,MyBMP)
  bitblt(MyDC,0,0,800,600,GameDC,0,0,SrcCopy)
  BmpInfo.bmiHeader = type(sizeof(BmpInfo),800,-600,1,32,BI_RGB)  
  if GetDIBits(MyDC,MyBMP,0,600,OutBuf,@BmpInfo,DIB_RGB_COLORS)=0 then end
end sub
sub SetupGameScreen()  
  DeskWnd = GetConsoleWindow()
  SetForegroundWindow(DeskWnd)
  SetForegroundWindow(GameWnd)
  SetWindowPos(GameWnd,HWND_TOPMOST,0,0,0,0,SWP_NOMOVE or SWP_NOSIZE)
  SetWindowPos(DeskWnd,null,0,0,0,0,SWP_NOZORDER or SWP_NOSIZE)
  GetClientRect(GameWnd,@GameRect)
  ClientToScreen(GameWnd,cptr(point ptr,@GameRect)+0)
  ClientToScreen(GameWnd,cptr(point ptr,@GameRect)+1)
  if GameBuf  = 0 then GameBuf  = allocate(800*600*4)  
end sub
function SearchObjects(iStoreEnum as integer=0) as integer
  CaptureScreen(GameBuf)    
  dim iPix as uinteger ptr = GameBuf, iCount as integer = 0  
  iBkColor = GameBuf[800*8+8]  
  for Y as integer = 0 to 599 step 2
    dim as uinteger iColor,iCurLen,iFound
    for X as integer = 0 to 799 step 1
      if iColor andalso *iPix = iColor then
        iCurLen += 1
        if iCurLen > 20 then
          'print hex$(iColor,8),
          if iStoreEnum then
            ObjX(iCount) = X-10: ObjY(iCount) = Y+1: ObjC(iCount) = iColor            
          end if
          iColor=0:iCurLen=0:iFound=1:iCount += 1
          if iCount > 64 then return 0
        end if      
      else
        iColor = 0
        if *iPix <> iBkColor andalso *iPix <> iBlack then
          if (*iPix and &hFF) < &hF8 and (*iPix and &hFF00) < &hF800 then
            if (*iPix and &hFF0000) < &hF80000 then
              iColor = *iPix: iCurLen = 1
            end if
          end if
        end if
      end if
      iPix += 1      
    next X
    if iFound then Y+=2:iPix+=800*3:iFound=0 else iPix += 800
  next Y 
  
  if iStoreEnum then ObjCount = iCount
  return iCount  
end function
function CanAbort() as integer
  if isWindow(GameWND) = 0 then return 1
  if (GetAsyncKeyState(VK_X) shr 31) then return 1
end function

width 40,5: print "Please Open MemoryGame..."
do 'Waiting for MemoryGame to be opened...
  sleep 50,1
  GameWnd = findwindow(null,"MemoryGame v1.0 By Mysoft")  
loop until GameWnd

SetupGameScreen()
do 'Clicking on start until it start...
  GetWindowText(GameWnd,WinTit,255): sleep 100,1
  if instr(1,WinTit,"MemoryGame")=0 then exit do
  if GetForeGroundWindow() <> GameWnd then continue do
  if CanAbort then Goto _DONE_
  SetCursorPos(GameRect.left+360,GameRect.Top+240): sleep 50,1
  mouse_event(MOUSEEVENTF_LEFTDOWN,0,0,0,0): sleep 50,1
  mouse_event(MOUSEEVENTF_LEFTUP,0,0,0,0): sleep 50,1  
loop

do 'waiting for game start confirmation
  sleep 50,1
  GameWnd = findwindow(null,"Level 1  Score: 0  Time: 05:00")
loop until GameWnd
SetupGameScreen()
cls: print "Now starting... press X to stop."
SetPriorityClass(GetCurrentProcess,HIGH_PRIORITY_CLASS)
randomize()

for iLevel as integer = 1 to 23 
  
  locate 2,1,0: print "   Level: ";iLevel
  locate 2,20: print "Complete: 0  "  
  do 'Wait for objects to be shown
    sleep 50,1: if CanAbort then Goto _DONE_
  loop until SearchObjects()
  sleep 100,1: SearchObjects(1)
  do 'Wait for objects to be hidden
    sleep 50,1: if CanAbort then Goto _DONE_
  loop while SearchObjects()  
  var iSort = cint(rnd*(2^24))
  do 'Sort objects found by color
    dim as integer iFound
    for CNT as integer = 0 to ObjCount-2
      if (ObjC(CNT) xor iSort) > (ObjC(CNT+1) xor iSort) then
        swap ObjC(CNT),ObjC(CNT+1): swap ObjX(CNT),ObjX(CNT+1)
        swap ObjY(CNT),ObjY(CNT+1): iFound = 1
      end if
    next CNT
    if iFound = 0 then exit do
  loop  
  for CNT as integer = 0 to ObjCount-1
    do 'Click on each object
      CurRect.left = GameRect.left+ObjX(CNT): CurRect.right = CurRect.left+1
      CurRect.top = GameRect.top+ObjY(CNT): CurRect.bottom = CurRect.top+1
      ClipCursor(@CurRect): SetCursorPos(CurRect.left,CurRect.top)
      mouse_event(MOUSEEVENTF_LEFTDOWN,0,0,0,0): sleep 50,1
      mouse_event(MOUSEEVENTF_LEFTUP,0,0,0,0): sleep 50,1      
      TempCount = SearchObjects() 
      GetWindowText(GameWnd,WinTit,255)
      locate 3,1: print WinTit;
      locate 2,20: print "Complete: " & TempCount & "  "
      if CNT>0 and TempCount = 0 then exit for
      if CanAbort then Goto _DONE_
    loop until TempCount > CNT
  next CNT  
  do 'Wait for next level
    sleep 50,1: if CanAbort then Goto _DONE_
  loop while SearchObjects()  
  
next iLevel

_DONE_: ClipCursor(null)
SetWindowPos(GameWnd,HWND_NOTOPMOST,0,0,0,0,SWP_NOMOVE or SWP_NOSIZE)
locate 4,1:print "finished...";
sleep