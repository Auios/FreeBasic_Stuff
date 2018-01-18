#Include "collide.bi"
#include "fbgfx.bi"
Using fb

    #macro ppoint(_x,_y,colour)
    pixel=row+pitch*(_y)+(_x)*4
    (colour)=*pixel
    #EndMacro
    #macro ppset(_x,_y,colour)
    pixel=row+pitch*(_y)+(_x)*4
    *pixel=(colour)
    #EndMacro

#define RR( c ) ( CUInt( c ) Shr 16 And 255 )
#define RG( c ) ( CUInt( c ) Shr  8 And 255 )
#define RB( c ) ( CUInt( c )        And 255 )


Public Sub Lined(x As Integer,y As Integer,xv As Integer,yv As integer)
Dim as integer w,h,pitch,d
dim as any ptr row
dim as uinteger ptr pixel
Screeninfo w,h,,,pitch
row=ScreenPtr

dim as Single xnew,ynew,xdist1,ydist1
Dim As Single dx,dy,x3,y3,x2,y2,ynum,den,num,numadd,numpixels,curpixel,xinc1,xinc2,yinc1,yinc2
Dim As Integer alphac=0,r,g,b,aupd,i,s,j=2,xs,ys
r=255
g=255
b=0
x3=x
y3=y
x2=xv
y2=yv
dx = abs(x2 - x3):dy = abs(y2 - y3):xnew = x3:ynew = y3

if x2 >= x3 Then
  xinc1 = 1:xinc2 = 1
else
  xinc1 = -1:xinc2 = -1
End If

if y2 >= y3 Then
  yinc1 = 1:yinc2 = 1
else
  yinc1 = -1:yinc2 = -1
End If

if dx >= dy Then
  xinc1 = 0:yinc2 = 0:den = dx:num = dx / 2:numadd = dy:numpixels = dx
Else
  xinc2 = 0:yinc1 = 0:den = dy:num = dy / 2:numadd = dx:numpixels = dy
End If

curpixel=0
While curpixel <= numpixels
   Dim As Integer safe=0
   If j=2 And curpixel>5 And curpixel<numpixels-100 Then
   For s=0 To 1000 Step 120
   For i=0 To 1000 Step 240
   If xnew<i Then Exit For
   If ynew<s Then Exit For
   'If xnew>i+120 Then Exit For
   If ynew>s+60 Then Exit For 
   If collide_object(i,s,xnew,ynew,0,1,1,120,60,1)=0 Then Exit sub
   If collide_object(i,s,xnew,ynew,0,1,1,120,60,2)=0 Then Exit Sub
   If collide_object(i,s,xnew,ynew,0,1,1,120,60,3)=0 Then Exit Sub
   If collide_object(i,s,xnew,ynew,0,1,1,120,60,4)=0 Then Exit Sub
   Next
   Next
   End If
   If j=2 Then
      j=0
   ElseIf j<2 Then
      j+=1
   End If
   If safe=0 Then
      'PReset(xnew, ynew),RGBA(r,g,b,Alphac)
         If CInt(xnew)>0 And CInt(xnew)<1280 Then xs=CInt(xnew)
         If CInt(ynew)>0 and CInt(ynew)<1024 Then ys=CInt(ynew)
              ppoint(xs,ys,d)
              r=rr(d)
              If r<245 Then r+=10
              g=rg(d)
              If g<245 Then g+=10
              b=rb(d)
              If b<245 Then b+=10
            ppset(xs,ys,RGB(r,g,b))
   End if

  num += numadd
  if num >= den Then   num -= den:xnew += xinc1:ynew += yinc1
  xnew += xinc2:ynew += yinc2:curpixel+=1
  If aupd=0 and alphac<0 Then alphac=0
  If aupd=0 Then alphac=(curpixel*100)/numpixels
  If aupd=0 Then alphac=100-alphac
  If aupd=0 Then alphac=alphac*0.55
Wend

End Sub

Screenres 1280,1024,32,,GFX_ALPHA_PRIMITIVES' or GFX_FULLSCREEN
Dim As Integer x,y
Declare Sub glow(x As integer, y As integer,rad As integer,rady As integer)

Do
GetMouse x,y
'x=400
'y+=1
ScreenLock
Cls
BLoad "test_small.bmp"
glow(x, y,1200,720)

ScreenUnLock
Sleep 1
Loop Until MultiKey(1)

Sub glow(x As integer, y As integer,rad As integer,rady As integer)
  Dim i As Integer
  Dim x1 As Single, y1 As Single
  Dim x2 As Single, y2 As Single
  Dim stepv As Single
  Dim angle As Single
  Dim cosv As Single, sinv As Single
  
  rad = (rad) / 2
  rady = (rady) / 2

  stepv = Atn(1) / 100
  'draw lines
  For i = 0 To 799
    'find angle
    angle = stepv * i

    cosv = Cos(angle)
    sinv = Sin(angle)
    x1 = x
    y1 = y
    x2 = x + cosv * rad
    y2 = y + sinv * rady
    'draw each lines
    Lined (x1, y1,x2, y2)
  Next
End Sub
