'Fonts  by MYSOFT.
'====================================

#include "windows.bi"
#include "fbgfx.bi"
#include "crt.bi"
'FSTYLE 
 const FS_BOLD = 2
 const FS_ITALIC = 4 

Sub DrawFont(byref BUFFER As Any Ptr=0,byval POSX As long, byval POSY As long, _
  byref FTEXT As String, byref FNAME As String,byval FSIZE As long, _
 byval FCOLOR As Ulong=rgb(255,255,255),byval FSTYLE As long=0,byval CHARSET As long=DEFAULT_CHARSET )
 
  Static FINIT As long
  Static As hdc THEDC
  Static As hbitmap THEBMP
  Static As Any Ptr THEPTR
  Static As fb.image Ptr FBBLK
  Static As long TXTSZ,RESU,RESUU
  Static As hfont THEFONT
  Static As long FW,FI,TXYY',FCOR
  Static DSKWND As hwnd, DSKDC As hdc
  Static MYBMPINFO As BITMAPINFO
  Static As TEXTMETRIC MYTXINFO
  Static As SIZE TXTSIZE
  Static As RECT RCT
  static as ubyte ptr ubp
  ubp=cptr(ubyte ptr,@FCOLOR)
  swap ubp[0],ubp[2]
  dim as ubyte alphaval =ubp[3]
  ubp[3]=0
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
    RCT.LEFT = 0
    RCT.TOP = 1
    RCT.RIGHT = TXTSZ
    RCT.BOTTOM = TXYY+1
  TXTSZ -= 1
  TXYY -= 1
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
   Put BUFFER,(POSX,POSY),FBBLK,(0,0)-(TXTSZ-1,TXYY),alpha,alphaval
  DeleteObject(THEFONT)
End Sub

'old code
'========================= Qsort setup =====================================
#define up <,>
#define down >,<
#define values(x) @X(Lbound(X)),(Ubound(X)-Lbound(X)+1),Sizeof(X)
#macro SetSort(Datatype,FnName,b1,b2,dot)
Function FnName Cdecl(n1 As Any Ptr,n2 As Any Ptr) As long
    If *Cptr(Datatype Ptr,n1)dot b1 *Cptr(Datatype Ptr,n2)dot Then Return -1
    If *Cptr(DataType Ptr,n1)dot b2 *Cptr(DataType Ptr,n2)dot Then Return 1
End Function
#endmacro
'======================================================================


Dim As long xres,yres
xres=1024
yres=768
freeconsole
Screenres xres,yres,32,2
screenset 1,0

Screeninfo xres,yres
color ,rgb(0,50,0)

Type V3
    As long x,y,z
    As Ulong col
    #define map(a,b,x,c,d) ((d)-(c))*((x)-(a))\((b)-(a))+(c)
End Type

type _float 'FLOATS FOR TRIG
    as single sx,sy,sz
    as single cx,cy,cz
end type

Type sphere Extends V3
    As long r
End Type


Function RotatePoint(c As V3,p As V3,a as _float,scale As _float=Type<_float>(1,1,1)) As V3
    Dim As Single dx=p.x-c.x,dy=p.y-c.y,dz=p.z-c.z
    Return Type<V3>((scale.sx)*((a.cy*a.cz)*dx+(-a.cx*a.sz+a.sx*a.sy*a.cz)*dy+(a.sx*a.sz+a.cx*a.sy*a.cz)*dz)+c.x,_
    (scale.sy)*((a.cy*a.sz)*dx+(a.cx*a.cz+a.sx*a.sy*a.sz)*dy+(-a.sx*a.cz+a.cx*a.sy*a.sz)*dz)+c.y,_
    (scale.sz)*((-a.sy)*dx+(a.sx*a.cy)*dy+(a.cx*a.cy)*dz)+c.z,p.col)
End Function 

Function perspective(p As V3,eyepoint As V3) As V3
    Dim As Single   w=1+(p.z/eyepoint.z)
    Return Type<V3>((p.x-eyepoint.x)/w+eyepoint.x,(p.y-eyepoint.y)/w+eyepoint.y,(p.z-eyepoint.z)/w+eyepoint.z,p.col)
