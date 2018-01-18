#Include "window9.bi"
enum GADGETS
  panel = 1
  calendar
  editor
  button1
  button2
end enum
var main = OpenWindow("PanelGadget",10,10,500,500) 
CenterWindow(main)
PanelGadget(panel,0,0,,,32)

var panel1 = AddPanelGadgetItem(1,0,"1",Extract_Icon(GetSystemDir & "\SetupAPI.dll",22),1)
WindowColor(panel1,255)
ShowWindow(panel1,1)
CalendarGadget(calendar,100,100,200,200)

var panel2 = AddPanelGadgetItem(1,1,"2",Extract_Icon(GetSystemDir & "\SetupAPI.dll",23),1)
WindowColor(panel2,&hff0000)
EditorGadget(editor,0,0,300,300,"Hello")
SetGadgetColor(editor,&hFFFF,&hD71FE0,3)
ButtonGadget(button1,320,50,100,30,"1 button")
ButtonGadget(button2,320,100,100,30,"2 button")

var event = 0
Do
 event=WaitEvent
Loop Until event=EventClose

