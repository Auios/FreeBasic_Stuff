'define fbc -s gui f:\fb15\programas\prontos\rc.rc
#include once "windows.bi"
#include once "win\commctrl.bi"

'*************** Enumerating our control id's ***********
enum WindowControls
  wcMain
  wcListBox
  wcSlider
  wcStaticSlider
  wcStaticMin
  wcEditMin
  wcStaticMax
  wcEditMax
  wcButtonQuit
  wcLast
end enum

dim shared as hwnd CTL(wcLast)       'controls
dim shared as hinstance APPINSTANCE  'instance
dim shared as hfont MyFont           'fonts
dim shared as string sAppName        'AppName (window title 'prefix')
dim shared as zstring ptr zRates(10) = _
{@"32 kbps",@"64 kbps",@"96 kbps",@"128 kbps",@"160 kbps", _
@"192 kbps",@"224 kbps",@"256 kbps",@"288 kbps",@"320 kbps",@"CUSTOM"}
dim shared as zstring ptr zQuality(10) = _
{@"minimum(9)",@"worse(8)",@"bad(7)",@"below(6)",@"average(5)",@"default(4)", _
@"above(3)",@"good(2)",@"excellent(1)",@"maximum(0)",@"CUSTOM"}
dim shared as zstring ptr ptr zArray
dim shared as string sPrefix
dim shared as hBrush HatchBrush

declare sub WinMain()

sAppName = "GUI Example"
InitCommonControls()
APPINSTANCE = GetModuleHandle(null)
WinMain() '<- main function

dim shared as any ptr ButProc

' *************** Procedure Function ****************
' *********** ALL EVENTS WILL HAPPEN HERE ***********


dim shared zHWND as hwnd, zMsg as ulong, zwPar as WPARAM, zlPar as LPARAM

