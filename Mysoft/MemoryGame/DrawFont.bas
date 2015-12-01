' FBGFX Font Render by Mysoft

'' DrawFont([BUFFER],[POSX],[POSY],"STRING","Font Name",FontSize,[Color],[Style],[Charset])

''uncomment the line below if you want the program to use unicode
'#define Unicode

'' this define allow you to set some effect while using anti-alias/blur (1 to 2)
#ifndef GAMMA
#define GAMMA 1.1
#endif

#include once "windows.bi"
#include once "fbgfx.bi"

enum Charsets 'already denfined
  NULL_CHARSET = 0
  'ANSI_CHARSET
  'DEFAULT_CHARSET
  'SYMBOL_CHARSET
  'SHIFTJIS_CHARSET
  'GB2312_CHARSET
  'HANGEUL_CHARSET
  'CHINESEBIG5_CHARSET
  'OEM_CHARSET
end enum

enum TextStyle
  FS_SOLID = 1
  FS_BOLD = 2
  FS_ITALIC = 4  
  FS_ANTIALIAS = 8
  FS_BLUR = 16+8
  FS_CENTER = 32
  FS_HQ = 64
end enum

declare sub DrawFont(BUFFER as any ptr=0,POSX as integer, POSY as integer, _
FTEXT as string, FNAME as string,FSIZE as integer, _
FCOLOR as uinteger=rgb(255,255,255), BKGCOLOR as uinteger=rgb(0,0,0), _
FSTYLE as integer=0, CHARSET as integer=DEFAULT_CHARSET)

' ***********************************************************************
' ***********************************************************************
' ***********************************************************************

