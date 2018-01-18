#Include once "window9.bi"
Dim Shared  As HWND ph 
ph=OpenWindow("",10,10,500,500)
ContainerGadget(4,100,0,300,300)
ButtonGadget(1,10,10,100,20)
ButtonGadget(2,10,40,100,30)
ImageGadget(3,200,200,100,100,Load_image("C:\WINDOWS\system32\oobe\images\merlin.gif",&hf0f0f0))
' must be !!!
' type TIMERPROC as sub (byval as HWND, byval as UINT, byval as UINT, byval as DWORD)
Sub TT(byval hWin as HWND, byval p1 as UINT, byval p2 as UINT, byval p3 as DWORD)
 Static As Integer x,y
 x=Rnd*200
 y=Rnd*200
 Resizegadget(4,x,y)
 SetGadgetColor(4,x*Rnd*100000,0,1)
End Sub
SetTimer(ph,1,500,@tt)
Do
 Var ev=WindowEvent
 If ev=EventClose Then End
Loop

