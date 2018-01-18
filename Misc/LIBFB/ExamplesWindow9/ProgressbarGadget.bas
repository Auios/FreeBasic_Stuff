#Include "window9.bi"
enum
  pbar = 1
end enum

Dim As Integer hwnd,event
var win = OpenWindow("window",10,10,350,100)
CenterWindow(win)

var dd=ProgressBarGadget(pbar,10,10,300,20,0,100)
SetGadgetColor(pbar,50000,0,3)
SetTimer(win,0,100,0)
var a=0
var b=70000
Do 
  var event=WaitEvent()
  If Event=EventClose Then   
    End
  ElseIf Event=EventTimer Then
    a+=20
    If a=120 Then
      a=0
      SetGadgetColor(pbar,b,b+20000,3)
      b+=20000
    End If
    SetGadgetState(pbar,a)
  End If
Loop

