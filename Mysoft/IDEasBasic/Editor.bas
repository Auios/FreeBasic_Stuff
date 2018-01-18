#define fbc -gen gcc -O 3 -s gui Res\Editor.rc
'-exx

#include once "windows.bi"
#include once "win\commctrl.bi"
#include once "win\commdlg.bi"
#undef WHILE
#undef WEND
#define WHILE rem
#define WEND rem
'#define UseHX

type Config_Struct      ' Estrutura de configuração
  SYNTAXCOLORS as byte
  TABSPACES as byte
  IDENTTABS as byte
end type

while                '' declarações de macros
  ''
  '' definições
  ''
  #define SecTab 11
  #define Tabu 9
  #define Ponto 46
  #define Underline 95
  #define Aspas 34
  #define Espaco 32
  #define LetraA 97
  #define LetraZ 122
  #define Sharp 35        
  #define Apostrofo 39
  #define PontoVirgula 59
  #define GetWord(GID) strptr(LANGWORD(GID))
  #define Control (GetKeyState(VK_CONTROL) and 128)
  #define Shift (GetKeyState(VK_SHIFT) and 128)
  #define FontSize(PIXELPNT) (-MulDiv(PIXELPNT, GetDeviceCaps(MAINDC, LOGPIXELSY), 72))
  #define FontName "Courier New"
  
  #define MyDebug
  ''
  '' criar retas
  ''
  #macro MakeRect(RCT,X,Y,XX,YY)
  with RCT
    .left = X
    .top = Y
    .right = XX
    .bottom = YY
  end with
  #endmacro
  ''
  '' adicionar cores
  ''
  #macro AddColor(CNAME,RR,GG,BB)
  dim shared as uinteger CNAME
  CNAME = rgba(BB,GG,RR,0)
  #endmacro
  ''
  '' Cria fonte
  '' 
  #macro AddFont(FONTHD,FONTSZ,FONTWID,FONTITA,FONTNAME)
  FONTE(FONTHD) = CreateFont(FontSize((FONTSZ)),0,0,0,(FONTWID),(FONTITA),0,0,DEFAULT_CHARSET,0,0,0,0,FONTNAME)
  CheckError(FONTE(FONTHD)=0)
  WIDCHAR(FONTHD,-1) = -Fontsize(FONTSZ)
  dim as hfont OLDFONT
  MAINDC = GetDC(HCTL(CTL_MAIN))
  OLDFONT = SelectObject(MAINDC,FONTE(FONTHD))
  GetCharWidth32(MAINDC,0,255,@WIDCHAR(FONTHD,0))
  SelectObject(MAINDC,OLDFONT)
  ReleaseDC(HCTL(CTL_MAIN),MAINDC)
  #endmacro
  ''
  '' Cria Fonte de tamanho fixo
  ''
  #macro AddFixedFont(FONTHD,FONTSZ,FONTWID,FONTITA,FONTNAME)
  if FONTE(FONTHD) then DeleteObject(FONTE(FONTHD))
  MAINDC = GetDC(HCTL(CTL_MAIN))
  FONTE(FONTHD) = CreateFont(FontSize((FONTSZ)),0,0,0,(FONTWID),(FONTITA),0,0,DEFAULT_CHARSET,0,0,0,FIXED_PITCH,FONTNAME)
  CheckError(FONTE(FONTHD)=0)
  scope
    dim as hfont OLDFONT
    dim as textmetric MYTM
    dim as zstring*255 FNAME    
    OLDFONT = SelectObject(MAINDC,FONTE(FONTHD))
    GetCharWidth32(MAINDC,0,255,@WIDCHAR(FONTHD,0))
    GetTextMetrics(MAINDC,@MYTM)
    WIDCHAR(FONTHD,-1) = (MYTM.tmHeight-MYTM.tmInternalLeading)+2
    WIDCHAR(FONTHD,255) = MYTM.tmAveCharWidth
    if WIDCHAR(FONTHD,255) > FSX then FSX = WIDCHAR(FONTHD,255)
    if WIDCHAR(FONTHD,-1) > FSY then FSY = WIDCHAR(FONTHD,-1)
    GetTextFace(MAINDC,254,@FNAME)
    print "Fonte: ";FNAME,FONTSZ;MYTM.tmHeight;WIDCHAR(FONTHD,-1)
    SelectObject(MAINDC,OLDFONT)
    ReleaseDC(HCTL(CTL_MAIN),MAINDC)
  end scope      
  #endmacro
wend  
while                '' Includes do editor
  #ifdef MyDebug
  #include once "MyTdt\debug.inc"
  #endif
  #include once "MyTdt\clipboard.bas"
wend
while                '' declarações de subrotina
  declare function WndProc ( HWND as hwnd, MESSAGE as uint, WPARAM as wparam,LPARAM as lparam) as lresult
  declare function AreaProc ( HWND as hwnd, MESSAGE as uint, WPARAM as wparam,LPARAM as lparam) as lresult
  declare function GetTextWidth(FONTH as integer,TEXT as string) as integer
  declare sub InicioJanela()
  declare sub UpdateForm(DCDC as hdc)
  declare sub UpdateEditor(DCDC as hdc)
  declare sub ArrangeSelection(byref SEX as integer,byref SEY as integer,byref SEXX as integer,byref SEYY as integer)
wend
while                '' enumeração das cores
  AddColor(C_FUNDO,255,255,255)
  AddColor(C_TEXTO,0,0,0)  
  AddColor(C_SHADOW,128,128,128)
  AddColor(C_IDENTY,190,200,210)
  AddColor(C_COMMENT,128,0,0)
  AddColor(C_COMMENTBK,220,240,255)
  AddColor(C_PREPROC,64,128,128)
  AddColor(C_ASPAS,255,0,0)
  AddColor(C_ASPASPAR,221,111,0)
  AddColor(C_OPERADOR,0,128,192)  
  AddColor(C_NUMERO,0,0,255)
  AddColor(C_SELEC,255,255,255)
  AddColor(C_SELECBK,192,192,192)
  dim shared as uinteger C_GROUP(4)
  C_GROUP(1) = rgba(0,0,0,0)
  C_GROUP(2) = rgba(255,0,0,0)
  C_GROUP(3) = rgba(192,128,0,0)
  C_GROUP(4) = rgba(64,0,128,0)
wend
enum AppWindows      '' enumerações dos controles/janelas
  CTL_MAIN = 0  
  CTL_MDIMAIN
  CTL_STATUSBAR
  CTL_EDITAREA
  CTL_BUTTON
  CTL_IMGBUTTON
  CTL_EDIT
  CTL_COMBO
  CTL_LIST
  CTL_STATIC
  CTL_SCROLL
  CTL_FIM
end enum
enum AppFonts        '' enumeração das fontes
  AF_DEFAULT = 0
  AF_TEXT
  AF_TEXTBOLD
  AF_TEXTITALIC
  AF_GROUPS
  AF_ASPAS
  AF_OPERADORES
  AF_COMMENT
  AF_FIM
end enum
enum AppMenus        '' enumeração dos menus
  AM_MAIN = 0
  AM_ARQUIVO
  AM_JANELAS
  AM_FIM
end enum
enum AppCursors      '' enumeração dos cursores
  CU_ARROW = 0
  CU_TEXT
  CU_FIM
end enum
while AppWords       '' enumeração do idioma
  #define MakeLang
  #include "Idioma.bas"
wend 
enum TokenTypes      '' enumeração dos tipos de token
  TT_NORMAL = 0
  TT_TOKEN
  TT_COMMENT
  TT_STRING
  TT_PREPROC
  TT_ASPASPAR
  TT_ASPAS
  TT_OPERADOR
  TT_NUMERO
end enum
enum IdentTypes
  IT_OPEN = 1
  IT_CLOSE = 2
  IT_HAVEEND = 4
  IT_SECOND = 8
  IT_LAST = 16
  IT_SINGLE = 32
  IT_RECURSE = 64
end enum
while                '' Declarações de variaveis
  
  '' handles e afins
  dim shared as Hinstance MYAPP
  dim shared as hbitmap MYBMP,DCBMP
  dim shared as hbrush DOTBRUSH
  dim shared as hpen DOTPEN,DOTPEN2
  dim shared as hdc DCDC, MAINDC
  dim shared as rect MAINRCT,DSKRCT
  dim shared as hwnd DSKWND
  '' enumerações
  dim shared as hwnd hCtl(CTL_FIM)
  dim shared as hfont FONTE(AF_FIM)
  dim shared as hcursor CURSOR(CU_FIM)
  dim shared as hmenu MENUS(AM_FIM)
  dim shared as integer WIDCHAR(AF_FIM,-1 to 255)
  dim shared as ushort DOTBMP(7) = {127,255,255,255,255,255,255,255}
  '' referentes ao aplicativo
  dim shared as string APPNAME
  '' dados de controle do editor
  dim shared as Config_struct CFG
  dim shared as integer FONTTAM,FSX,FSY,MAXDOCS
  dim shared as integer ISCARET,CARETX,CARETY,BORX,BIGLIN
  dim shared as integer SCRX,SCRY,SELX,SELY,SELXX,SELYY,ISSEL
  dim shared as integer EDATULIN,EDCURPOS,EDMAXLINES,KBDSPD
  '' vetores do editor
  #define EDELIN(MAXLI) EDLIN(MAXDOCS,MAXLI)
  redim shared as string EDELIN(256)
  dim shared as string EDWORD(31,255)
  dim shared as zstring*16 ID(255)
  dim shared as ubyte EDWDATA(31,255),IDF(255),IDC(255)
  
wend
while                '' Carregando Palavras reservadas
  scope
    dim as string SFILE,SWORD,FLG(7)
    dim as integer FIHAN,KGROUP,WLET
    dim as integer WIDX,CNT
    SFILE = exepath+"\Config\Ident.txt"
    #ifdef MyDebug
    print "Carregando Palavras Reservadas: "+SFILE
    CheckErrorEx( dir$(SFILE)="" , "Arquivo não encontrado: " + SFILE )
    #endif
    FIHAN = freefile()
    open SFILE for input as #FIHAN
    do               '' Palavras que aumentam identação
      if eof(FIHAN) then exit do
      input #FIHAN,SWORD
      SWORD = trim$(SWORD)
      if SWORD <> "" then
        if SWORD[0] <> PONTOVIRGULA then
          IDC(0) += 1          
          ID(IDC(0)) = lcase$(SWORD) ' nome
          CNT = instr(1,ID(IDC(0))," ")
          if CNT then ID(IDC(0))[CNT-1] = 0
          for CNT = 0 to 6  '' setando flags
            input #FIHAN,FLG(CNT)
            FLG(CNT) = trim$(FLG(CNT))
            if (FLG(CNT)[0] and 2) = 0 then IDF(IDC(0)) or= (1 shl CNT)
          next CNT
          
          #ifdef MyDebug
          #define F(x) (IDF(IDC(0)) and (1 shl (x)))<>0;" "
          print ">";ID(IDC(0));"<", F(0); F(1); F(2); F(3); F(4); F(5); F(6)
          #endif
          
        end if
      end if      
    loop    
    
    for KGROUP = 1 to 4
      SFILE = exepath+"\Config\G"+chr$(48+KGROUP)+".txt"
      #ifdef MyDebug
      print "Carregando Palavras Reservadas: "+SFILE
      CheckErrorEx( dir$(SFILE)="" , "Arquivo não encontrado: " + SFILE )
      #endif
      FIHAN = freefile()
      open SFILE for input as #FIHAN
      do
        if eof(FIHAN) then exit do
        input #FIHAN,SWORD
        SWORD = trim$(SWORD)
        if SWORD <> "" then
          WLET = (SWORD[0] and 31)
          EDWDATA(WLET,0) += 1          
          EDWDATA(WLET,EDWDATA(WLET,0)) = KGROUP
          EDWORD(WLET,EDWDATA(WLET,0)) = SWORD
        end if
      loop
      close #FIHAN
      
    next KGROUP
    
    
  end scope
