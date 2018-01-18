#Include "window9.bi"
Var hwnd=OpenWindow("",100,100,320,240)
Var hbitmap=CreateCopyImageDesktop()
ImageGadget(1,0,0,320,240)
SetImageGadget(1, hbitmap)
Do : Loop until  WaitEvent= EventClose