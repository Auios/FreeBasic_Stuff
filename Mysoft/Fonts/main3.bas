#include "windows.bi"
#include "crt.bi"
 
#macro CheckError(CHECKCONS)
if CHECKCONS then
  ShowError()
end if
#endmacro
#macro ShowError ()
  scope
    dim MENSAGEM as zstring * 255
    FormatMessage( FORMAT_MESSAGE_FROM_SYSTEM, null,GetLastError(),null,@MENSAGEM,255,null )
    MENSAGEM += " na linha " & __LINE__
    MessageBox(null,@MENSAGEM,__FILE__,MB_OK or MB_ICONERROR)
  end scope
#endmacro
 
screenres 640,480,32
 
dim as BITMAPINFO tBmp
with tBmp.bmiHeader
  .biSize = sizeof(BitmapInfoHeader)
  .biWidth = 640: .BiHeight = -480: .biBitCount = 32
  .biPlanes = 1: .biCompression = BI_RGB
end with
 
dim as any ptr pScr = screenptr
dim as MEMORY_BASIC_INFORMATION tMem
VirtualQuery(pScr,@tMem,sizeof(tMem))
'print hex(tMem.BaseAddress),hex(tMem.AllocationBase),hex(pScr)
 
scope
  screenlock
  var pTemp = cast(long ptr,pScr)
  for CNT as integer = 0 to 640*480-1 'Put some dirt on screen
    pTemp[CNT] = (rnd*&hFFFFFF) and &h3F3F3F
  next CNT
  screenunlock
end scope
 
dim MyDC as HDC , MyBMP as hBitmap
dim as hFont ComicFont, RomanFont
 
scope
  var TempDC = GetDC(0),iResu=0,MyOff=cuint(pScr)-cuint(tMem.AllocationBase)
  var nHeight = -MulDiv(72, GetDeviceCaps(TempDC, LOGPIXELSY), 72)
  ComicFont = CreateFont(nHeight,0,0,0,FW_BOLD,0,0,0,null,0,0,0,0,"Comic Sans MS")
  nHeight = -MulDiv(32, GetDeviceCaps(TempDC, LOGPIXELSY), 72)
  RomanFont = CreateFont(nHeight,0,0,0,FW_BOLD,0,0,0,null,0,0,0,0,"Times New Roman")
  MyDC = CreateCompatibleDC(TempDC)
 
  screenlock
  var MyMap = CreateFileMapping(cast(any ptr,INVALID_HANDLE_VALUE),NULL, _
  PAGE_READWRITE or SEC_COMMIT,0,tMem.RegionSize,NULL)
  CheckError(MyMap=0)
  var pTemp = allocate(tMem.RegionSize)
  memcpy(pTemp,tMem.AllocationBase,tMem.RegionSize)
  iResu=VirtualFree(tMem.AllocationBase,0,MEM_RELEASE)
  CheckError(iResu=0)
  var pPtr2 = MapViewOfFileEx(MyMap,FILE_MAP_WRITE,0,0,tMem.RegionSize,tMem.AllocationBase)
  CheckError(pPtr2=0)
  memcpy(tMem.AllocationBase,pTemp,tMem.RegionSize)
  deallocate(pTemp): pTemp=0
  MyBMP = CreateDibSection(TempDC,@tBmp,DIB_RGB_COLORS,0,MyMap,MyOff)
  CheckError(MyBMP=0)
  ReleaseDC(0,TempDC)
  screenunlock
 
end scope
 
SelectObject(MyDC,MyBMP)
SetBkMode(MyDC,TRANSPARENT)
SetBkColor(MyDC,&h000000)
 
screenlock
SelectObject(MyDC,RomanFont)
for CNT as integer = 0 to 255
  SetTextColor(MyDC,(rnd*&hFFFFFF) or &h808080)
  TextOut(MyDC,rnd*720-40,rnd*520-20,"Hello!",6)
next CNT
SetTextColor(MyDC,&h000000)
SelectObject(MyDC,ComicFont)
for iY as integer = -4 to 4 step 4
  for iX as integer = -4 to 4 step 4
    TextOut(MyDC,30+iX,168+iY,"Hello World!",12)
  next iX
next iY
SetTextColor(MyDC,&hFFFFFF)
TextOut(MyDC,30,168,"Hello World!",12)
GdiFlush()
screenunlock
 
sleepa