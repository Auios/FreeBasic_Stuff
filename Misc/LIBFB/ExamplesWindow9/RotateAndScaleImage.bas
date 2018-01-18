#Include "window9.bi"
Dim Shared As HBITMAP hbmpSource,hbmpDest
hbmpSource=Create_Image(80,80)
hbmpDest=Create_Image(100,100)
Dim As Integer event
Dim As HWND hwnd

Sub rot()
  Static f As Single
  RotateAndScaleImage(hbmpSource,hbmpDest,50,50,40,40,f,f/300,f/300,&hf0f0f0)
  SetImageGadget(1,hbmpDest)
  RotateAndScaleImage(hbmpSource,hbmpDest,50,50,40,40,-f,f/300,f/300,&hf0f0f0)
  SetImageGadget(2,hbmpDest)
  f= f+1
  If f>=360 Then f=0
  Sleep(1)
End Sub

ImageStartDraw(hbmpSource)
 FillRectDraw(10,10,&hf0f0f0)
 LineDraw(40,0,40,80,4,255)
 LineDraw(0,40,80,40,4,&hFF0000)
StopDraw

hwnd=OpenWindow("Rotate",10,10,230,150) : CenterWindow(hwnd)
ImageGadget(1,5,5,100,100)
ImageGadget(2,105,5,100,100)
Do
 event=WindowEvent()
 If Event=EventClose Then End
 rot()
Loop

