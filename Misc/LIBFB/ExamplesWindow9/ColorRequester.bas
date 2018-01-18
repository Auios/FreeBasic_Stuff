#Include "window9.bi"
Dim As integer hwnd ,event
hwnd=OpenWindow("1",30,30,500,500)
WindowColor(hwnd, ColorRequester() )
Do
 event=WaitEvent()
 If event=EventClose Then End
Loop

