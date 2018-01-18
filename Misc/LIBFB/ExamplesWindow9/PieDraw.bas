#Include "window9.bi"
Dim Shared As integer event,M,f
Dim Shared As HWND hwnd
hwnd=OpenWindow("",100,100,160,180)
Sub DR
WindowStartDraw(hwnd,0,0,200,200) 
FillRectDraw(10,10,&hf0f0f0)
PieDraw(10,10,120,120,150,20+M,160,130-M,255,&hff0000,2)
CircleDraw(95,35+M\20,10,&h00ffFF,&h00ff,4)
StopDraw 
If f=0 Then
 M+=3
Else
 M-=3
EndIf
If M=54 Then f=1
If M=0 Then f=0
End Sub
SetTimer(hwnd,1,1,@DR)
Do : Loop Until WaitEvent= EventClose

