#Include "window9.bi"
Dim As HWND mdi1,mdi2
Dim As HMENU hMessages,MenName
Dim As Integer event
OpenWindow("",10,10,400,400)
hMessages=Create_Menu()
MenName=MenuTitle(hMessages,"MDI")
ClientMDIGadget(MenName,100)
mdi1=MDIGadget("MDI1",10,10,200,200):WindowColor(mdi1,&h6405A3)
mdi2=MDIGadget("MDI2",100,10,200,200):WindowColor(mdi2,&h498721)

Do
 event=WaitEvent
 If event=EventClose Then End
Loop

