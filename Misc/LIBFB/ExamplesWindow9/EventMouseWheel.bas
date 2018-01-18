#Include "window9.bi"
var aa =0
var hwnd = OpenWindow("",10,10,200,200)
TextGadget(1,10,50,100,20,"Text")


Do
 Var event=WaitEvent
 Select Case event
  Case EventClose
   If EventHwnd=hwnd Then End
  Case EventMouseWheel
   If  EventKEY<0 Then
    aa+=1
    SetGadgetText(1,Str(aa))
   Else
    aa-=1
    SetGadgetText(1,Str(aa))
   EndIf
 End Select
loop

