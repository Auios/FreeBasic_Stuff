#Include "window9.bi"

Dim As HMENU hMessages,MenName,MenName1,MenName2

OpenWindow("",10,10,400,400)
hMessages=Create_Menu()
MenName=MenuTitle(hMessages,"Файл")
MenName1=MenuTitle(hMessages,"Помощь")
MenuItem(1,MenName,"1 меню")
MenuItem(2,MenName,"2 меню")
MenName2=OpenSubMenu(MenName,"Окно")
MenuItem(3,MenName2,"3 меню")

Do
 Var event=WaitEvent
 If event=EventMenu then
  Select case EventNumber
   Case 1
    MessBox("","1 меню")
   Case 2
    MessBox("","2 меню")
   Case 3
    MessBox("","3 меню") 
  End Select
 EndIf
 If event=EventClose Then End
Loop


