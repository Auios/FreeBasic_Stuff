 
#include "windows.bi"
#include "fbgfx.bi"

enum TextStyle
  FS_BOLD = 2
  FS_ITALIC = 4 
  FS_ANTIALIAS = 8
  FS_BLUR = 16+8
End enum

'Fonts by Mysoft
Sub DrawFont(byref BUFFER As Any Ptr=0,byval POSX As Integer, byval POSY As Integer, _
  byref FTEXT As String, byref FNAME As String,byval FSIZE As Integer, _
 byval FCOLOR As Uinteger=rgba(255,255,255,0),byval FSTYLE As Integer=0,byval CHARSET As Integer=DEFAULT_CHARSET )
  Static FINIT As Integer
  Static As hdc THEDC
  Static As hbitmap THEBMP
  Static As Any Ptr THEPTR
  Static As fb.image Ptr FBBLK
  Static As Integer WIDCHAR(65535)
  Static As Integer TXTSZ,COUNT,RESU,RESUU
  Static As Any Ptr SRCBUF,DSTBUF
  Static As hfont THEFONT
  Static As Integer FW,FI,TXYY,FCOR
  Static DSKWND As hwnd, DSKDC As hdc
  Static MYBMPINFO As BITMAPINFO
  Static As TEXTMETRIC MYTXINFO
  Static As SIZE TXTSIZE
  Static As RECT RCT
 #define GAMMA 1.3
  #define FontSize(PointSize) -MulDiv(PointSize, GetDeviceCaps(THEDC, LOGPIXELSY), 72) 
 
  If FINIT = 0 Then   
    FINIT = 1   
    With MYBMPINFO.bmiheader
      .biSize = sizeof(BITMAPINFOHEADER)
      .biWidth = 2048
      .biHeight = -513
      .biPlanes = 1
      .biBitCount = 32
      .biCompression = BI_RGB
    End With   
    DSKWND = GetDesktopWindow()
    DSKDC = GetDC(DSKWND)
    THEDC = CreateCompatibleDC(DSKDC)
    THEBMP = CreateDIBSection(THEDC,@MYBMPINFO,DIB_RGB_COLORS,@THEPTR,null,null)  
    ReleaseDC(DSKWND,DSKDC)   
  End If
  If (FSTYLE And FS_BOLD) Then FW = FW_BOLD Else FW = FW_NORMAL   
  If (FSTYLE And FS_ITALIC) Then FI = True Else FI = False   
  THEFONT = CreateFont(FontSize(FSIZE),0,0,0,FW,FI,0,0,CHARSET,0,0,0,0,cast(Any Ptr,Strptr(FNAME)))   
  SelectObject(THEDC,THEBMP)
  SelectObject(THEDC,THEFONT)
  GetTextMetrics(THEDC,@MYTXINFO)
  GetTextExtentPoint32(THEDC,Strptr(FTEXT),Len(FTEXT),@TXTSIZE) 
  TXTSZ = TXTSIZE.CX
  TXYY = TXTSIZE.CY
  If (FSTYLE And FS_ITALIC) Then
    If MYTXINFO.tmOverhang Then
      TXTSZ += MYTXINFO.tmOverhang
    Else
      TXTSZ += 1+(FSIZE/2)
    End If
    TXYY += 1+(FSIZE/8)
  End If
  If (FSTYLE And FS_ANTIALIAS) Then
    #if GAMMA>1 And GAMMA <= 2
    TXTSZ += GAMMA*2
    #endif
  End If
  With RCT
    .LEFT = 0
    .TOP = 1
    .RIGHT = TXTSZ
    .BOTTOM = TXYY+1
  End With
  TXTSZ -= 1
  TXYY -= 1
  asm
    mov eax,[FCOLOR]
    And eax,0xFFFFFF
    mov [FCOR],eax
    bswap eax
    ror eax,8
    mov [FCOLOR],eax
  End asm
  SetBkColor(THEDC,rgba(255,0,255,0))
  SetTextColor(THEDC,FCOLOR)
  SystemParametersInfo(SPI_GETFONTSMOOTHING,null,@RESU,null)
  If RESU Then SystemParametersInfo(SPI_SETFONTSMOOTHING,False,@RESUU,null)
  ExtTextOut(THEDC,0,1,ETO_CLIPPED Or ETO_OPAQUE,@RCT,Strptr(FTEXT),Len(FTEXT),null)
  If RESU Then SystemParametersInfo(SPI_SETFONTSMOOTHING,True,@RESUU,null)
  FBBLK = THEPTR+(2048*4)-sizeof(fb.image)
  FBBLK->type = 7
  FBBLK->bpp = 4
  FBBLK->width = 2048
  FBBLK->height = 512
  FBBLK->pitch = 2048*4
  If (FSTYLE And FS_ANTIALIAS) Then
    Dim As Any Ptr MYBLK
    MYBLK = THEPTR+(2048*4)
    asm
      mov ecx,2048*511
      mov ebx,[FCOR]
      mov esi,[MYBLK]     
      HERE:
      cmp [esi], dword Ptr 0xFF00FF     
      je _TRANS_
      mov [esi+3], Byte Ptr 0xFF     
      _TRANS_:     
      And [esi], dword Ptr 0xFF000000
      Or [esi], ebx
      add esi,4
      dec ecx
      jnz HERE
    End asm
   
    Dim As Integer TX,TY
    Dim As Integer ALP
    #define GetAlpha(PX,PY) Peek(MYBLK+((PY)*8192)+((PX)*4)+3)
    #define SetAlpha(PX,PY,NA) Poke(MYBLK+((PY)*8192)+((PX)*4)+3),NA
    If (FSTYLE And FS_BLUR) = FS_BLUR Then
      For TX = 1 To TXTSZ-1
        ALP = (GetAlpha(TX,0)+GetAlpha(TX+1,0)+GetAlpha(TX-1,0)+ _
        GetAlpha(TX,1)+GetAlpha(TX-1,1)+GetAlpha(TX+1,1)) / 6
        #if GAMMA>1 And GAMMA <= 1.6
        ALP *= (GAMMA+.5)
        If ALP > 255 Then ALP = 255
        #endif
        SetAlpha(TX,TY,ALP)
      Next TX
      For TX = 1 To TXTSZ-1
        For TY = 1 To TXYY-1         
          ALP = (GetAlpha(TX,TY)+GetAlpha(TX+1,TY)+GetAlpha(TX-1,TY)+ _
          GetAlpha(TX,TY-1)+GetAlpha(TX,TY+1) + _
          GetAlpha(TX-1,TY-1)+GetAlpha(TX-1,TY+1)+ _
          GetAlpha(TX+1,TY-1)+GetAlpha(TX+1,TY+1)) / 9
          #if GAMMA>1 And GAMMA <= 1.6
        ALP *= (GAMMA+.5)
        If ALP > 255 Then ALP = 255
        #endif
          SetAlpha(TX,TY,ALP)
        Next TY
      Next TX
      For TX = 1 To TXTSZ-1
        ALP = (GetAlpha(TX,TY)+GetAlpha(TX+1,TY)+GetAlpha(TX-1,TY)+ _
        GetAlpha(TX,TY-1)+GetAlpha(TX-1,TY-1)+GetAlpha(TX+1,TY-1)) / 6
        #if GAMMA>1 And GAMMA <= 1.6
        ALP *= (GAMMA+.5)
        If ALP > 255 Then ALP = 255
        #endif
        SetAlpha(TX,TY,ALP)
      Next TX
    Else     
      For TX = 1 To TXTSZ-1
        ALP = (GetAlpha(TX,0)+GetAlpha(TX+1,0)+_
        GetAlpha(TX-1,0)+GetAlpha(TX,1))/4       
        #if GAMMA>1 And GAMMA <= 2
        ALP *= GAMMA
        If ALP > 255 Then ALP = 255
        #endif       
        SetAlpha(TX,TY,ALP)
      Next TX
      For TX = 1 To TXTSZ-1
        For TY = 1 To TXYY-1
          ALP = (GetAlpha(TX,TY)+GetAlpha(TX+1,TY)+GetAlpha(TX-1,TY)+_
          GetAlpha(TX,TY-1)+GetAlpha(TX,TY+1))/5
          #if GAMMA>1 And GAMMA <= 2
          ALP *= GAMMA
          If ALP > 255 Then ALP = 255
          #endif         
          SetAlpha(TX,TY,ALP)         
        Next TY
      Next TX
      For TX = 1 To TXTSZ-1
        ALP = (GetAlpha(TX,TY)+GetAlpha(TX+1,TY)+ _
        GetAlpha(TX-1,TY)+GetAlpha(TX,TY-1))/4       
        #if GAMMA>1 And GAMMA <= 2
        ALP *= GAMMA
        If ALP > 255 Then ALP = 255
        #endif       
        SetAlpha(TX,TY,ALP)
      Next TX
    End If
    Put BUFFER,(POSX,POSY),FBBLK,(0,0)-(TXTSZ-1,TXYY),alpha
  Else 
    Put BUFFER,(POSX,POSY),FBBLK,(0,0)-(TXTSZ-1,TXYY),trans
  End If
  DeleteObject(THEFONT)
End Sub

'============  EXAMPLE =====================
dim  as string s1:s1="Times New Roman" 
dim  as string s2:s2="Comic Sans MS"
dim as string s4="Courier New",s6="Arial",s8="Vivaldi"
screen 19,32
#define cc rgb(rnd*255,rnd*255,rnd*255)
drawfont(,20,20,"Times New Romanm size 20",s1,20,cc)
drawfont(,20,50,"Comic Sans MS, size 20",s2,20,cc)
drawfont(,20,100,"Courier New, size 40",s4,40,cc)
drawfont(,20,180,"Arial,size 50",s6,50,cc)
drawfont(,20,250,"Vivaldi,size 20",s8,20,cc)
drawfont(,20,290,"Vivaldi,size 20, italic",s8,20,cc,FS_ITALIC)
drawfont(,20,330,"Arial,size 60, smooth",s6,60,cc,FS_ANTIALIAS)
drawfont(,20,420,"Vivaldi,size 30, bold and smooth",s8,30,cc,FS_ANTIALIAS or FS_BOLD)
DrawFont(,90,480,"¯±ÈÞ","Webdings",100,cc,FS_BLUR)
draw string (20,500), "Press a key"

sleep
 

 