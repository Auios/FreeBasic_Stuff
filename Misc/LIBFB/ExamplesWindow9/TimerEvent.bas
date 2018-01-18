#Include "window9.bi"
Dim As HWND hwnd,hwnd2
hwnd=OpenWindow("",10,10,200,200)
hwnd2=OpenWindow("",220,10,200,200)
SetTimer(hwnd,1,200,0)
SetTimer(hwnd2,2,700,0)
Do
 Var event=WaitEvent
 Select Case event
  Case EventClose
   End
  Case EventTimer
   Select Case EventNumber
    Case 1     
     WindowColor(hwnd,BGR(0,255,0))
     WindowColor(hwnd2,BGR(0,0,255))
    Case 2
     WindowColor(hwnd,BGR(0,0,255))
     WindowColor(hwnd2,BGR(255,0,0))
   End Select
 End Select
Loop

