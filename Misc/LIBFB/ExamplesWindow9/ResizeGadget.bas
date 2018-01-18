#include "window9.bi"
enum gadgets
  calendar = 1
  button
end enum


OpenWindow("",10,10,300,330)
CalendarGadget(calendar, 15,10,200,200)
ButtonGadget(button, 10,230,50,30,"Click!")

var event = 0
Do
  event=WaitEvent()
  If event = EventClose Then End
  If event = EventGadget Then 
    ResizeGadget(calendar,0,0)
    ResizeGadget(button,220,10,,50)
  End If
Loop

