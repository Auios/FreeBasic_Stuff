#Include "window9.bi"
Dim As HWND hwnd
hwnd=OpenWindow("Test",10,10,500,500) : CenterWindow(hwnd)
StatusBarGadget(1,"StatusBarGadget")

Do 
 Var event=WaitEvent()
 If Event=EventClose Then End
Loop