wend
while                '' Preparação da janela principal
  
  InitCommonControls()
  width 120,60
  
  CFG.SYNTAXCOLORS = True
  CFG.TABSPACES = 4
  CFG.IDENTTABS = True
  
  FONTTAM = 12
  EDCURPOS = 1
  EDATULIN = 1
  EDMAXLINES = 0
  
  scope              '' Titulo da janela
    dim as hwnd TMP
    SetConsoleTitle("IDEas Basic - Console")
    TMP = FindWindow(null,"IDEas Basic - Console")
    SetWindowPos(TMP,null,25,0,0,0,SWP_NOSIZE or SWP_NOZORDER)
  end scope  
  scope              '' Carregando arquivo
    dim as integer MYFI,POSI,POSIS
    dim as string TMP,SFILE
    MYFI = freefile()
    SFILE = command$
    if len(SFILE)=0 then SFILE = exepath+"\Editor.bas"
    open SFILE for input as #MYFI
    do
      if eof(MYFI) then exit do
      EDMAXLINES += 1
      if EDMAXLINES > ubound(EDLIN) then redim preserve EDELIN(EDMAXLINES+256)
      line input #MYFI,TMP
      TMP = rtrim$(TMP)
      for CNT as integer = 0 to len(TMP)-1
        if TMP[CNT] = 11 then TMP[CNT] = 14
      next CNT
      POSI = 1
      do 
        POSI = instr(POSI,TMP,chr$(Tabu))
        if POSI = 0 then exit do
        POSIS = CFG.TABSPACES-((POSI-1) mod CFG.TABSPACES)
        TMP = left$(TMP,POSI)+string$(POSIS-1,11)+ mid$(TMP,POSI+1)
        POSI += POSIS        
      loop
      EDLIN(0,EDMAXLINES) = TMP
      if len(EDLIN(0,EDMAXLINES)) > BIGLIN then
        BIGLIN = len(EDLIN(0,EDMAXLINES))
      end if
    loop
    close #MYFI
  end scope
  
  DSKWND = GetDesktopWindow()
  GetClientRect(DSKWND,@DSKRCT)
  MYAPP = GetModuleHandle(null)
  APPNAME = "IDEas BASIC v1.0"
  
  CURSOR(CU_ARROW) = LoadCursor( NULL, IDC_ARROW )
  CURSOR(CU_TEXT) = LoadCursor( NULL, IDC_IBEAM )  
  SystemParametersInfo(SPI_GETKEYBOARDSPEED,null,@KBDSPD,null)
  
  cls
  
  InicioJanela()
  
wend

' ***************************** Gerando Classes e Janelas ***********************************
sub InicioJanela() 
  
  dim wMsg as MSG
  dim wcls as WNDCLASS     
  
  with wcls                                 '' Dados da classe
    .style         = CS_HREDRAW or CS_VREDRAW
    .lpfnWndProc   = @WndProc
    .cbClsExtra    = 0
    .cbWndExtra    = 0
    .hInstance     = MYAPP
    .hIcon         = LoadIcon( MYAPP, "FB_PROGRAM_ICON" )
    .hCursor       = CURSOR(CU_ARROW)
    .hbrBackground = null 'cast(hBrush, COLOR_BACKGROUND + 1)
    .lpszMenuName  = null
    .lpszClassName = strptr( APPNAME )
  end with  
  ''
  '' Registrando Classe
  ''
  CheckError( RegisterClass( @wcls ) = null )
  
  with wcls                                 '' Dados da classe
    .style         = CS_HREDRAW or CS_VREDRAW
    .lpfnWndProc   = @AreaProc
    .hbrBackground = null 'cast(hBrush, COLOR_BTNFACE + 1)
    .hIcon = LoadIcon( MYAPP, "NOVODOC" )
    .lpszClassName = @"IBEditArea"
    .hCursor       = CURSOR(CU_TEXT)
  end with  
  
  ''
  '' Registrando Classe
  ''
  CheckError( RegisterClass( @wcls ) = null )
  
  ''
  '' Criando Menus
  ''
  MENUS(AM_MAIN) = CreateMenu()
  MENUS(AM_ARQUIVO) = CreateMenu()
  MENUS(AM_JANELAS) = CreateMenu()
  AppendMenu(MENUS(AM_MAIN),MF_POPUP,cast(uinteger,MENUS(AM_ARQUIVO)),GetWord(LW_MENUARQUIVO))
  ::AppendMenu(MENUS(AM_ARQUIVO),MF_STRING,101,GetWord(LW_ARQABRIR))
  ::AppendMenu(MENUS(AM_ARQUIVO),MF_STRING,102,GetWord(LW_ARQSAIR))
  AppendMenu(MENUS(AM_MAIN),MF_POPUP,cast(uinteger,MENUS(AM_JANELAS)),GetWord(LW_MENUJANELAS))
  ::AppendMenu(MENUS(AM_JANELAS),MF_STRING,201,GetWord(LW_JANFECHATUDO))
  
  ''
  '' Criando e exibindo a janela principal
  '' 
  dim as integer STMAIN
  STMAIN = WS_VISIBLE or WS_CLIPCHILDREN or WS_CLIPSIBLINGS or WS_TILEDWINDOW
  
  CreateWindowEx(null,APPNAME,APPNAME,STMAIN,0,0,640,480,NULL,MENUS(AM_MAIN),MYAPP,NULL)
  
  ShowWindow( hctl(CTL_MAIN), SW_SHOW )
  UpdateWindow( hctl(CTL_MAIN) )
  
  ''
  '' Teclas de atalho
  ''
  #if 0
  with MYACCELERATOR(0)
    .fVirt = FCONTROL or FALT or FVIRTKEY
    .key = 65 'VK_A
    .cmd = 1
  end with
  with MYACCELERATOR(1)
    .fvirt = FSHIFT or FALT  or FVIRTKEY
    .key = 66 'VK_B
    .cmd = 2
  end with
  MYACCHANDLE = CreateAcceleratorTable(@MYACCELERATOR(0),2)
  #endif
  
  ''
  '' Processando Mensagens das janelas do aplicativo
  ''
  do until ( GetMessage( @wMsg, NULL, 0, 0 ) = FALSE )
    'if TranslateAccelerator( hWnd, MYACCHANDLE, @wMsg ) = 0 then
    TranslateMessage( @wMsg )
    DispatchMessage( @wMsg )
    'end if
  loop
  
  ''
  '' O programa Terminou
  ''
  
end sub
' ******************** Função que controla a janela principal do programa *******************
function wndProc ( HWND as hwnd, MESSAGE as uint, WPARAM as wparam,LPARAM as lparam) as lresult
  
  static as integer CONT
  static as RECT RCT  
  static as zstring*256 TMPTXT
  
  select case( message )
  
  case WM_CREATE                         '' Criação da janela
    
    hCtl(CTL_MAIN) = hwnd
    
    while                    '' Criando Imagem de fundo
      MYBMP = LoadBitmap(MYAPP,"TSTBMP")
      'CheckError(MYBMP=0)    
      DOTBRUSH = CreatePatternBrush(CreateBitmap(8,8,1,1,@DOTBMP(0)))    
      CheckError(DOTBRUSH=0)
      MAINDC = GetDC(hwnd)
      DCDC = CreateCompatibleDC(MAINDC)      
      DCBMP = CreateCompatibleBitmap(MAINDC, DSKRCT.right-DSKRCT.left,DSKRCT.bottom-DSKRCT.top)
      SelectObject(DCDC,DCBMP)
      ReleaseDC(hwnd,MAINDC)
    wend
    while                    '' Criando Fontes
      
      AddFont(AF_DEFAULT,8,FW_NORMAL,false,"MS Sans Serif")
      AddFixedFont(AF_TEXT,FONTTAM,FW_NORMAL,false,FontName)      
      AddFixedFont(AF_GROUPS,FONTTAM,FW_BOLD,false,FontName)
      AddFixedFont(AF_ASPAS,FONTTAM,FW_BOLD,false,FontName)
      AddFixedFont(AF_OPERADORES,FONTTAM,FW_BOLD,false,FontName)
      AddFixedFont(AF_COMMENT,FONTTAM,FW_NORMAL,True,FontName)
      'AddFixedFont(AF_TEXTBOLD,FontSize,FW_NORMAL,false,FontName)
      'AddFixedFont(AF_TEXTITALIC,FontSize,FW_NORMAL,true,FontName)
      
      'while        '' janela de seleção de fonte
      '  dim as CHOOSEFONT MYSELF
      '  dim as logfont INIFNT
      '  
      '  with INIFNT
      '    .lfHeight = FontSize(12)
      '    .lfWeight = FW_NORMAL
      '    .lfPitchAndFamily = FIXED_PITCH
      '    .lfFaceName = "Courier New"
      '  end with
      '  
      '  with MYSELF
      '    .lStructSize = sizeof(choosefont)
      '    .hwndOwner = hwnd
      '    .hdc = MAINDC
      '    .lpLogFont = @INIFNT
      '    .iPointSize = 5
      '    .flags = CF_BOTH or CF_INITTOLOGFONTSTRUCT or CF_FIXEDPITCHONLY or CF_LIMITSIZE
      '    .rgbColors = rgba(0,0,0,0)
      '    .nSizeMin = 5
      '    .nSizeMax = 20
      '  end with
      '  
      '  'if ChooseFont(@MYSELF) then
      '  '  FONTE(AF_TEXT) = CreateFontIndirect(@INIFNT)
      '  'end if
      '  CheckError(FONTE(AF_TEXT)=0)
      '  
      'wend
      
    wend
    while                    '' Criando Janelas Especiais
      
      #define NewChild(WCLASS,WSTYLE) CreateWindow(WCLASS,"",WS_CHILD or (WSTYLE),-9999,-9999,32,32,hwnd,0,MYAPP,null)
      #define NewChildEx(WCLASS,WSTYLE,WX,WY,WWID,WHEI)
      
      HCTL(CTL_BUTTON) = NewChild("button",null)
      HCTL(CTL_IMGBUTTON) = NewChild("button",WS_VISIBLE or BS_BITMAP)
      HCTL(CTL_EDIT) = NewChild("edit",WS_BORDER)
      HCTL(CTL_COMBO) = NewChild("combobox",CBS_DROPDOWN or WS_VISIBLE)
      HCTL(CTL_LIST) = NewChild("listbox",LBS_DISABLENOSCROLL or WS_VSCROLL or WS_BORDER or LBS_NOINTEGRALHEIGHT)    
      HCTL(CTL_STATIC) = NewChild("static",SS_CENTERIMAGE or SS_BITMAP or WS_VISIBLE)
      HCTL(CTL_SCROLL) = NewChild("scrollbar",SBS_VERT)
      
      HCTL(CTL_STATUSBAR) = CreateStatusWindow(WS_CHILD or WS_VISIBLE,GetWord(LW_PRONTO),hwnd,1)
      
    wend
    while                    '' Criando uma janela MDI
      dim as integer STMAIN
      dim as ClientCreateStruct MYCCS
      dim as integer MAIX,MAIY
      STMAIN = WS_VISIBLE or WS_VSCROLL or WS_HSCROLL or WS_CHILD 
      with MYCCS
        .hWindowMenu = MENUS(AM_JANELAS)
        .idFirstChild = 1
      end with    
      GetClientRect(hwnd,@RCT)
      MAIX = RCT.right:MAIY = RCT.bottom
      SendMessage(HCTL(CTL_STATUSBAR),SB_GETRECT,null,cast(lparam,@RCT))
      MAIY -= ((RCT.bottom-RCT.top)+1)
      HCTL(CTL_MDIMAIN) = CreateWindow("MDICLIENT","Freebasic", WS_CHILD or WS_CLIPCHILDREN or WS_VISIBLE,0,0,MAIX,MAIY,hwnd,null,MYAPP,@MYCCS)    
      CheckError( HCTL(CTL_MDIMAIN) = 0 )
      
      'dim as hwnd TST
      'TST = CreateWindow("MDICLIENT","Freebasic", WS_CHILD or WS_CLIPCHILDREN or WS_VISIBLE,0,0,MAIX,MAIY,hwnd,null,MYAPP,@MYCCS)    
      'CheckError( TST = 0 )
      
      dim as integer SBPR(1) = {MAIX-(MAIX/4),-1}
      SendMessage(HCTL(CTL_STATUSBAR),SB_SETPARTS,2,cast(lparam,@SBPR(0)))
    wend
    while                    '' Criando MDI filhas
      HCTL(CTL_EDITAREA) = CreateWindowEx(WS_EX_MDICHILD,"IBEditArea","Default.bas",STMAIN,0,0,640,480,HCTL(CTL_MDIMAIN),NULL,MYAPP,NULL)    
      CheckError( HCTL(CTL_EDITAREA) = 0 )
    wend    
    while                    '' Setando Formatos inicais
      for COUNT as integer = 1 to CTL_FIM
        if HCTL(COUNT) then 
          SendMessage(HCTL(COUNT),WM_SETFONT,cast(wparam,FONTE(AF_DEFAULT)),false)
        end if
      next COUNT
      
      ShowWindow(HCTL(CTL_EDITAREA),SW_MAXIMIZE)
      #ifndef UseHX
      EnableScrollBar(hctl(CTL_EDITAREA),SB_BOTH,ESB_DISABLE_BOTH)
      #endif
      
      GetWindowRect(hwnd,@RCT)
      MAIX = RCT.right-RCT.left
      MAIY = RCT.bottom-RCT.top
      SetWindowPos(hwnd,null,(DSKRCT.right-MAIX)/2, _
      (DSKRCT.bottom-MAIY)/2,null,null, SWP_NOSIZE or SWP_NOZORDER)
      
      #ifdef FORM_EDIT
      SetTimer(hwnd,cast(integer,hwnd),250,null)
      #endif
    wend
    
  case WM_SIZE,WM_SIZING
    scope
      dim as integer MAIX,MAIY
      ''
      '' atualizando tamanho da barra de status e da MDI
      ''
      SendMessage(HCTL(CTL_STATUSBAR),WM_SIZE,0,0)
      GetClientRect(hwnd,@RCT)
      MAIX = RCT.right:MAIY = RCT.bottom
      SendMessage(HCTL(CTL_STATUSBAR),SB_GETRECT,null,cast(lparam,@RCT))
      MAIY -= ((RCT.bottom-RCT.top)+2)
      SetWindowPos(HCTL(CTL_MDIMAIN),null,null,null,MAIX,MAIY, _
      SWP_NOMOVE or SWP_NOZORDER or SWP_NOCOPYBITS)
      
      return 1
      
    end scope
  case WM_TIMER                          '' Controle de Timers
  case WM_CLOSE,WM_DESTROY               '' Término do aplicativo
    'DestroyAcceleratorTable(MYACCHANDLE)
    PostQuitMessage( 0 )
    exit function
    
    ' ---------------------------------------------------------------------------------
    
  end select
  
  #ifdef UseHX
  return DefWindowProc( hWnd, message, wParam, lParam )
  #else
  return DefFrameProc( hWnd, hctl(CTL_MDIMAIN), message, wParam, lParam )
  #endif  
  
