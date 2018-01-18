#Include "window9.bi"

OpenWindow("",10,10,200,200)

Do
 Var event=WaitEvent
 Select Case event
  Case EventClose
   End
  Case EventLBDown
   ? "EventLBDown"
  Case EventRBDown
   ? "EventRBDown"
  Case EventMBDown
   ? "EventMBDown"
  Case EventLBUp
   ? "EventLBUp"
  Case EventRBUp
   ? "EventRBUp"
  Case EventMBUp
   ? "EventMBUp"
 End Select
Loop

