#include "window9.bi"
enum gadgets
  button = 1
  tbar
  text
end enum

OpenWindow("Trackbar", 10,10,300,300)
ButtonGadget  (button, 20,20, 60, 20,"End")
TrackBarGadget(tbar  , 20,70,260, 20,0,20)
TextGadget    (text  ,200,20, 30, 20)
Do
  var event=WaitEvent()
  If event=EventGadget Then
    Select case EventNumber
    Case 2 : SetGadgetText(text,Str(GetTrackBarPos(tbar)))
    Case 1 : end
    End Select
  End If
Loop

