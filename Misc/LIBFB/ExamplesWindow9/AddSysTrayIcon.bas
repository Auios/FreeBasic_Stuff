#Include "window9.bi"

Dim As MSG msg
Dim As HWND hWnd
Dim Shared As HMENU hMessages

hwnd=OpenWindow("",10,10,300,300)
hMessages=CreatePopMenu()
MenuItem(1,hMessages,"Изменить икоку")

AddSysTrayIcon(1,hwnd,LoadIcon(0,IDI_WINLOGO),"SYSTRAY приложение")


Do
 Var   ev=WaitEvent
 If ev=EventClose Then
  Deletesystrayicon(1)
  End
 EndIf
 If ev=eventRbDOWN Then
  If EventNumber = 1 Then
   DisplayPopupMenu(hMessages,GlobalMouseX,GlobalMouseY)
  EndIf
 EndIf
 If ev=EventMenu Then
      ReplaceSysTrayIcon(1,LoadIcon(0,IDI_HAND),"Новая иконка")
 EndIf
Loop