end function
' ********** Função que interpreta as mensagens da janela de edição do programa *************
function AreaProc ( HWND as hwnd, MESSAGE as uint, WPARAM as wparam,LPARAM as lparam) as lresult  
  while                                  '' variaveis e definições da proc
    
    static as integer CONT
    static as RECT RCT
    static as hdc MAINDC
    static as zstring*256 TMPTXT
    static as integer DOUP,MAKEUP
    static as integer TMPLIN,COUNT
    static as integer OLDSCX,OLDSCY
    static as integer ATUDOC = 0
    static as integer MOX,MOY,OCLIN,OCCOL
    
    TMPLIN = EDATULIN    
    OLDSCX = SCRX:OLDSCY = SCRY
    OCLIN = EDATULIN: OCCOL = EDCURPOS
    DOUP = false
    
    #define LINHA EDLIN(ATUDOC,EDATULIN)
    CheckError(GetClientRect(hwnd,@MAINRCT)=0)
    
  wend  
  '' Interpretando mensagens
  select case( message )
  case WM_CREATE                         '' Inicialização da janela
    HCTL(CTL_EDITAREA) = hwnd
    SetTimer(hwnd,cast(integer,hwnd),30,null)
    
  case WM_TIMER                          '' Cronometro da janela
    select case wparam
    case cast(integer,hwnd)
      
      static LSG as double
      
      if abs(timer-LSG) >= 1 then LSG = timer      
      if (timer-LSG) > 1/KBDSPD then      
        if (ISSEL and 1) then              '' AutoScroll Seleção
          
          if MOY <= 0 then                      ' Scroll para cima
            EDATULIN = SCRY
            if EDATULIN > EDMAXLINES then EDATULIN = EDMAXLINES            
            SELYY = EDATULIN
            if SCRY > 0 then SCRY -= 1
            DOUP = True
          elseif MOY >= MAINRCT.bottom then     ' Scroll para baixo
            MOY = MAINRCT.bottom
            EDATULIN = cint((MOY/FSY)+0.5)+SCRY
            if EDATULIN > EDMAXLINES then EDATULIN = EDMAXLINES
            if SCRY < (EDMAXLINES-(MAINRCT.bottom/FSY)) then
              SCRY += 1
            end if
            SELYY = EDATULIN
            DOUP = True
          end if
          if MOX < = BORX then                     ' scroll para esquerda
            MOX = BORX
            EDCURPOS = cint(((MOX+SCRX-BORX)/FSX))
            SELXX = EDCURPOS
            if SCRX > 0 then 
              SCRX -= FSX
              if SCRX < 0 then SCRX = 0
            end if
            DOUP = True
          elseif MOX >= MAINRCT.right then         ' scroll para direita
            MOX = MAINRCT.right
            EDCURPOS = cint(((MOX+SCRX-BORX)/FSX))
            SELXX = EDCURPOS
            if SCRX < (BIGLIN*FSX-(MAINRCT.right-BORX)) then 
              SCRX += FSX
              if SCRX > (BIGLIN*FSX-(MAINRCT.right-BORX)) then 
                SCRX = (BIGLIN*FSX-(MAINRCT.right-BORX))
              end if
            end if
            
          end if
          
        end if
        
        LSG += 1/KBDSPD
        
      end if
      
      if MAKEUP then
        static AVGTMR as double,AVGCNT as integer
        dim as double TMPTMR = timer
        UpdateEditor(GetDC(hwnd)) 'DCDC)  
        'InvalidateRect(hwnd,null,true)
        AVGTMR += (timer-TMPTMR): AVGCNT += 1
        'print "Average time to update window: ";csng((AVGTMR/AVGCNT)*1000);"ms"
        MAKEUP = 0
      end if
    end select
  case WM_ACTIVATE,WM_SIZE,WM_SIZING     '' Atualizações da janela
    MAKEUP = 1
    hctl(CTL_EDITAREA) = hwnd
    UpdateEditor(DCDC)  
    InvalidateRect(hwnd,null,true)
  case WM_MOVING,WM_MOVE                 '' Janela Moveu
    UpdateEditor(DCDC)
    InvalidateRect(HWND,null,true)
  case WM_COMMAND,WM_SYSCOMMAND          '' Notificação de comandos
    
    
    scope
      dim as zstring * 255 TMPTXT
      if hiword(wparam) = 1 then
        select case loword(wparam)
        case 1          
          TMPTXT = "Accelerator 1 ( CTRL + ALT + A )"
          SetWindowText(hCtl(1), TMPTXT)
        case 2
          TMPTXT = "Accelerator 2 ( ALT + SHIFT + B )"
          SetWindowText(hCtl(1), TMPTXT)
        end select
      end if
    end scope
    
    ' --------------------------------------------------------------------------------
  
  case WM_ERASEBKGND                     '' Redesenha fundo
    return 1
  case WM_PAINT                          '' Redesenhando a janela
    
    #define prct pnt.rcpaint
    
    dim as integer RESULT
    dim as hdc HDC,TMPDC
    dim pnt as PAINTSTRUCT
    
    hDC = BeginPaint( hWnd, @pnt )
    
    RESULT = Bitblt(hDC, prct.left, prct.top, prct.right-prct.left, _
    prct.bottom-prct.top, DCDC, prct.left, prct.top, SRCCOPY)
    CheckError(RESULT=0)
    
    EndPaint( hWnd, @pnt )
    
    return 0
    
    ' --------------------------------------------------------------------------------
    
    
  case WM_KEYUP                          '' Teclas liberadas
    select case wparam
    case VK_SHIFT                        '' shift (selecionar)
      if ISSEL then ISSEL and= -3
    end select
  case WM_KEYDOWN                        '' Teclas especiais de controle
    
    ''
    '' Ações de Teclas de controle
    ''
    while        ' MY PASTA MACRO
      #macro MyPasta()
      if SELX <> SELXX or SELY <> SELYY then
        dim as integer SEX,SEXX,SEY,SEYY        
        ArrangeSelection(SEX,SEY,SEXX,SEYY)
        if SELY = SELYY then
          LINHA = left$(LINHA,SEX)+mid$(LINHA,SEXX+1)
          EDCURPOS = SEX
        else
          EDLIN(ATUDOC,SEY) = left$(EDLIN(ATUDOC,SEY),SEX) + mid$(EDLIN(ATUDOC,SEYY),SEXX+1)
          EDATULIN = SEY:EDCURPOS = SEX
          for COUNT = SEY+1 to EDMAXLINES
            EDLIN(ATUDOC,COUNT) = EDLIN(ATUDOC,COUNT+(SEYY-SEY))
          next COUNT
          EDMAXLINES -= (SEYY-SEY)
          if EDMAXLINES < ubound(EDLIN)-256 then redim preserve EDELIN(EDMAXLINES-256)
        end if
        SELX = EDCURPOS:SELXX=SELX
        SELY = EDATULIN:SELYY=SELY
        DOUP = True
      end if
      dim as string ADDTXT,GETTXT
      dim as integer A,B,C,D,Z,POSI
      GETTXT = GetClipboard()
      if len(GETTXT) then
        POSI = 1
        do
          A = instr(POSI,GETTXT,chr$(13,10))
          B = instr(POSI,GETTXT,chr$(10,13))
          C = instr(POSI,GETTXT,chr$(13))
          D = instr(POSI,GETTXT,chr$(10))
          Z = A+B+C+D+1
          if Z>1 then
            if A>0 and A<Z then Z=A:A=2
            if B>0 and B<Z then Z=B:A=2
            if C>0 and C<Z then Z=C:A=1
            if D>0 and D<Z then Z=D:A=1
            ADDTXT = mid$(GETTXT,POSI,Z-POSI)
            POSI=Z+A              
            Z = -2
          else
            ADDTXT = mid$(GETTXT,POSI): Z = -1
          end if                    
          ''
          '' adicionando texto
          ''
          if ADDTXT <> "" then
            if EDCURPOS >= len(LINHA) then
              LINHA += string$(EDCURPOS-len(LINHA)," ")
              EDCURPOS = len(LINHA)
              LINHA += ADDTXT
            else
              LINHA = left$(LINHA,EDCURPOS)+ADDTXT+mid$(LINHA,EDCURPOS+1)
            end if
            EDCURPOS += len(ADDTXT)
            DOUP = true
          end if            
          ''
          '' Adicionando Enter
          ''
          if Z = -2 then
            if EDCURPOS >= len(LINHA) then        
              for COUNT = EDMAXLINES to EDATULIN+1 step -1
                EDLIN(ATUDOC,COUNT+1) = EDLIN(ATUDOC,COUNT)
              next COUNT
              for COUNT = 0 to len(LINHA)-1
                if LINHA[COUNT]<>32 then exit for
              next COUNT
              EDLIN(ATUDOC,EDATULIN+1) = ""
              EDMAXLINES += 1
              if EDMAXLINES > ubound(EDLIN) then redim preserve EDELIN(EDMAXLINES+256)
              EDATULIN += 1
              EDCURPOS = 0
              DOUP = 1
            else
              for COUNT as integer = EDMAXLINES to EDATULIN+1 step -1
                EDLIN(ATUDOC,COUNT+1) = EDLIN(ATUDOC,COUNT)
              next COUNT
              for COUNT = 0 to len(LINHA)-1
                if LINHA[COUNT]<>32 then exit for
              next COUNT        
              EDLIN(ATUDOC,EDATULIN+1) = mid$(LINHA,EDCURPOS+1)        
              LINHA = left$(LINHA,EDCURPOS)
              EDMAXLINES += 1
              if EDMAXLINES > ubound(EDLIN) then redim preserve EDELIN(EDMAXLINES+256)
              EDATULIN += 1
              EDCURPOS = 0
              DOUP = 1
            end if
          end if
          
        loop until Z=-1
      end if
      #endmacro
    wend
    
    select case wparam
    case VK_LEFT             ' seta esquerda
      if EDCURPOS > 0 then
        if EDCURPOS < len(LINHA) then
          if LINHA[EDCURPOS-1] = 11 then
            for COUNT = EDCURPOS-1 to 0 step -1
              if LINHA[COUNT] = TABU then exit for
            next COUNT
            EDCURPOS = COUNT
          else
            EDCURPOS -= 1
          end if
        else
          EDCURPOS -= 1
        end if
        DOUP = True
        if ISSEL then SELXX += EDCURPOS-OCCOL
      end if
    case VK_RIGHT            ' seta direita
      if EDCURPOS < len(LINHA) then
        if LINHA[EDCURPOS] = 9 then
          for COUNT = EDCURPOS+1 to (len(LINHA)-1)
            if LINHA[COUNT] <> SECTAB then exit for
          next COUNT
          EDCURPOS = COUNT
        else
          EDCURPOS += 1
        end if
      else
        EDCURPOS += 1
      end if
      DOUP = True      
      if ISSEL then SELXX += EDCURPOS-OCCOL
    case VK_UP               ' seta acima
      if EDATULIN > 1 then
        EDATULIN -= 1        
        DOUP = 1        
        if ISSEL then SELYY -= 1
      end if
    case VK_DOWN             ' seta baixo
      if EDATULIN < EDMAXLINES then
        EDATULIN += 1        
        DOUP = 1     
        if ISSEL then SELYY += 1
      end if
      
    case VK_HOME             ' inicio da linha
      if Control then
        '' Control HOME = total acima
        SCRY = 0
        DOUP = True
        EDATULIN = 1
        dim as SCROLLINFO VSINFO    
        with VSINFO
          .cbSize = sizeof(SCROLLINFO)
          .fmask = SIF_ALL
        end with        
        #ifndef UseHX
        GetScrollInfo(hwnd,SB_VERT,@VSINFO)
        VSINFO.NPOS = VSINFO.nMin
        SetScrollInfo(hwnd,SB_VERT,@VSINFO,True)
        #endif
        if ISSEL then SELYY = 1
      elseif EDCURPOS <> 0 then
        '' inicio da linha
        EDCURPOS = 0
        if ISSEL then SELXX = EDCURPOS
        DOUP = True
      end if
    case VK_END              ' fim da linha
      if Control then
        ' control END - ultima linha
        SCRY = EDMAXLINES-cint((MAINRCT.bottom/FSY))
        EDATULIN = EDMAXLINES
        DOUP = True
        dim as SCROLLINFO VSINFO    
        with VSINFO
          .cbSize = sizeof(SCROLLINFO)
          .fmask = SIF_ALL
        end with        
        #ifndef UseHX
        GetScrollInfo(hwnd,SB_VERT,@VSINFO)
        VSINFO.NPOS = VSINFO.nMax
        SetScrollInfo(hwnd,SB_VERT,@VSINFO,True)
        #endif
        if ISSEL then SELYY = EDMAXLINES
      elseif EDCURPOS <> len(LINHA) then
        ' fin da linha
        EDCURPOS = len(LINHA)
        if ISSEL then SELXX = EDCURPOS
        DOUP = True
      end if
    case VK_DELETE           ' apaga caracter a frente
      if SELX <> SELXX or SELY <> SELYY then
        dim as integer SEX,SEXX,SEY,SEYY        
        ArrangeSelection(SEX,SEY,SEXX,SEYY)
        if SELY = SELYY then
          LINHA = left$(LINHA,SEX)+mid$(LINHA,SEXX+1)
          EDCURPOS = SEX
        else
          EDLIN(ATUDOC,SEY) = left$(EDLIN(ATUDOC,SEY),SEX) + mid$(EDLIN(ATUDOC,SEYY),SEXX+1)
          EDATULIN = SEY:EDCURPOS = SEX
          for COUNT = SEY+1 to EDMAXLINES-(SEYY-SEY)
            EDLIN(ATUDOC,COUNT) = EDLIN(ATUDOC,COUNT+(SEYY-SEY))
          next COUNT
          EDMAXLINES -= (SEYY-SEY)
          if EDMAXLINES < ubound(EDLIN)-256 then redim preserve EDELIN(EDMAXLINES-256)
        end if
        SELX = EDCURPOS:SELXX=SELX
        SELY = EDATULIN:SELYY=SELY
        DOUP = True
      elseif EDCURPOS < len(LINHA) then
        dim SZDEL as integer = 1
        if LINHA[EDCURPOS] = TABU then
          for COUNT = EDCURPOS+1 to len(LINHA)-1
            if LINHA[COUNT] <> SECTAB then exit for
          next COUNT
          SZDEL = COUNT-EDCURPOS
        end if        
        LINHA = left$(LINHA,EDCURPOS)+mid$(LINHA,EDCURPOS+SZDEL+1)
        DOUP = true
      else
        if EDMAXLINES > 1 then
          LINHA += string$(EDCURPOS-len(LINHA)," ")+EDLIN(ATUDOC,EDATULIN+1)
          EDMAXLINES -= 1
          if EDMAXLINES < ubound(EDLIN)-256 then redim preserve EDELIN(EDMAXLINES-256)
          for COUNT = EDATULIN+1 to EDMAXLINES
            EDLIN(ATUDOC,COUNT) = EDLIN(ATUDOC,COUNT+1)
          next COUNT
          DOUP = true
        end if        
      end if
    case VK_PRIOR            ' página anterior
      
      dim as SCROLLINFO VSINFO    
      with VSINFO
        .cbSize = sizeof(SCROLLINFO)
        .fmask = SIF_ALL
      end with 
      #ifndef UseHX
      GetScrollInfo(hwnd,SB_VERT,@VSINFO)
      scope
        dim TMP as integer
        if VSINFO.npos = VSINFO.nmin then
          EDATULIN = 1
          TMP = VSINFO.nmin
        else        
          TMP = VSINFO.npos - VSINFO.npage        
          if TMP < VSINFO.nmin then TMP = VSINFO.nmin
          EDATULIN -= VSINFO.npage
          if EDATULIN < 1 then EDATULIN = 1
        end if
        SCRY = TMP
        VSINFO.npos = TMP
        DOUP = True
      end scope      
      SetScrollInfo(hwnd,SB_VERT,@VSINFO,true)
      #endif
      if ISSEL then SELYY = EDATULIN
      
    case VK_NEXT             ' próxima página      
      dim as SCROLLINFO VSINFO    
      with VSINFO
        .cbSize = sizeof(SCROLLINFO)
        .fmask = SIF_ALL
      end with    
      #ifndef UseHX
      GetScrollInfo(hwnd,SB_VERT,@VSINFO)
      scope
        dim TMP as integer
        if VSINFO.npos = VSINFO.nmax-VSINFO.npage then
          EDATULIN = EDMAXLINES
          TMP = (VSINFO.nmax-VSINFO.npage)+1
        else        
          TMP = VSINFO.npos + VSINFO.npage        
          if TMP >= VSINFO.nmax-VSINFO.npage then TMP = (VSINFO.nmax-VSINFO.npage)+1
          EDATULIN += VSINFO.npage
          if EDATULIN > EDMAXLINES then EDATULIN = EDMAXLINES
        end if
        SCRY = TMP
        VSINFO.npos = TMP
        DOUP = True
      end scope
      SetScrollInfo(hwnd,SB_VERT,@VSINFO,true)
      #endif
      if ISSEL then SELYY = EDATULIN
      
    case VK_BACK             ' apaga caracter
      if SELX <> SELXX or SELY <> SELYY then
        dim as integer SEX,SEXX,SEY,SEYY        
        ArrangeSelection(SEX,SEY,SEXX,SEYY)
        if SELY = SELYY then
          LINHA = left$(LINHA,SEX)+mid$(LINHA,SEXX+1)
          EDCURPOS = SEX
        else
          EDLIN(ATUDOC,SEY) = left$(EDLIN(ATUDOC,SEY),SEX) + mid$(EDLIN(ATUDOC,SEYY),SEXX+1)
          EDATULIN = SEY:EDCURPOS = SEX
          for COUNT = SEY+1 to EDMAXLINES
            EDLIN(ATUDOC,COUNT) = EDLIN(ATUDOC,COUNT+(SEYY-SEY))
          next COUNT
          EDMAXLINES -= (SEYY-SEY)
          if EDMAXLINES < ubound(EDLIN)-256 then redim preserve EDELIN(EDMAXLINES-256)
        end if
        SELX = EDCURPOS:SELXX=SELX
        SELY = EDATULIN:SELYY=SELY
        DOUP = True
      elseif EDCURPOS then        
        dim as integer SZDEL = 1
        LINHA += string$(EDCURPOS-len(LINHA),32)
        if LINHA[EDCURPOS-1] = SECTAB then
          COUNT = instrrev(LINHA,chr$(TABU),EDCURPOS)          
          SZDEL = (EDCURPOS-COUNT)+1
        end if          
        if EDCURPOS = len(LINHA) then
          LINHA = left$(LINHA,len(LINHA)-SZDEL)
        else
          LINHA = left$(LINHA,EDCURPOS-SZDEL)+mid$(LINHA,EDCURPOS+1)
        end if          
        EDCURPOS -= SZDEL
        DOUP = true        
      elseif EDATULIN > 1 then
        EDCURPOS = len(EDLIN(ATUDOC,EDATULIN-1))
        EDLIN(ATUDOC,EDATULIN-1) += LINHA
        EDMAXLINES -= 1
        if EDMAXLINES < ubound(EDLIN)-256 then redim preserve EDELIN(EDMAXLINES-256)
        for COUNT = EDATULIN to EDMAXLINES
          EDLIN(ATUDOC,COUNT) = EDLIN(ATUDOC,COUNT+1)
        next COUNT
        EDLIN(ATUDOC,COUNT) = ""
        EDATULIN -= 1
        DOUP = True
      end if
    case VK_RETURN           ' nova linha
      if EDCURPOS >= len(LINHA) then        
        for COUNT = EDMAXLINES to EDATULIN+1 step -1
          EDLIN(ATUDOC,COUNT+1) = EDLIN(ATUDOC,COUNT)
        next COUNT
        for COUNT = 0 to len(LINHA)-1
          if LINHA[COUNT]<>32 then exit for
        next COUNT
        EDLIN(ATUDOC,EDATULIN+1) = string$(COUNT," ")
        EDMAXLINES += 1
        if EDMAXLINES > ubound(EDLIN) then redim preserve EDELIN(EDMAXLINES+256)
        EDATULIN += 1
        EDCURPOS = COUNT
        DOUP = 1
      else
        for COUNT as integer = EDMAXLINES to EDATULIN+1 step -1
          EDLIN(ATUDOC,COUNT+1) = EDLIN(ATUDOC,COUNT)
        next COUNT
        for COUNT = 0 to len(LINHA)-1
          if LINHA[COUNT]<>32 then exit for
        next COUNT        
        EDLIN(ATUDOC,EDATULIN+1) = string$(COUNT," ")+mid$(LINHA,EDCURPOS+1)        
        LINHA = left$(LINHA,EDCURPOS)
        EDMAXLINES += 1
        if EDMAXLINES > ubound(EDLIN) then redim preserve EDELIN(EDMAXLINES+256)
        EDATULIN += 1
        EDCURPOS = COUNT
        DOUP = 1
      end if
      
    case VK_SHIFT            ' shift (selecionar)
      if SELX=SELY and SELXX=SELYY then
        SELX = EDCURPOS:SELY = EDATULIN
        SELXX=SELX:SELYY=SELY
        DOUP = 1
      end if
      ISSEL or= 2      
    case VK_U                ' (control+U > elimina identação)
      if Control then
        dim as integer CNT,LIN,CHAR
        dim as integer A,B,C,IDV,ISU
        dim as string TMP,LTMP,EXT,MTB
        if CFG.IDENTTABS then 
          MTB = chr$(TABU)+string$(CFG.TABSPACES-1,SECTAB)
        else
          MTB = space$(CFG.TABSPACES)
        end if        
        for LIN = 1 to EDMAXLINES
          TMP = EDLIN(ATUDOC,LIN)
          for CNT = 0 to len(TMP)-1
            CHAR = TMP[CNT]
            if CHAR <> 9 and CHAR <> 32 and CHAR <> 11 then exit for
          next CNT          
          TMP = mid$(TMP,CNT+1)
          LTMP = lcase$(TMP)          
          for A = 0 to len(TMP)-1
            select case LTMP[A]
            case 46,48 to 57,97 to 122
              rem nada
            case else
              exit for
            end select
          next A          
          if A > 1 then
            LTMP = left$(LTMP,A)
            for CNT = 1 to IDC(0)              
              if ID(CNT) = LTMP then
                if IDF(CNT) and IT_OPEN then 
                  ISU = True 
                else 
                  if len(EXT)>=len(MTB) then
                    EXT = left$(EXT,len(EXT)-len(MTB))
                  end if
                end if
                exit for
              end if
            next CNT          
          end if
          EDLIN(ATUDOC,LIN) = EXT+trim$(TMP)
          if ISU then
            EXT += MTB
            ISU=False
          end if
          
        next LIN
        DOUP = 1
      end if
    case VK_V                ' (control+V > colar)
      
      if control then
        MyPasta()
      end if
    case VK_C,VK_INSERT      ' (control+C > copiar)
      if Control then
        if SELX <> SELXX or SELY <> SELYY then
          dim as string CLIPDATA
          dim as integer SEX,SEY,SEXX,SEYY
          ArrangeSelection(SEX,SEY,SEXX,SEYY)
          for CNT as integer = SEY to SEYY        
            if CNT = SEY then          
              if SEY=SEYY then 
                CLIPDATA = mid$(EDLIN(ATUDOC,CNT),1+SEX,SEXX-SEX)
              else
                CLIPDATA = mid$(EDLIN(ATUDOC,CNT),1+SEX)+chr$(13,10)
              end if
            elseif CNT = SEYY then
              CLIPDATA += left$(EDLIN(ATUDOC,CNT),SEXX)
            else
              CLIPDATA += EDLIN(ATUDOC,CNT)+chr$(13,10)
            end if
          next CNT
          SEX = 0          
          do
            if CLIPDATA[SEX] = SECTAB then              
              CLIPDATA = left$(CLIPDATA,SEX)+mid$(CLIPDATA,SEX+3)              
            end if
            SEX += 1
          loop until SEX = len(CLIPDATA)
          SetClipboard(CLIPDATA)
        end if
      elseif Shift then
        if wparam = VK_INSERT then
          MyPasta()
        end if      
      end if
    end select
    
  case WM_CHAR                           '' Caracteres Pressionados
    
    dim as string ADDTXT 
    
    select case wparam
    case 9                '' tab
      ADDTXT = chr$(wparam)+string$((CFG.TABSPACES-1)-((EDCURPOS) mod CFG.TABSPACES),11)
    case 0 to 31          '' nulos
      ADDTXT = ""
    case else             '' outros
      ADDTXT = chr$(wparam)
      if SELX <> SELXX or SELY <> SELYY then
        dim as integer SEX,SEXX,SEY,SEYY        
        ArrangeSelection(SEX,SEY,SEXX,SEYY)
        if SELY = SELYY then
          LINHA = left$(LINHA,SEX)+mid$(LINHA,SEXX+1)
          EDCURPOS = SEX
        else
          EDLIN(ATUDOC,SEY) = left$(EDLIN(ATUDOC,SEY),SEX) + mid$(EDLIN(ATUDOC,SEYY),SEXX+1)
          EDATULIN = SEY:EDCURPOS = SEX
          for COUNT = SEY+1 to EDMAXLINES
            EDLIN(ATUDOC,COUNT) = EDLIN(ATUDOC,COUNT+(SEYY-SEY))
          next COUNT
          EDMAXLINES -= (SEYY-SEY)
          if EDMAXLINES < ubound(EDLIN)-256 then redim preserve EDELIN(EDMAXLINES-256)
        end if
        SELX = EDCURPOS:SELXX=SELX
        SELY = EDATULIN:SELYY=SELY
      end if
    end select
    
    ''
    '' adicionando texto
    ''
    if ADDTXT <> "" then
      if EDCURPOS >= len(LINHA) then
        LINHA += string$(EDCURPOS-len(LINHA)," ")
        EDCURPOS = len(LINHA)
        LINHA += ADDTXT
      else
        LINHA = left$(LINHA,EDCURPOS)+ADDTXT+mid$(LINHA,EDCURPOS+1)
      end if
      EDCURPOS += len(ADDTXT)
      DOUP = true
    end if
    
  case WM_HSCROLL                        '' Barra de rolagem horizontal
    
    dim as SCROLLINFO HSINFO    
    with HSINFO
      .cbSize = sizeof(SCROLLINFO)
      .fmask = SIF_ALL
    end with    
    #ifndef UseHX
    GetScrollInfo(hwnd,SB_HORZ,@HSINFO)
    #endif
    
    select case loword(wparam)
    case SB_THUMBTRACK    '' Moveu a barra
      SCRX = HSINFO.nTrackPos      
      DOUP = True            
      HSINFO.npos = HSINFO.nTrackPos            
    case SB_ENDSCROLL     '' Terminou de mover a barra
      'SCRX = HSINFO.nTrackPos      
      'DOUP = True
      'HSINFO.npos = HSINFO.nTrackPos            
    case SB_TOP           '' Barra total esquerda
      SCRX = HSINFO.nmin
      DOUP = True
      HSINFO.npos = SCRX
    case SB_BOTTOM        '' Barra total direita
      SCRX = HSINFO.nmax-HSINFO.npage
      DOUP = True
      HSINFO.npos = SCRX
    case SB_LINELEFT	    '' Barra para esquerda
      scope
        dim TMP as integer
        TMP = HSINFO.npos - FSX
        TMP = -int(-TMP/FSX)*FSX
        if TMP < HSINFO.nmin then TMP = HSINFO.nmin            
        SCRX = TMP
        HSINFO.npos = TMP
        DOUP = True
      end scope
    case SB_LINERIGHT	    '' Barra para direita
      scope
        dim TMP as integer
        TMP = HSINFO.npos + FSX
        TMP = int(TMP/FSX)*FSX
        if TMP > HSINFO.nmax-HSINFO.npage then TMP = HSINFO.nmax-HSINFO.npage
        SCRX = TMP
        HSINFO.npos = TMP
        DOUP = True
      end scope
    case SB_PAGELEFT      '' Barra pagina esquerda
      scope
        dim TMP as integer
        TMP = HSINFO.npos - HSINFO.npage
        TMP = -int(-TMP/FSX)*FSX
        if TMP < HSINFO.nmin then TMP = HSINFO.nmin            
        SCRX = TMP
        HSINFO.npos = TMP
        DOUP = True
      end scope
    case SB_PAGERIGHT     '' Barra pagina direita
      scope
        dim TMP as integer
        TMP = HSINFO.npos + HSINFO.npage
        TMP = int(TMP/FSX)*FSX
        if TMP > HSINFO.nmax-HSINFO.npage then TMP = HSINFO.nmax-HSINFO.npage
        SCRX = TMP
        HSINFO.npos = TMP
        DOUP = True
      end scope
    end select
    
    #ifndef UseHX
    SetScrollInfo(hwnd,SB_HORZ,@HSINFO,true)
    #endif
    
    
  case WM_VSCROLL                        '' Barra de rolagem vertical
    
    dim as SCROLLINFO VSINFO    
    with VSINFO
      .cbSize = sizeof(SCROLLINFO)
      .fmask = SIF_ALL
    end with    
    #ifndef UseHX
    GetScrollInfo(hwnd,SB_VERT,@VSINFO)
    #endif
    
    select case loword(wparam)
    case SB_THUMBTRACK    '' Moveu a barra
      SCRY = VSINFO.nTrackPos      
      DOUP = True            
      VSINFO.npos = SCRY
    case SB_ENDSCROLL     '' Terminou de mover a barra
      'print "EndScroll"
      'SCRX = HSINFO.nTrackPos      
      'DOUP = True
      'HSINFO.npos = HSINFO.nTrackPos            
    case SB_TOP           '' Barra total esquerda
      SCRY = VSINFO.nmin
      DOUP = True
      VSINFO.npos = SCRY
    case SB_BOTTOM        '' Barra total direita
      SCRY = VSINFO.nmax-VSINFO.npage
      DOUP = True
      VSINFO.npos = SCRY
    case SB_LINEUP	      '' Barra para esquerda
      scope
        dim TMP as integer
        TMP = VSINFO.npos - 1        
        if TMP < VSINFO.nmin then TMP = VSINFO.nmin            
        SCRY = TMP
        VSINFO.npos = TMP
        DOUP = True
      end scope
    case SB_LINEDOWN	    '' Barra para direita
      scope
        dim TMP as integer
        TMP = VSINFO.npos + 1        
        if TMP > VSINFO.nmax-VSINFO.npage then TMP = (VSINFO.nmax-VSINFO.npage)+1
        SCRY = TMP
        VSINFO.npos = TMP
        DOUP = True
      end scope
    case SB_PAGEUP        '' Barra pagina esquerda
      scope
        dim TMP as integer
        TMP = VSINFO.npos - VSINFO.npage        
        if TMP < VSINFO.nmin then TMP = VSINFO.nmin            
        SCRY = TMP
        VSINFO.npos = TMP
        DOUP = True
      end scope
    case SB_PAGEDOWN      '' Barra pagina direita
      scope
        dim TMP as integer
        TMP = VSINFO.npos + VSINFO.npage        
        if TMP > VSINFO.nmax-VSINFO.npage then TMP = (VSINFO.nmax-VSINFO.npage)+1
        SCRY = TMP
        VSINFO.npos = TMP
        DOUP = True
      end scope
    end select
    
    #ifndef UseHX
    SetScrollInfo(hwnd,SB_VERT,@VSINFO,true)
    #endif
    
    
  case WM_MOUSEMOVE                      '' Movimento Mouse (cursor)
    dim as integer X,Y
    X = cast(short,loword(lparam))
    Y = cast(short,hiword(lparam))
    
    if (ISSEL and 1) then      
      MOX = X: MOY = Y
      if MOX > BORX and MOX < MAINRCT.right and MOY > 0 and MOY < MAINRCT.bottom then
        EDCURPOS = cint(((MOX+SCRX-BORX)/FSX))
        EDATULIN = cint((MOY/FSY)+0.5)+SCRY
        if EDATULIN > EDMAXLINES then EDATULIN = EDMAXLINES
        SELXX = EDCURPOS:SELYY = EDATULIN      
      end if
      DOUP = True        
    else
      if X >= BORX and X <= MAINRCT.right and Y >= 0 and Y <= MAINRCT.bottom then
        SetCursor(CURSOR(CU_TEXT))
      else
        SetCursor(CURSOR(CU_ARROW))
      end if
    end if
    
  case WM_LBUTTONDOWN                    '' Botão esquerdo do mouse pressionado
    
    dim as integer X,Y
    X = cast(short,loword(lparam))
    Y = cast(short,hiword(lparam))
    if X >= BORX and X <= MAINRCT.right and Y >= 0 and Y <= MAINRCT.bottom then
      EDCURPOS = cint(((X+SCRX-BORX)/FSX))
      EDATULIN = cint((Y/FSY)+0.5)+SCRY
      if EDATULIN > EDMAXLINES then EDATULIN = EDMAXLINES
      if ISSEL = 0 then
        SELX = EDCURPOS:SELY = EDATULIN
        SELXX=SELX:SELYY=SELY
      else
        SELXX = EDCURPOS:SELYY = EDATULIN
      end if
      ISSEL or= 1
      MOX=X:MOY=Y:SetCapture(hwnd)
      
      DOUP = True      
    end if
    
  case WM_LBUTTONUP                      '' Botão esquerdo do mouse liberado
    
    dim as integer X,Y
    X = cast(short,loword(lparam))
    Y = cast(short,hiword(lparam))
    if GetCapture() = hwnd then SetCapture(null)
    
    if ISSEL then          ' Está selecionando
      if X >= BORX and X <= MAINRCT.right and Y >= 0 and Y <= MAINRCT.bottom then
        EDCURPOS = cint(((X+SCRX-BORX)/FSX))
        EDATULIN = cint((Y/FSY)+0.5)+SCRY
        if EDATULIN > EDMAXLINES then EDATULIN = EDMAXLINES
        SELXX = EDCURPOS:SELYY = EDATULIN
        DOUP = True
      end if
      ISSEL and= -2
    end if
    
  case WM_MOUSEWHEEL                     '' Rolagem do mouse
    
    dim as integer WHEE,OLDWHEE
    dim as SCROLLINFO VSINFO    
    
    WHEE = cast(short,hiword(wParam))
    
    if Control then           ' Control+Rolagem = Muda fonte
      if WHEE <0  and FONTTAM < 36 then FONTTAM += 1
      if WHEE >0 and FONTTAM > 7 then FONTTAM -= 1
      FSX=0:FSY=0
      AddFixedFont(AF_GROUPS,FONTTAM,FW_BOLD,false,FontName)
      AddFixedFont(AF_ASPAS,FONTTAM,FW_BOLD,false,FontName)
      AddFixedFont(AF_OPERADORES,FONTTAM,FW_BOLD,false,FontName)
      AddFixedFont(AF_COMMENT,FONTTAM,FW_NORMAL,True,FontName)
      AddFixedFont(AF_TEXT,FONTTAM,FW_NORMAL,false,FontName)
      BORX = 0:DOUP = True
      
    else                      ' Rolagem da barra
      
      with VSINFO
        .cbSize = sizeof(SCROLLINFO)
        .fmask = SIF_ALL
      end with    
      #ifndef UseHX
      GetScrollInfo(hwnd,SB_VERT,@VSINFO)
      #endif
      
      if WHEE > 0 then         ' Rolagem acima
        scope
          dim TMP as integer
          TMP = VSINFO.npos - 3        
          if TMP < VSINFO.nmin then TMP = VSINFO.nmin            
          SCRY = TMP
          VSINFO.npos = TMP
          DOUP = True
          OLDWHEE = WHEE
        end scope      
      else                     ' Rolagem Abaixo
        scope
          dim TMP as integer
          TMP = VSINFO.npos + 3        
          if TMP > VSINFO.nmax-VSINFO.npage then TMP = (VSINFO.nmax-VSINFO.npage)+1
          SCRY = TMP
          VSINFO.npos = TMP
          DOUP = True
        end scope
        OLDWHEE = WHEE
      end if
      #ifndef UseHX
      SetScrollInfo(hwnd,SB_VERT,@VSINFO,true)
      #endif
    end if
    
  case WM_CLOSE,WM_DESTROY               '' Encerramento da janela
    PostQuitMessage(0)
  case WM_MOUSEACTIVATE                  '' Clique/Ativação
    hctl(CTL_EDITAREA) = hwnd
  
  end select
  
  while                                  '' atualização da janela do editor
    
    if DOUP then
      
      if EDATULIN > EDMAXLINES then EDATULIN = EDMAXLINES
      if OCLIN <> EDATULIN or OCCOL <> EDCURPOS then ' alteração no cursor
        
        if EDCURPOS < len(LINHA) then
          if LINHA[EDCURPOS]=SECTAB then
            for EDCURPOS = EDCURPOS to len(LINHA)-1
              if LINHA[EDCURPOS] <> SECTAB then exit for
            next EDCURPOS          
          end if
        end if
        
        if EDATULIN <> TMPLIN then
          EDLIN(ATUDOC,TMPLIN) = rtrim$(EDLIN(ATUDOC,TMPLIN))
        end if
        
        dim as SCROLLINFO HSINFO    
        with HSINFO
          .cbSize = sizeof(SCROLLINFO)
          .fmask = SIF_ALL
        end with    
        #ifndef UseHX
        GetScrollInfo(hwnd,SB_HORZ,@HSINFO)
        #endif
        dim as SCROLLINFO VSINFO    
        with VSINFO
          .cbSize = sizeof(SCROLLINFO)
          .fmask = SIF_ALL
        end with    
        #ifndef UseHX
        GetScrollInfo(hwnd,SB_VERT,@VSINFO)
        #endif
        
        dim as string CURST        
        if OCLIN > EDATULIN then       '' Cursor movido pra cima
          if (EDATULIN-1) < SCRY or EDATULIN > SCRY+cint(MAINRCT.bottom/FSY) then 
            SCRY = (EDATULIN-1)
          end if
          if EDCURPOS > int((SCRX+(MAINRCT.right-BORX))/FSX) then          
            SCRX = ((EDCURPOS+.5)*FSX)-(MAINRCT.right-BORX)
          elseif EDCURPOS <= cint(SCRX/FSX) then
            SCRX = EDCURPOS*FSX
          end if
        elseif OCLIN < EDATULIN then   '' Cursor movido para baixo
          if EDATULIN > SCRY+cint(MAINRCT.bottom/FSY) or (EDATULIN-1) < SCRY  then 
            SCRY = EDATULIN-cint(MAINRCT.bottom/FSY)
          elseif EDCURPOS > int((SCRX+(MAINRCT.right-BORX))/FSX) or EDCURPOS <= cint(SCRX/FSX) then
            SCRY = EDATULIN-cint(MAINRCT.bottom/FSY)
          end if
        end if
        if OCCOL < EDCURPOS then       '' Cursor movido para direita
          if EDCURPOS > int((SCRX+(MAINRCT.right-BORX))/FSX) or EDCURPOS <= cint(SCRX/FSX) then
            SCRX = ((EDCURPOS+.5)*FSX)-(MAINRCT.right-BORX)
          end if
          if (EDATULIN-1) < SCRY then
            SCRY = (EDATULIN-1)
          elseif EDATULIN > SCRY+cint(MAINRCT.bottom/FSY) then 
            SCRY = EDATULIN-cint(MAINRCT.bottom/FSY)
          end if          
        elseif OCCOL > EDCURPOS then   '' Cursor movido para esquerda
          if EDCURPOS <= cint(SCRX/FSX) or EDCURPOS > int((SCRX+(MAINRCT.right-BORX))/FSX) then 
            SCRX = EDCURPOS*FSX
          end if
          if (EDATULIN-1) < SCRY then
            SCRY = (EDATULIN-1)
          elseif EDATULIN > SCRY+cint(MAINRCT.bottom/FSY) then 
            SCRY = EDATULIN-cint(MAINRCT.bottom/FSY)
          end if
        end if
        
        if SCRY > EDMAXLINES-cint(MAINRCT.BOTTOM/FSY) then
          SCRY = EDMAXLINES-cint(MAINRCT.BOTTOM/FSY)
        end if
        if SCRX < 0 then SCRX = 0
        if SCRY < 0 then SCRY = 0
        
        HSINFO.npos = SCRX:VSINFO.npos = SCRY
        #ifndef UseHX
        SetScrollInfo(hwnd,SB_HORZ,@HSINFO,True)
        SetScrollInfo(hwnd,SB_VERT,@VSINFO,True)
        #endif
        
      end if
      
      if ISSEL then          ' Está selecionando
        rem nothing
      else                   ' Verifica limpeza de seleção
        if OCLIN <> EDATULIN or OCCOL <> EDCURPOS then
          SELX=0:SELY=0:SELXX=0:SELYY=0
        end if
      end if
      
      MAKEUP = 1      
    end if
    
    #ifdef UseHX
    return DefWindowProc( hwnd, message, wParam, lParam )
    #else
    return DefMDIChildProc( hWnd, message, wParam, lParam )
    #endif
    
  wend
  