End Function

Function Regulate(Byval MyFps As long,Byref fps As long) As long
    Static As Double timervalue,_lastsleeptime,t3,frames
    Var t=Timer
    frames+=1
    If (t-t3)>=1 Then t3=t:fps=frames:frames=0
    Var sleeptime=_lastsleeptime+((1/myfps)-T+timervalue)*1000
    If sleeptime<1 Then sleeptime=1
    _lastsleeptime=sleeptime
    timervalue=T
    Return sleeptime
End Function

#define Intrange(f,l) int(Rnd*((l+1)-(f))+(f))

#define onsphere(S,P) _
(S.x-P.x)*(S.x-P.x)+(S.y-P.y)*(S.y-P.y)+(S.z-P.z)*(S.z-P.z) <= S.R*S.R Andalso _
(S.x-P.x)*(S.x-P.x)+(S.y-P.y)*(S.y-P.y)+(S.z-P.z)*(S.z-P.z) > (S.R-1)*(S.R-1)


dim as sphere S
dim as V3 centre=type<v3>(xres/2,yres/2,0),eye=type(xres/2,yres/2,xres/2)
s.x=xres/2
s.y=yres/2
s.z=0
s.r=yres/3
redim as v3 p(0)
dim as long ctr
dim as long _Max=4000

do
    var x=intrange((s.x-s.r),(s.x+s.r))
    var y=intrange((s.y-s.r),(s.y+s.r))
    var z=intrange((s.z-s.r),(s.z+s.r))
    dim as v3 pt=type<V3>(x,y,z)
        if onsphere(s,pt) then
              var xpos=map(0,_Max,ctr,(centre.x-s.r),(centre.x+s.r))
              line(centre.x-s.r,yres/2+1)-(xpos,yres/2+49),rgb(0,0,200),bf
            ctr+=1
            redim preserve p(1 to ctr)
            p(ctr)=pt
            p(ctr).col=rgb(rnd*255,rnd*255,rnd*255)
        end if
loop until ctr=_Max

SetSort(V3,Fnv3z,down,.z)

dim as V3 rot(lbound(p) to ubound(p))

dim as single ax,ay,az,sc=1,fsize=100
dim as _float F,scale=type<_float>(sc,sc,sc)
dim as single kx=1,ky=1
dim as string i
dim as long fps

do
    i=inkey
    if i=chr(255)+"H" then sc+=.01:fsize+=1
    if i=chr(255)+"P" then sc-=.01:fsize-=1
    scale=type(sc,sc,sc)
    ay+=.005
        F=type<_float>(sin(ax),sin(ay),sin(az), _
                      cos(ax),cos(ay),cos(az))
                    
    cls
    drawfont(,10,650,"Framerate = " &fps,"script",60,rgba(255,255,255,150),FS_BOLD)
    for z as long=lbound(p) to ubound(p)
        rot(z)=rotatepoint(centre,p(z),F,scale)
        rot(z)=perspective(rot(z),eye)
    next z
    qsort(values(rot),@FnV3z )
    for n as long=lbound(rot) to ubound(rot)
        var d=map(300,-300,rot(n).z,1,3)
        if rot(n).z<.05 and rot(n).z>-.05 then 
            drawfont(,xres/2,yres/2,"?","Comic Sans MS",fsize,rgba(200,100,0,255),FS_BOLD)
        end if
        circle(rot(n).x,rot(n).y),d*sc,rot(n).col,,,,f
    next n
    drawfont(,203,10,"Courier New","Courier New",60,rgba(200,0,0,255),FS_BOLD)
    drawfont(,210,10,"Courier New","Courier New",60,rgba(200,0,0,150),FS_BOLD)
    drawfont(,10,620,"Use Up/Down Arrow keys","system",10,rgb(255,255,255))
    flip
    sleep regulate(50,fps),1
    loop until i=chr(27) or i=chr(255) + "k"
sleep
 
 