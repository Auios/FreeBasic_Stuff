#Include "window9.bi"

Dim As HMENU hMessages,MenName,MenName1,MenName2

OpenWindow("",10,10,400,400)
hMessages=Create_Menu()
MenName=MenuTitle(hMessages,"����")
MenName1=MenuTitle(hMessages,"������")
MenuItem(1,MenName,"1 ����")
MenuItem(2,MenName,"2 ����")
MenName2=OpenSubMenu(MenName,"����")
MenuItem(3,MenName2,"3 ����")

Do
 Var event=WaitEvent
 If event=EventMenu then
  Select case EventNumber
   Case 1
    MessBox("","1 ����")
   Case 2
    MessBox("","2 ����")
   Case 3
    MessBox("","3 ����") 
  End Select
 EndIf
 If event=EventClose Then End
Loop


