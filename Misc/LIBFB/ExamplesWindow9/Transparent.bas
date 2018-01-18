#Include "window9.bi" 

Dim As Integer event
Dim as HWND hwnd
hwnd=OpenWindow("Привет",10,10,320,250) : CenterWindow(hwnd)
WindowStartDraw(hwnd,0,0,320,250) 'начинаем рисование
  CircleDraw(100,100,100,,255)
  CircleDraw(200,100,100,,&hff0000,,,100)
  BoxDraw(100,15,100,170,&hffffff,&hffffff,,,100)
  FillRectDraw(260,30,&hff0000)
  FillRectDraw(5,5,&h00ff00)
StopDraw ' заканчиваем рисование
Do
 event=WindowEvent()
 If Event=EventClose Then End
Loop 

