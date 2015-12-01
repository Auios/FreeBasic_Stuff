#define fbc -s gui
#include once "windows.bi"
#include once "win\commctrl.bi"
#include once "win\ddraw.bi"

dim shared as hinstance APPINSTANCE  'instance
dim shared as hfont MyFont           'fonts
dim shared as string sAppName,sText  'AppName (window title 'prefix')
dim shared as integer ScrWid,ScrHei,TextX,TextTicks,TextY
dim shared as SIZE TextSz
dim shared as hbrush BackBrush

declare sub WinMain()

dim shared as LPDIRECTDRAW DD7 
dim shared as integer iScan

if DirectDrawCreate(cast(any ptr,DDCREATE_HARDWAREONLY),@DD7,null) <> DD_OK then
  print "ddraw failed...": sleep: end
end if
SetPriorityClass(GetCurrentProcess,IDLE_PRIORITY_CLASS)

sAppName = "GUI Example"
APPINSTANCE = GetModuleHandle(null)
WinMain() '<- main function

function WndProc ( hWnd as HWND, message as UINT, wParam as WPARAM, lParam as LPARAM ) as LRESULT
    
  select case( message )
  case WM_CREATE 'Window was created
    
    '' **** Creating a font ****
    var TempDC = GetDC(0)
    var nHeight = -MulDiv(ScrHei\3, GetDeviceCaps(TempDC, LOGPIXELSY), 72)
    MyFont = CreateFont(nHeight,0,0,0,FW_EXTRABOLD,0,0,0,DEFAULT_CHARSET,0,0,DRAFT_QUALITY,0,"Comic Sans MS")
    
    ' Text ...
    sText = "Hello World!!!, this is a marquee test by MYSOFT, showing" _
    " text with transparent background, please enjoy!!!! ("+date$+")"
    
    ' Get Text Width
    SelectObject(TempDC, MyFont)
    GetTextExtentPoint32(TempDC,sText,len(sText),@TextSz)
    TextTicks = GetTickCount() 'Start from right
    TextX = ScrWid : TextY = (ScrHei-TextSz.cy)\2
    BackBrush = CreateSolidBrush(&h800000)
    
    ReleaseDC(0,TempDC)
    
    'Set Layered attributes in this case i will be setting a "color-key"
    'so that anything draw with that color becomes transparent
    SetLayeredWindowAttributes(hwnd,&hFF00FF,null,LWA_COLORKEY)
    
    ' Timer firing every 30ms
    'SetTimer(hwnd,1,1000\32,NULL)  
  
  case WM_TIMER 'Draw a circle on the Buffer every half second
    if wParam = 1 then 'Our timer?
      TextX = ScrWid-((((GetTickCount()-TextTicks)*ScrWid)\10000) mod (TextSz.cx+ScrWid))
      InvalidateRect(hwnd,null,false) 'Update Window
    end if
  
  case WM_USER        
    'TextX = TextX-4
    TextX = ScrWid-((((GetTickCount()-TextTicks)*ScrWid)\10000) mod (TextSz.cx+ScrWid))
    InvalidateRect(hwnd,null,false) 'Update Window
  case WM_PAINT 'Update the window
    dim as PAINTSTRUCT tPaint
    BeginPaint(hwnd,@tPaint)    
        
    #if 0
    var iScan = 0
    do
      DD7->lpVtbl->GetScanLine(DD7,@iScan)
      'if iScan < TextY or iScan > (TextY+TextSz.cy) then exit do
      if iScan > (TextY+TextSz.cy) then exit do
      SleepEx(0,1): SwitchToThread()      
    loop
    #endif
        
    var hdc = tPaint.hdc    
    Var OldFont = SelectObject(hdc, MyFont)    
    SetBkMode(hdc, TRANSPARENT ) 'Trans Text
    SetTextColor(hdc, &hFF00FF ) 'Transparent
    SetBkColor(hdc, &h800000 ) 'Solid Dark Blue BG
    var iPosX = TextX, pText = strptr(sText)
    dim tTmp as size,iFirst as integer
    
    for CNT as integer = 0 to len(sText)-1
      GetTextExtentPoint32(hdc,pText+CNT,1,@tTmp)
      if (iPosX+tTmp.cx*2) >= 0 then
        if iFirst=0 then
          dim as rect tRect = (0,TextY,ScrWid,TextY+textSz.cy)
          FillRect(hdc,@tRect,BackBrush): iFirst=1
        end if
        TextOut(hdc,iPosX,TextY,pText+CNT,1)
      end if
      iPosX += tTmp.cx
      if iPosX >= ScrWid then exit for
    next CNT    
    SelectObject(hdc,OldFont) 'Restore
    
    static as integer iFPS,iFpsCount
    static as double dTime
    iFpsCount += 1
    if abs(timer-dTime) >= 1 then
      dTime = timer: iFPS = iFpsCount : iFpsCount = 0
    end if
    var sTemp = "fps: " & iFPS & "  "
    SetBkMode(hdc, OPAQUE ) 'Solid Text
    SetTextColor(hdc, &hFFFFFF ) 'White
    TextOut(hdc,4,4,sTemp,len(sTemp))    
    
    EndPaint(hwnd,@tPaint)
        
    PostMessage(hwnd,WM_USER,0,0)
    
  case WM_CLOSE,WM_DESTROY,WM_KEYDOWN 'Windows was closed/destroyed
    PostQuitMessage(0) ' to quit
    return 0
  end select
  
  ' *** if program reach here default predefined action will happen ***
  return DefWindowProc( hWnd, message, wParam, lParam )
    
end function

' *********************************************************************
' *********************** SETUP MAIN WINDOW ***************************
' ******************* This code can be ignored ************************
' *********************************************************************

sub WinMain ()
  
  dim wMsg as MSG
  dim wcls as WNDCLASS
  dim as HWND hWnd  
    
  '' Setup window class  
    
  with wcls
    .style         = CS_HREDRAW or CS_VREDRAW
    .lpfnWndProc   = @WndProc
    .cbClsExtra    = 0
    .cbWndExtra    = 0
    .hInstance     = APPINSTANCE
    .hIcon         = LoadIcon( APPINSTANCE, "FB_PROGRAM_ICON" )
    .hCursor       = LoadCursor( NULL, IDC_ARROW )
    .hbrBackground = CreateSolidBrush( &h800000 )
    .lpszMenuName  = NULL
    .lpszClassName = strptr( sAppName )
  end with
    
  '' Register the window class     
  if( RegisterClass( @wcls ) = FALSE ) then
    MessageBox( null, "Failed to register wcls!", sAppName, MB_ICONERROR )
    exit sub
  end if
    
  '' Create the window and show it
  ' **** USING LAYERED EX STYLE ***
  
  ScrWid = GetSystemMetrics(SM_CXSCREEN)
  ScrHei = GetSystemMetrics(SM_CYSCREEN)  
  
  hWnd = CreateWindowEx(WS_EX_LAYERED or WS_EX_TOPMOST,sAppName,sAppName, _
  WS_VISIBLE or WS_POPUPWINDOW, _
  0,0,ScrWid,ScrHei,null,null,APPINSTANCE,NULL)  
  SetforegroundWindow(hWnd)
    
  '' Process windows messages
  ' *** all messages(events) will be read converted/dispatched here ***
  UpdateWindow( hWnd )
  
  while( GetMessage( @wMsg, NULL, 0, 0 ) <> FALSE )
    TranslateMessage( @wMsg )
    DispatchMessage( @wMsg )
  wend    
  
end sub

