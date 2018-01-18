#Include "window9.bi"

enum gadgets
  tview = 1
end enum
    
Dim As Integer event

var win  = OpenWindow("TreeView",10,10,180,200) : CenterWindow(win)

var bmp1 = Extract_Icon("Shell32.DLL",  3)
var bmp2 = Extract_icon("Shell32.DLL", 45)

var tree = TreeViewGadget(tview,10,10,140,140, TVS_HASLINES or TVS_HASBUTTONS or TVS_LINESATROOT,WS_EX_CLIENTEDGE,32)

Var tvitempos = AddTreeViewItem(tview,"1",bmp1,bmp2,1)
AddTreeViewItem(tview,"1-1",bmp1,bmp2,1,tvitempos)

tvitempos=AddTreeViewItem(tview,"2",bmp1,bmp2,4)
AddTreeViewItem(tview,"2-1",bmp1,bmp2,3,tvitempos)

Do
  var event = waitevent
  If event = EventClose Then 
    end
  end if
Loop