end function
' *********************** Função que atualiza o bitmap de um form ***************************
sub UpdateForm(DCDC as hdc)
  
  dim as rect TMPRCT
  static as integer SWP
  static as integer DSEL = 1  
  SWP = 1-SWP
  
  if DOTPEN = 0 then
    DOTPEN = CreatePen(PS_DOT,1,rgba(0,80,255,0))
    CheckError(DOTPEN=0)
    DOTPEN2 = CreatePen(PS_DOT,1,rgba(40,0,128,0))
    CheckError(DOTPEN2=0)    
  end if
  
  #define prct MAINRCT
  
  #macro DrawControl(HCONTROL,CCAPTION,CX,CY,CWID,CHEI)
  SetWindowText(HCONTROL,CCAPTION)
  SetWindowPos(HCONTROL,null,null,null,CWID,CHEI, _
  SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOCOPYBITS or SWP_NOREDRAW or SWP_NOZORDER )
  SetViewportOrgEx(DCDC,CX,CY,null)
  SendMessage(HCONTROL,WM_PRINT,cast(wparam,DCDC),PRF_CHILDREN or PRF_CLIENT or PRF_NONCLIENT)
  if DSEL then
    if SWP then SelectObject(DCDC,DOTPEN) else SelectObject(DCDC,DOTPEN2)    
    SelectObject(DCDC,GetStockObject(NULL_BRUSH))  
    Rectangle(DCDC,0,0,(CWID),(CHEI))
    SelectObject(DCDC,GetStockObject(BLACK_BRUSH))  
    SelectObject(DCDC,GetStockObject(NULL_PEN))
    Rectangle(DCDC,-2,-2,4,4)
    Rectangle(DCDC,-3+(CWID),-2,3+(CWID),4)
    Rectangle(DCDC,-2,-2,4,4)
    Rectangle(DCDC,-2,-3+(CHEI),4,3+(CHEI))
    Rectangle(DCDC,-3+(CWID),-3+(CHEI),3+(CWID),3+(CHEI))
  end if
  #endmacro
  
  #macro DrawComboBox(HCONTROL,CCAPTION,CX,CY,CWID,CHEI)
  SetWindowText(HCONTROL,CCAPTION)
  SetWindowPos(HCONTROL,null,null,null,CWID,CHEI, _
  SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOCOPYBITS or SWP_NOREDRAW or SWP_NOZORDER )
  SetViewportOrgEx(DCDC,CX,CY,null)  
  SendMessage(HCONTROL,WM_PRINT,cast(wparam,DCDC),PRF_CHILDREN or PRF_CLIENT or PRF_NONCLIENT)  
  if DSEL then
    if SWP then SelectObject(DCDC,DOTPEN) else SelectObject(DCDC,DOTPEN2)    
    SelectObject(DCDC,GetStockObject(NULL_BRUSH))  
    Rectangle(DCDC,0,0,(CWID),(CHEI))
    SelectObject(DCDC,GetStockObject(BLACK_BRUSH))  
    SelectObject(DCDC,GetStockObject(NULL_PEN))
    Rectangle(DCDC,-3,-3,3,3)
    Rectangle(DCDC,-3+(CWID),-3,3+(CWID),3)
    Rectangle(DCDC,-3,-3,3,3)
    Rectangle(DCDC,-3,-3+(CHEI),3,3+(CHEI))
    Rectangle(DCDC,-3+(CWID),-3+(CHEI),3+(CWID),3+(CHEI))
  else    
    with TMPRCT
      .left =0
      .top = 0
      .right = (CWID)
      .bottom = (CHEI)
    end with
    DrawFocusRect(DCDC,@TMPRCT)
  end if
  
  #endmacro
  
  CheckError(GetClientRect(hctl(CTL_MAIN),@MAINRCT)=0)
  SelectObject(DCDC,DCBMP)
  SetBkMode(DCDC,Transparent)
  SetBkColor(DCDC,GetSysColor(COLOR_BTNFACE))
  FillRect(DCDC,@prct,cast(hBrush, DOTBRUSH))
  
  'TextOut(DCDC,20,20,"Teste",5)    
  'DrawState(DCDC,null,null,cast(wparam, MYBMP),null,100,20,128,128,DST_BITMAP)
  
  'for COUNT as integer = 1 to 1
  
  'if cint(rnd) then
  '  SendMessage(hctl(CTL_BUTTON),BM_SETCHECK,BST_CHECKED,null)
  'else
  '  SendMessage(hctl(CTL_BUTTON),BM_SETCHECK,BST_UNCHECKED,null)
  'end if
  SendMessage(HCTL(CTL_STATIC),STM_SETIMAGE,IMAGE_BITMAP,cast(lparam,MYBMP))
  DrawControl(HCTL(CTL_STATIC),"Static" & (1),30,20, 128,64)
  
  SendMessage(hctl(CTL_BUTTON),BM_SETSTYLE,null,null)
  SendMessage(hctl(CTL_BUTTON),BM_SETSTATE,false,null)      
  EnableWindow(hctl(CTL_BUTTON),false)
  DrawControl(HCTL(CTL_BUTTON),"Button" & (2),30,150, 120,48)
  
  EnableWindow(hctl(CTL_BUTTON),true)    
  DrawControl(HCTL(CTL_BUTTON),"Button" & (1),20,100, 80,24)
  
  SendMessage(hctl(CTL_BUTTON),BM_SETSTYLE,BS_CHECKBOX	,null)  
  SendMEssage(hctl(CTL_BUTTON),BM_SETCHECK,False,null)
  DrawControl(HCTL(CTL_BUTTON),"Button" & (3),180,250, 80,24)
  
  SendMessage(hctl(CTL_BUTTON),BM_SETSTYLE,BS_RADIOBUTTON	,null)
  SendMEssage(hctl(CTL_BUTTON),BM_SETCHECK,True,null)
  DrawControl(HCTL(CTL_BUTTON),"Button" & (4),160,290, 80,24)
  SendMEssage(hctl(CTL_BUTTON),BM_SETCHECK,False,null)
  
  SendMessage(hctl(CTL_BUTTON),BM_SETSTYLE,BS_GROUPBOX,null)  
  DrawControl(HCTL(CTL_BUTTON),"Button" & (5),300,30, 140,200)
  
  SendMessage(hctl(CTL_IMGBUTTON),BM_SETSTYLE,BS_BITMAP,null)  
  SendMessage(hctl(CTL_IMGBUTTON),BM_SETIMAGE,IMAGE_BITMAP,cast(lparam,MYBMP))
  DrawControl(HCTL(CTL_IMGBUTTON),"Button" & (6),180,330, 72,72)
  
  EnableWindow(hctl(CTL_COMBO),true)
  DrawComboBox(HCTL(CTL_COMBO),"ComboBox" & (1),40,220,100,128)
  
  EnableWindow(hctl(CTL_COMBO),false)
  DrawComboBox(HCTL(CTL_COMBO),"ComboBox" & (2),200,40,80,40)
  
  EnableWindow(hctl(CTL_LIST),true)
  DrawControl(HCTL(CTL_LIST),"ListBox" & (1),170,110,100,128)
  
  
  
  'next COUNT
  SetViewportOrgEx(DCDC,0,0,null)
  