function WndProc ( hWnd as HWND, message as UINT, wParam as WPARAM, lParam as LPARAM ) as LRESULT
    
  'if hwnd = zHWND andalso message = zMsg andalso wParam=zwPar andalso lParam=zlPar then
  '  print zHWND,message,GetMessageTime()
  'end if
  
  select case( message )
  case WM_CREATE 'Window was created
    
    'just a macro to help creating controls
    #define CreateControl( mID , mExStyle , mClass , mCaption , mStyle , mX , mY , mWid , mHei ) CTL(mID) = CreateWindowEx(mExStyle,mClass,mCaption,mStyle,mX,mY,mWid,mHei,hwnd,cast(hmenu,mID),APPINSTANCE,null)
    
    const cStyle = WS_CHILD or WS_VISIBLE
    const cBtnStyle = cStyle 'Standard style for buttons class controls :)
    const cEditStyle = cStyle or ES_NUMBER or ES_RIGHT  'Standard style for edit controls
    const cComboStyle = cStyle or CBS_DROPDOWNLIST or CBS_HASSTRINGS
    const cTrackStyle = cStyle or TBS_AUTOTICKS or TBS_FIXEDLENGTH
    const cStaticStyle = cStyle
    const cSliderText = cStaticStyle or SS_CENTER
    const cStaticEdit = cStaticStyle or SS_RIGHT
    const cExBorder = WS_EX_CLIENTEDGE
    const TRACKBAR = TRACKBAR_CLASS
    
    HatchBrush = CreateHatchBrush(HS_DIAGCROSS , BGR(&h33,&h66,&HFF))
    
    ' **** Creating a Control ****
    CreateControl( wcListBox      , null , "combobox" , "" , cComboStyle , 8 , 8 , 200 , 100 )
    CreateControl( wcStaticSlider , null , "static"   , "" , cSliderText , 8 , 40 , 200 , 16 )
    CreateControl( wcSlider       , null , TRACKBAR   , "" , cTrackStyle , 8 , 56 , 200 , 32 )
    CreateControl( wcStaticMin    , WS_EX_STATICEDGE , "static"   , "Minimum:" , cStaticEdit , 220 , 22 , 80 , 24 )
    CreateControl( wcEditMin,cExBorder   , "edit"     , "32"       , cEditStyle  , 304 , 20 , 48 , 24 )
    CreateControl( wcStaticMax    , null , "static"   , "Maximum:" , cStaticEdit , 220 , 54 , 80 , 24 )
    CreateControl( wcEditMax,cExBorder   , "edit"     , "128"      , cEditStyle  , 304 , 52 , 48 , 24 )
    CreateControl( wcButtonQuit   , null , "button"   , "Quit"     , cBtnStyle   ,   8 ,128 , 80 , 24 )
        
    SendMessage(CTL(wcSlider), TBM_SETRANGE, TRUE, MAKELONG(0,10))
    SendMessage(CTL(wcSlider), TBM_SETPOS, TRUE, 10)
    SendMessage(CTL(wcListBox), CB_ADDSTRING , 0 , cuint(@"Constant Bitrate (CBR)"))
    SendMessage(CTL(wcListBox), CB_ADDSTRING , 0 , cuint(@"Average  Bitrate (ABR)"))
    SendMessage(CTL(wcListBox), CB_ADDSTRING , 0 , cuint(@"Variable Bitrate (VBR)"))
    SendMessage(CTL(wcListBox), CB_SETCURSEL , 2 , 0 )
    PostMessage(hwnd,WM_USER+100,0,0)
    
    ' **** Creating a font ****
    MyFont = CreateFont(-14,0,0,0,FW_NORMAL,0,0,0,DEFAULT_CHARSET,0,0,0,0,"MS Shell Dlg")
    ' **** Setting this font for all controls ****
    for CNT as integer = wcMain to wcLast-1
      SendMessage(CTL(CNT),WM_SETFONT,cast(wparam,MyFont),true)
    next CNT  
    
  case WM_COMMAND 'Event happened to a control (child window)
    select case hiword(wparam)    
    case CBN_SELCHANGE
      PostMessage(hwnd,WM_USER+100,0,0)
    case BN_CLICKED 'button click
      select case lparam
      case CTL(wcButtonQuit)        
        MessageBox(hwnd,":)","Hello, World ",MB_OK or MB_ICONERROR)
        PostQuitMessage(0) 'to quit
      end select
    end select
    
  case WM_CTLCOLORSTATIC,WM_CTLCOLOREDIT
    select case lparam
    case ctl(wcSlider)      
      return cast(LRESULT,HatchBrush)
    case ctl(wcEditMin)      
      SetBkMode(cast(hdc,wparam),Transparent)      
      SetTextColor(cast(hdc,wparam),&hFF8844)
      return cast(LRESULT,GetStockObject(LTGRAY_BRUSH))
    end select
    
  case WM_CLOSE,WM_DESTROY 'Windows was closed/destroyed    
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
  dim wcls as WNDCLASSEX
  dim as HWND hWnd  
    
  '' Setup window class  
    
  with wcls
    .cbSize        = sizeof(WNDCLASSEX)
    .style         = CS_HREDRAW or CS_VREDRAW' or CS_SAVEBITS
    .lpfnWndProc   = @WndProc
    .cbClsExtra    = 0
    .cbWndExtra    = 0
    .hInstance     = APPINSTANCE
    .hIcon         = LoadIcon( APPINSTANCE, "FB_PROGRAM_ICON" )
    .hIconSm       = LoadIcon( APPINSTANCE, "FB_PROGRAM_ICON" )
    .hCursor       = LoadCursor( NULL, IDC_ARROW )
    .hbrBackground = cast(hBrush, COLOR_BTNFACE + 1) 'official hack!
    .lpszMenuName  = NULL
    .lpszClassName = strptr( sAppName )
  end with
    
  '' Register the window class     
  var wATOM = cast(dword,RegisterClassEx( @wcls ))
  if( wATOM = FALSE ) then
    MessageBox( null, "Failed to register wcls!", sAppName, MB_ICONERROR )
    exit sub
  end if
    
  '' Create the window and show it
  hWnd = CreateWindowEx(null,cast(any ptr,wATOM),null, _
  WS_VISIBLE or WS_TILEDWINDOW, _
  CW_USEDEFAULT,CW_USEDEFAULT,400,240,null,null,APPINSTANCE,NULL)  
  SetforegroundWindow(hWnd)
  
  '' Process windows messages
  ' *** all messages(events) will be read converted/dispatched here ***
  UpdateWindow( hWnd )
  while( GetMessage( @wMsg, NULL, 0, 0 ) <> FALSE )
    'zHWND = wMsg.hwnd : zMsg = wMsg.message
    'zwPar = wMsg.wparam : zlPar = wMsg.lparam
    'print zHWND,zMsg,wMsg.time,GetMessageTime()    
    'wMsg.time = rnd*(2^24)
    TranslateMessage( @wMsg )
    DispatchMessage( @wMsg )    
  wend    
  
end sub
