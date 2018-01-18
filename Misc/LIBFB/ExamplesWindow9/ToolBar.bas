#Include "window9.bi"

Dim As Integer hwToolBar

Var hwnd=OpenWindow("",10,10,200,200)
CenterWindow(hwnd)
hwToolBar=CreateToolBar(,TBSTYLE_FLAT)
ToolBarStandardButton(hwToolBar,1,STD_FILEOPEN)
ToolBarSeparator(hwToolBar)
ToolBarSeparator(hwToolBar)
ToolBarStandardButton(hwToolBar,2,STD_CUT)
ToolBarSeparator(hwToolBar,-1)
SetParent(CheckBoxGadget(10,26,2,20,20),Cast(hwnd,hwToolBar))
SetParent(ComboBoxGadget(11,62,0,50,100),Cast(hwnd,hwToolBar))
For a As Integer=1 To 5
 ToolBarSeparator(hwToolBar)
 AddComboBoxItem(11,Str(a),-1)
Next
ToolBarStandardButton(hwToolBar,3,STD_COPY)


Do
 Var ev=WaitEvent
 If ev=EventClose Then
  End
 ElseIf ev=EventGadget Then
  Select Case EventNumberToolBar
   Case 1 To 3
    MessBox("","Тулбар номер  "  & EventNumberToolBar)
  End Select
  If EventNumber=10 Then
            MessBox("CheckBox","CheckBox")
  EndIf
 EndIf
Loop


