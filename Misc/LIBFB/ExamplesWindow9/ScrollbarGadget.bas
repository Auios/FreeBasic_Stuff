#include "window9.bi"

enum gadgets
  sbar_r = 1
  sbar_g
  sbar_b
  text_r
  text_g
  text_b
  text_c
end enum

Dim Shared As HWND hw

var win =  OpenWindow("TESTCOLOR",10,10,370,140): CenterWindow(win)

ScrollBarGadget(sbar_r ,10,10,200,20,0,255):SetGadgetColor(sbar_r,&h0000ff,1,3)
ScrollBarGadget(sbar_g ,10,40,200,20,0,255):SetGadgetColor(sbar_g,&h00ff00,1,3)
ScrollBarGadget(sbar_b ,10,70,200,20,0,255):SetGadgetColor(sbar_b,&hff0000,1,3)

TextGadget(text_r ,220,10,30,20,Str(GetScrollGadgetPos(sbar_r)),SS_CENTER):SetGadgetColor(text_r,0,&h0000ff,2)
TextGadget(text_g ,220,40,30,20,Str(GetScrollGadgetPos(sbar_g)),SS_CENTER):SetGadgetColor(text_g,0,&h00ff00,2)
TextGadget(text_b ,220,70,30,20,Str(GetScrollGadgetPos(sbar_b)),SS_CENTER):SetGadgetColor(text_b,0,&hff0000,2)

TextGadget(text_c,260,10,80,80):SetGadgetColor(text_c,0,0,1)

' must be !!!
' type TIMERPROC as sub (byval as HWND, byval as UINT, byval as UINT, byval as DWORD)
Sub TimerProc(byval hWin as HWND, byval p1 as UINT, byval p2 as UINT, byval p3 as DWORD)
  Static As Integer r,g,b
  var selR=GetScrollGadgetPos(sbar_r)
  var selG=GetScrollGadgetPos(sbar_g)
  var selB=GetScrollGadgetPos(sbar_b)
  If r<>selR Or g<>selG Or b<>selB Then
    r=selR : g=selG : b=selB
    SetGadgetText(text_r,Str(r))
    SetGadgetText(text_g,Str(g))
    SetGadgetText(text_b,Str(b))
    SetGadgetColor(text_c,BGR(r,g,b),0,1)
  End If
End Sub

SetTimer(win,1,100,@TimerProc)
var ev=0
Do
  ev = WaitEvent
Loop Until ev=EventClose

