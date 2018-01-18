#Include "window9.bi"

OpenWindow("",10,10,200,200)
ButtonGadget(1,10,10,100,20)
TextGadget(2,10,50,100,20,"?????")

Do
 Var event=WindowEvent
 Sleep(1)
 Select Case event
  Case EventClose
   End
  Case EventGadget
   Select Case EventNumber
    Case 1
     MessBox("","??? ??????")
    Case 2
     MessBox("","??? ????????? ??????")
   End Select   
 End Select
Loop