sub DrawFont(BUFFER as any ptr=0,POSX as integer, POSY as integer, _
  FTEXT as string, FNAME as string,FSIZE as integer, _
  FCOLOR as uinteger=rgb(255,255,255), BKGCOLOR as uinteger=rgb(0,0,0), _
  FSTYLE as integer=0, CHARSET as integer=DEFAULT_CHARSET)
  
  'FSTYLE = FSTYLE and -((FS_BLUR)+1)
  
  ' allocating as static for speed
  static FINIT as integer
  static as hdc THEDC
  static as hbitmap THEBMP
  static as any ptr THEPTR,MYBLK  
  static as fb.image ptr FBBLK
  static as integer WIDCHAR(65535)
  static as integer TXTSZ,COUNT,RESU,RESUU
  dim as integer TX,TY
  static as integer ALP
  static as any ptr SRCBUF,DSTBUF
  static as hfont THEFONT
  static as integer FW,FI,TXYY,FCOR
  static DSKWND as hwnd, DSKDC as hdc
  static MYBMPINFO as BITMAPINFO
  static as TEXTMETRIC MYTXINFO
  static as SIZE TXTSIZE
  static as RECT RCT  
  static as double MPE,MPZ
  
  #define FontSize(PointSize) -MulDiv(PointSize, GetDeviceCaps(THEDC, LOGPIXELSY), 72)  
  
  if FINIT = 0 then
    '' allocating things and starting the "engine"
    FINIT = 1    
    with MYBMPINFO.bmiheader
      .biSize = sizeof(BITMAPINFOHEADER)
      .biWidth = 2048
      .biHeight = -513
      .biPlanes = 1
      .biBitCount = 32
      .biCompression = BI_RGB
    end with    
    ' creating a DC and a bitmap that will receive the rendered font
    DSKWND = 0 'GetDesktopWindow()
    DSKDC = GetDC(DSKWND)
    THEDC = CreateCompatibleDC(DSKDC)
    THEBMP = CreateDIBSection(THEDC,@MYBMPINFO,DIB_RGB_COLORS,@THEPTR,null,null)    
    ReleaseDC(DSKWND,DSKDC)    
  end if
  
  ' creating the font
  if (FSTYLE and FS_BOLD) then FW = FW_BOLD else FW = FW_NORMAL    
  if (FSTYLE and FS_ITALIC) then FI = True else FI = False    
  
  THEFONT = CreateFont(FontSize(FSIZE),0,0,0,FW,FI,0,0,CHARSET,0,0,0,0,cast(any ptr,strptr(FNAME)))    
  
  ' selecting it
  SelectObject(THEDC,THEBMP)
  SelectObject(THEDC,THEFONT)  
  GetTextMetrics(THEDC,@MYTXINFO)    
  ' get text width/height
  GetTextExtentPoint32(THEDC,strptr(FTEXT),len(FTEXT),@TXTSIZE)  
  TXTSZ = TXTSIZE.CX'*1.5
  TXYY = (TXTSIZE.CY+MYTXINFO.tmExternalLeading)'*1.5 'TXTSIZE.CY
  if (FSTYLE and FS_ITALIC) then 
    if MYTXINFO.tmOverhang then
      TXTSZ += MYTXINFO.tmOverhang
    else
      TXTSZ += 1+(FSIZE/2)
    end if
    TXYY += 1+(FSIZE/4)
  end if  
  if (FSTYLE and FS_ANTIALIAS) then 
    #if GAMMA>1 and GAMMA <= 2
    TXTSZ += GAMMA*2
    #endif
  end if
  with RCT
    .LEFT = 0
    .TOP = 1
    .RIGHT = TXTSZ
    .BOTTOM = TXYY+1
  end with
  TXTSZ -= 1
  TXYY -= 1
  ' RGB to BGR
  asm
    mov eax,[FCOLOR]
    mov ebx,[BKGCOLOR]
    and eax,0xFFFFFF
    and ebx,0xFFFFFF
    mov [FCOR],eax
    bswap eax
    bswap ebx
    ror eax,8
    ror ebx,8
    mov [FCOLOR],eax
    mov [BKGCOLOR],ebx
  end asm  
  ' Set Colors
  if (FSTYLE and FS_SOLID) = 0 then BKGCOLOR = rgba(255,0,255,0)
  SetBkColor(THEDC,BKGCOLOR)
  SetTextColor(THEDC,FCOLOR)
  
  ' disabling font smooth,rendering and enable again (if applicable)
  if (FSTYLE and FS_SOLID)=0 then SystemParametersInfo(SPI_GETFONTSMOOTHING,null,@RESU,null)
  if RESU and (FSTYLE and FS_SOLID)=0 then 
    SystemParametersInfo(SPI_SETFONTSMOOTHING,False,@RESUU,null)
  end if
  ExtTextOut(THEDC,0,1,ETO_CLIPPED or ETO_OPAQUE,@RCT,strptr(FTEXT),len(FTEXT),null)
  if RESU and (FSTYLE and FS_SOLID)=0 then 
    SystemParametersInfo(SPI_SETFONTSMOOTHING,True,@RESUU,null)
  end if
  GDIFlush()
  
  ' filling FBGFX header
  FBBLK = THEPTR+(2048*4)-sizeof(fb.image)
  FBBLK->type = 7
  FBBLK->bpp = 4
  FBBLK->width = TXTSZ
  FBBLK->height = TXYY
  FBBLK->pitch = 2048*4
  
  ' blitting the rendered font to destion
  if (FSTYLE and FS_ANTIALIAS) then    
    MYBLK = THEPTR+(2048*4)
    asm
      mov ecx,511
      mov ebx,[FCOR]
      mov esi,[MYBLK]
      mov eax,[TXTSZ]
      shl eax,2      
      _CBNEXTLINE_:      
      xor edi,edi      
      _CBNEXTPIXEL_:
      cmp [esi+edi], dword ptr 0xFF00FF      
      je _TRANS_
      mov [esi+edi+3], byte ptr 0xFF
      _TRANS_:      
      and [esi+edi], dword ptr 0xFF000000
      or [esi+edi], ebx
      add edi,4
      cmp edi,eax
      jbe _CBNEXTPIXEL_
      add esi,2048*4
      dec ecx
      jnz _CBNEXTLINE_
    end asm
    
    #define GetAlpha(PX,PY) peek(MYBLK+((PY)*8192)+((PX)*4)+3)
    #define SetAlpha(PX,PY,NA) poke(MYBLK+((PY)*8192)+((PX)*4)+3),NA
    
    if (FSTYLE and FS_BLUR) = FS_BLUR then
      ' blur primeira linha
      for TX = 1 to TXTSZ-1
        ALP = (GetAlpha(TX,0)+GetAlpha(TX+1,0)+GetAlpha(TX-1,0)+ _
        GetAlpha(TX,1)+GetAlpha(TX-1,1)+GetAlpha(TX+1,1)) / 6
        #if GAMMA>1 and GAMMA <= 1.6
        ALP *= (GAMMA+.5)
        if ALP > 255 then ALP = 255        
        if ALP < 32 then ALP = 0
        #endif        
        SetAlpha(TX,TY,ALP)
      next TX
      ' blur conteudo
      for TX = 1 to TXTSZ-1
        for TY = 1 to TXYY-1          
          ALP = (GetAlpha(TX,TY)+GetAlpha(TX+1,TY)+GetAlpha(TX-1,TY)+ _
          GetAlpha(TX,TY-1)+GetAlpha(TX,TY+1) + _
          GetAlpha(TX-1,TY-1)+GetAlpha(TX-1,TY+1)+ _
          GetAlpha(TX+1,TY-1)+GetAlpha(TX+1,TY+1)) / 9
          #if GAMMA>1 and GAMMA <= 1.6
          ALP *= (GAMMA+.5)
          if ALP > 255 then ALP = 255
          if ALP < 32 then ALP = 0
          #endif        
          SetAlpha(TX,TY,ALP)
        next TY
      next TX
      ' blur ultima linha
      for TX = 1 to TXTSZ-1
        ALP = (GetAlpha(TX,TY)+GetAlpha(TX+1,TY)+GetAlpha(TX-1,TY)+ _
        GetAlpha(TX,TY-1)+GetAlpha(TX-1,TY-1)+GetAlpha(TX+1,TY-1)) / 6
        #if GAMMA>1 and GAMMA <= 1.6
        ALP *= (GAMMA+.5)
        if ALP > 255 then ALP = 255
        if ALP < 32 then ALP = 0
        #endif
        SetAlpha(TX,TY,ALP)
      next TX
    else      
      ' antialias primeira linha
      for TX = 1 to TXTSZ-1
        ALP = (GetAlpha(TX,0)+GetAlpha(TX+1,0)+_
        GetAlpha(TX-1,0)+GetAlpha(TX,1))/4        
        #if GAMMA>1 and GAMMA <= 2
        ALP *= GAMMA
        if ALP > 255 then ALP = 255
        if ALP < 32 then ALP = 0
        #endif        
        SetAlpha(TX,TY,ALP)
      next TX
      ' antialias conteudo
      for TX = 1 to TXTSZ-1
        for TY = 1 to TXYY-1          
          ALP = (GetAlpha(TX,TY)+GetAlpha(TX+1,TY)+GetAlpha(TX-1,TY)+_
          GetAlpha(TX,TY+1)+GetAlpha(TX,TY-1))/5
          #if GAMMA>1 and GAMMA <= 2
          ALP *= GAMMA
          if ALP > 255 then ALP = 255
          if ALP < 32 then ALP = 0
          #endif          
          SetAlpha(TX,TY,ALP)          
        next TY
      next TX
      ' antialias ultima linha
      for TX = 1 to TXTSZ-1
        ALP = (GetAlpha(TX,TY)+GetAlpha(TX+1,TY)+ _
        GetAlpha(TX-1,TY)+GetAlpha(TX,TY-1))/4        
        #if GAMMA>1 and GAMMA <= 2
        ALP *= GAMMA
        if ALP > 255 then ALP = 255
        if ALP < 32 then ALP = 0
        #endif        
        SetAlpha(TX,TY,ALP)
      next TX
    end if    
    if (FSTYLE and FS_CENTER) then
      put BUFFER,(POSX-TXTSZ/2,POSY-TXYY/2),FBBLK,alpha
    else
      put BUFFER,(POSX,POSY),FBBLK,alpha
    end if
    
  else
    with *cptr(fb.image ptr, FBBLK)
      COUNT = (.pitch*.height)/4
    end with    
    if (FSTYLE and FS_HQ) then
      asm
        mov edi,[FBBLK]
        add edi,sizeof(fb.image)
        mov ecx,[COUNT]
        _FANEXTPTHQ_:
        mov eax,[edi]
        and eax,&b111100001111000011110000        
        jz _TRANSHQ_
        or dword ptr [edi],0xFF000000      
        _TRANSHQ_:
        add edi,4
        dec ecx
        jnz _FANEXTPTHQ_
      end asm
    else
      asm
        mov edi,[FBBLK]
        add edi,sizeof(fb.image)
        mov ecx,[COUNT]
        _FANEXTPT_:
        or dword ptr [edi],0xFF000000      
        add edi,4
        dec ecx
        jnz _FANEXTPT_
      end asm
    end if
    if (FSTYLE and FS_CENTER) then
      put BUFFER,(POSX-TXTSZ/2,POSY-TXYY/2),FBBLK,alpha,255
    else
      put BUFFER,(POSX,POSY),FBBLK,alpha,255
    end if
    
  end if
  
  ' cleanning up things
  DeleteObject(THEFONT)
  
end sub