end sub
' *********************** Função de atualização da janela do editor *************************
sub UpdateEditor(DCDC as hdc)
  
  while                                 '' Variaveis da função
    dim as rect TMPRCT
    dim as hrgn OLDRG,NEWRG  
    dim as string TMPTXT,TMPLIN,TMPTOK,LCLIN
    dim as integer TMP,POSIS,POSI
    dim as hbrush BKBRUSH,IDBRUSH
    dim as hfont OLDFNT
    dim as integer CNTX,CNTY,SEX,SEY,SEXX,SEYY
    dim as integer STPOS,STTOK,STEND,CNT,MAXLL
    dim as integer FTC,WRDLST,SEA,SEB,TTYPE,HAVETOK,TOKNUM
    static as integer INITST,POX,POXB,POXC
    static as integer YY,COUNT,FSYY
    static as integer ATUDOC=0
    
  wend
  while                                 '' Inicialização Básica
    BKBRUSH = CreateSolidBrush(C_SHADOW)
    IDBRUSH = CreateSolidBrush(C_IDENTY)
    
    if BORX = 0 then      
      INITST = 1
      #ifndef UseHX
      CheckError(CreateCaret(hctl(CTL_EDITAREA),null,1,FSY)=0)    
      ShowCaret(hctl(CTL_EDITAREA))
      #endif
      ISCARET = True      
      BORX = FSX*5+18 'GetTextWidth(AF_TEXT,"99999  ")+3
      CARETX = BORX
      CARETY = 0
    end if
  wend
  while                                 '' Objetos inicias
    SelectObject(DCDC,DCBMP)  
    FillRect(DCDC,@MAINRCT,cast(hBrush, COLOR_WINDOW+1))  
    OLDFNT = SelectObject(DCDC,FONTE(AF_TEXT))
    FSYY = WIDCHAR(AF_TEXT,-1)
    SetBkMode(DCDC,Transparent)
  wend
  while                                 '' Números de linha
    MakeRect(TMPRCT,0,0,FSX*5+3,MAINRCT.bottom)  
    FillRect(DCDC,@TMPRCT,BKBRUSH)
    SetTextColor(DCDC,C_FUNDO)    
    COUNT = SCRY
    for YY = 0 to MAINRCT.bottom step FSY
      COUNT += 1
      if COUNT > EDMAXLINES then
        TMPTXT = "     "
      else
        TMPTXT = str$(COUNT)
        TMPTXT = string$(5-len(TMPTXT)," ")+TMPTXT
      end if
      TextOut(DCDC,0,YY,strptr(TMPTXT),len(TMPTXT))    
    next YY
  wend
  while                                 '' coluna de Identação
    MakeRect(TMPRCT,FSX*5+3,0,BORX-1,MAINRCT.bottom)  
    FillRect(DCDC,@TMPRCT,IDBRUSH)  
    'SetTextColor(DCDC,C_SHADOW)
    'COUNT = 0
    'for YY = 0 to MAINRCT.bottom step FSY
    '  COUNT += 1    
    '  TextOut(DCDC,FSX*5+7,YY,"",1)    
    'next YY
  wend
  while                                 '' Texto da linha
    
    NEWRG = CreateRectRgn(BORX,0,MAINRCT.right,MAINRCT.bottom)  
    SelectClipRgn(DCDC,NEWRG)    
    COUNT = SCRY
    #ifdef Debug_Text
    color ,0
    cls
    #endif
    
    for YY = 0 to MAINRCT.bottom step FSY
      COUNT += 1
      if COUNT > EDMAXLINES then exit for      
      TMPLIN = EDLIN(ATUDOC,COUNT)
      while                           '' arrumando tabs
        POSI = 1
        do
          POSI = instr(POSI,TMPLIN,chr$(TABU))
          if POSI = 0 then exit do
          for CNT = POSI to len(TMPLIN)-1
            if TMPLIN[CNT] <> SECTAB then exit for
          next CNT
          POSIS = CFG.TABSPACES-((POSI-1) mod CFG.TABSPACES)
          TMPLIN = left$(TMPLIN,POSI)+string$(POSIS-1,SECTAB)+ mid$(TMPLIN,CNT+1)
          POSI += 1
        loop              
        EDLIN(ATUDOC,COUNT) = TMPLIN
      wend
      
      for CNT = 0 to len(TMPLIN)-1
        if TMPLIN[CNT] = TABU then TMPLIN[CNT] = 32
        if TMPLIN[CNT] = 11 then TMPLIN[CNT] = 32
      next CNT
      MAXLL = len(TMPLIN)
      
      if CFG.SYNTAXCOLORS then         '' Cores na sintaxe
        
        LCLIN = lcase$(TMPLIN)      
        STPOS = 0:STEND = MAXLL-1
        TTYPE = 0:TOKNUM = 0
        
        #ifdef Debug_Text
        color 8,0:print LCLIN;:color 13:print "<"
        #endif
        
        do        
          ''
          '' pega próximo token
          ''
          STTOK = 0:HAVETOK = 0
          TOKNUM += 1:TTYPE = 0
          
          
          for CNT = STPOS to STEND
            
            select case LCLIN[CNT]
            case Sharp              ' verifica pré-processor (#)
              if CNT > STPOS then exit for
              if trim$(left$(LCLIN,CNT)) = "" then
                CNT = MAXLL
                TTYPE = TT_PREPROC
                SetBkMode(DCDC,TRANSPARENT)
                SetTextColor(DCDC,C_PREPROC)          
                SelectObject(DCDC,FONTE(AF_TEXT))
                FSYY = WIDCHAR(AF_TEXT,-1)
                exit for
              else
                CNT += 1
                TTYPE = TT_OPERADOR
                SetBkMode(DCDC,TRANSPARENT)
                SetTextColor(DCDC,C_OPERADOR)          
                SelectObject(DCDC,FONTE(AF_TEXT))
                FSYY = WIDCHAR(AF_TEXT,-1)
                exit for
              end if
              
            case Apostrofo          ' verifica comentario (')
              if CNT > STPOS then exit for            
              CNT = MAXLL
              TTYPE = TT_COMMENT
              SetBkMode(DCDC,OPAQUE)
              SetTextColor(DCDC,C_COMMENT)
              SetBkColor(DCDC,C_COMMENTBK)
              SelectObject(DCDC,FONTE(AF_COMMENT))
              FSYY = WIDCHAR(AF_COMMENT,-1)
              exit for          
            case Aspas              ' verifica aspas
              if CNT > STPOS then exit for
              do
                SEA = instr(CNT+2,TMPLIN,chr$(Aspas))
                SEB = instr(CNT+2,TMPLIN,chr$(Aspas,Aspas))
                if SEA = 0 then 
                  CNT = MAXLL
                  TTYPE = TT_ASPAS
                  SetBkMode(DCDC,TRANSPARENT)
                  SetTextColor(DCDC,C_ASPAS)          
                  SelectObject(DCDC,FONTE(AF_ASPAS))
                  FSYY = WIDCHAR(AF_ASPAS,-1)
                  exit for
                end if
                if SEB=0 or (SEA< SEB) then  
                  CNT = SEA
                  TTYPE = TT_ASPASPAR
                  SetBkMode(DCDC,TRANSPARENT)
                  SetTextColor(DCDC,C_ASPASPAR)
                  SelectObject(DCDC,FONTE(AF_TEXT))
                  FSYY = WIDCHAR(AF_TEXT,-1)
                  exit for
                end if
                CNT = SEB+1
              loop
            case 38                 ' & Operator / number
              if CNT > STPOS then exit for
              SetBkMode(DCDC,TRANSPARENT)
              CNT += 1
              if CNT <= STEND then
                select case LCLIN[CNT]
                case 98,104,11                  
                  TTYPE = TT_NUMERO                  
                  SelectObject(DCDC,FONTE(AF_TEXT))
                  FSYY = WIDCHAR(AF_TEXT,-1)
                  SetTextColor(DCDC,C_NUMERO)                  
                  for CNT = CNT+1 to STEND
                    select case LCLIN[CNT]
                    case 46,48 to 57,97 to 102,120
                      rem nada
                    case else
                      exit for                  
                    end select
                  next CNT                  
                  exit for
                case else
                  TTYPE = TT_OPERADOR
                  SelectObject(DCDC,FONTE(AF_OPERADORES))
                  FSYY = WIDCHAR(AF_OPERADORES,-1)
                  SetTextColor(DCDC,C_OPERADOR)
                  exit for
                end select
              else
                TTYPE = TT_OPERADOR
                SelectObject(DCDC,FONTE(AF_OPERADORES))
                FSYY = WIDCHAR(AF_OPERADORES,-1)
                SetTextColor(DCDC,C_OPERADOR)
                exit for
              end if
              
            case 48 to 57           ' verifica numeros
              if CNT > STPOS then exit for
              TTYPE = TT_NUMERO
              SetBkMode(DCDC,TRANSPARENT)
              SetTextColor(DCDC,C_NUMERO)
              SelectObject(DCDC,FONTE(AF_TEXT))
              FSYY = WIDCHAR(AF_TEXT,-1)
              for CNT = CNT to STEND
                select case LCLIN[CNT]
                case 46,48 to 57,97 to 102,120
                  rem nada
                case else
                  exit for                  
                end select
              next CNT
              exit for
              
            case 97 to 122,46,95    ' verifica tokens (a-z)
              if CNT > STPOS then exit for            
              STTOK = CNT
              TTYPE = TT_TOKEN
              for CNT = CNT to STEND
                select case LCLIN[CNT]
                case 33,35,36 to 38,46,48 to 58,64,95,97 to 122
                  rem nada
                case else              
                  exit for
                end select
              next CNT            
              exit for          
            case 33,35,37,40 to 45,47,58 to 64,91 to 94,123 to 126
              if CNT > STPOS then exit for
              CNT += 1
              TTYPE = TT_OPERADOR
              SetBkMode(DCDC,TRANSPARENT)
              SetTextColor(DCDC,C_OPERADOR)
              SelectObject(DCDC,FONTE(AF_OPERADORES))
              FSYY = WIDCHAR(AF_OPERADORES,-1)
              exit for
            end select
            
          next CNT
          
          if TTYPE = TT_TOKEN then  ' token como palavra chave
            TMPTOK = trim$(mid$(LCLIN,STTOK+1,(CNT-STTOK)))          
            if len(TMPTOK) then
              FTC = (TMPTOK[0]) and 31
              for WRDLST = 1 to EDWDATA(FTC,0)
                if TMPTOK = EDWORD(FTC,WRDLST) then
                  SetBkColor(DCDC,C_FUNDO)
                  SetTextColor(DCDC,C_GROUP(EDWDATA(FTC,WRDLST)))
                  SelectObject(DCDC,FONTE(AF_GROUPS))
                  FSYY = WIDCHAR(AF_GROUPS,-1)
                  exit for
                end if
              next WRDLST            
              if WRDLST > EDWDATA(FTC,0) then
                SetBkMode(DCDC,TRANSPARENT)
                SetTextColor(DCDC,C_TEXTO)
                SelectObject(DCDC,FONTE(AF_TEXT))
                FSYY = WIDCHAR(AF_TEXT,-1)
              end if            
            end if
          end if
          
          if TTYPE = TT_NORMAL then ' sem coloração
            SetBkMode(DCDC,TRANSPARENT)
            SetTextColor(DCDC,C_TEXTO)
            SelectObject(DCDC,FONTE(AF_TEXT))
            FSYY = WIDCHAR(AF_TEXT,-1)
          end if
          
          #ifdef Debug_Text
          static BKC as integer
          BKC = 1-BKC: color 15,BKC+1
          print mid$(TMPLIN,STPOS+1,(CNT-STPOS));
          #endif
          POX = SCRX mod FSX 
          POXB = fix(SCRX/FSX)
          POXC = (CNT-STPOS)
          if POXC > MAINRCT.right/FSX then POXC = MAINRCT.right/FSX
          if POXC+STPOS+POXB > len(TMPLIN) then
            POXC = len(TMPLIN)-STPOS-POXB
          end if
          
          TextOut(DCDC,BORX-POX+((STPOS)*FSX),YY+((FSY-FSYY) shr 1),strptr(TMPLIN)+STPOS+POXB,POXC)          
          STPOS = CNT:STTOK = 0
          
        loop until CNT > STEND
        
        #ifdef Debug_Text
        color 13,0:print "<"
        #endif
        
      else                             '' sem cores na sintaxe
        
        SetBkMode(DCDC,TRANSPARENT)
        SetTextColor(DCDC,C_TEXTO)
        SelectObject(DCDC,FONTE(AF_TEXT))
        FSYY = WIDCHAR(AF_TEXT,-1)
        POX = SCRX mod FSX
        POXB = fix(SCRX/FSX)
        POXC = len(TMPLIN)-POXB
        if POXC > MAINRCT.right/FSX then POXC = MAINRCT.right/FSX
        TextOut(DCDC,BORX-POX,YY,strptr(TMPLIN)+POXB,POXC)
        
      end if
      
      while                            '' Texto selecionado
        
        ArrangeSelection(SEX,SEY,SEXX,SEYY)
        if SEX > MAXLL then SEX = MAXLL
        if SEXX > MAXLL then SEXX = MAXLL
        
        if SEX<>SEXX or SEY<>SEYY then
          SetBkMode(DCDC,OPAQUE)
          SetTextColor(DCDC,C_SELEC)
          SetBkColor(DCDC,C_SELECBK)
          SelectObject(DCDC,FONTE(AF_TEXT))
          if COUNT = SEY then
            STPOS = SEX
            if SEY <> SEYY then              
              TextOut(DCDC,BORX-SCRX+((STPOS)*FSX),YY,strptr(TMPLIN)+(STPOS),(MAXLL-STPOS))
            else
              CNT = SEXX
              TextOut(DCDC,BORX-SCRX+((STPOS)*FSX),YY,strptr(TMPLIN)+(STPOS),(CNT-STPOS))
            end if
          elseif COUNT = SEYY then
            if SEYY <> SEY then
              CNT = SEXX
              'dim as integer POX,PFX
              'POX = fix(SCRX/FSX)
              'PFX = SCRX-(POX*FSX)
              TextOut(DCDC,BORX-SCRX,YY,strptr(TMPLIN),CNT)
            end if
          elseif COUNT > SEY and COUNT < SEYY then
            TextOut(DCDC,BORX-SCRX,YY,strptr(TMPLIN),MAXLL)
          end if
          
        end if
        
      wend
      
    next YY
    
  wend
  while                                 '' Cursor e rolagem
    
    BIGLIN = 0
    for YY = 0 to EDMAXLINES
      COUNT = len(EDLIN(ATUDOC,YY))
      if COUNT > BIGLIN then BIGLIN = COUNT      
    next YY
    if EDCURPOS > BIGLIN then EDCURPOS = BIGLIN
    
    CNTX = ((MAINRCT.right)-BORX)/FSX
    CNTY = (MAINRCT.bottom)/FSY
    
    dim as SCROLLINFO HSINFO,VSINFO
    
    with HSINFO
      .cbSize = sizeof(SCROLLINFO)
      .fmask = SIF_ALL
    end with
    with VSINFO
      .cbSize = sizeof(SCROLLINFO)
      .fmask = SIF_ALL
    end with
    
    ''
    '' horizontal
    ''
    #ifndef UseHX
    if BIGLIN > CNTX then      
      EnableScrollBar(hctl(CTL_EDITAREA),SB_HORZ,ESB_ENABLE_BOTH)      
      GetScrollInfo(hctl(CTL_EDITAREA),SB_HORZ,@HSINFO)      
      with HSINFO
        .nMin = 0
        .nMax = BIGLIN*FSX
        .npage = CNTX*FSX
      end with
      SetScrollInfo(hctl(CTL_EDITAREA),SB_HORZ,@HSINFO,true)
    else
      EnableScrollBar(hctl(CTL_EDITAREA),SB_HORZ,ESB_DISABLE_BOTH)
    end if
    #endif
    
    ''
    '' vertical
    ''
    #ifndef UseHX
    if EDMAXLINES > int(MAINRCT.bottom/FSY) then
      EnableScrollBar(hctl(CTL_EDITAREA),SB_VERT,ESB_ENABLE_BOTH)
      GetScrollInfo(hctl(CTL_EDITAREA),SB_VERT,@VSINFO)
      with VSINFO
        .nMin = 0
        .nMax = EDMAXLINES-1        
        .npage = cint(MAINRCT.bottom/FSY)
      end with
      SetScrollInfo(hctl(CTL_EDITAREA),SB_VERT,@VSINFO,true)
    else
      EnableScrollBar(hctl(CTL_EDITAREA),SB_VERT,ESB_DISABLE_BOTH)
    end if
    #endif
    
    COUNT = -SCRX+BORX+EDCURPOS*FSX
    if COUNT < BORX or COUNT > MAINRCT.right then
      if EDATULIN-SCRY > 0 and EDATULIN-SCRY < int(MAINRCT.bottom/FSY) then
        if ISCARET then
          #ifndef UseHX
          HideCaret(hctl(CTL_EDITAREA))
          #endif
          ISCARET = False
        end if
      end if
    else
      if ISCARET = False then
        #ifndef UseHX
        ShowCaret(hctl(CTL_EDITAREA))
        #endif
        ISCARET = True
      end if
    end if
    
    #ifndef UseHX
    SetCaretPos(COUNT,((EDATULIN-1)-SCRY)*FSY)  
    #endif
    SelectClipRgn(DCDC,null)  
    TMPTXT = (EDATULIN) & " : " & (EDCURPOS+1)
    SendMessage(HCTL(CTL_STATUSBAR),SB_SETTEXT,1,cast(lparam,strptr(TMPTXT)))  
    DeleteObject(BKBRUSH)
    DeleteObject(IDBRUSH)
    SelectObject(DCDC,OLDFNT)
    
    static TMR as double
    
  wend
  
end sub
' ******************** Função para calcular tamanho de uma string ***************************
function GetTextWidth(FONTH as integer,TEXT as string) as integer
  dim as integer RESULT
  for COUNT as integer = 0 to len(TEXT)-1
    RESULT += WIDCHAR(FONTH,TEXT[COUNT])
  next COUNT
  return RESULT
end function
' *********************** Função ajeitar a posição da seleção *******************************
sub ArrangeSelection(byref SEX as integer,byref SEY as integer,byref SEXX as integer,byref SEYY as integer)
  SEX=SELX:SEY=SELY:SEXX=SELXX:SEYY=SELYY
  
  dim as integer SWX,SWY
  
  if SEX > SEXX then
    if SEY>=SEYY then swap SEX,SEXX:SWX=1
  end if
  if SEY > SEYY then
    swap SEY,SEYY
    if SWX = 0 then
      swap SEX,SEXX
    end if
  end if  
  
end sub
