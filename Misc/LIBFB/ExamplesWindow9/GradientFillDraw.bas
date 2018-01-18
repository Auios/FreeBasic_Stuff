#Include "window9.bi"
Var hwnd=OpenWindow("",100,100,440,160):CenterWindow(hwnd)
WindowStartDraw(hwnd,,,,,1)
  GradientFillDraw(10,10,200,100,&hE7CA,&h4A16,&h63C2,&h489E,&h4727,&hB183,0)
  GradientFillDraw(215,10,200,100,&h0,&hC02E,&hE074,&h0,&hFADD,&h3703,1)
StopDraw 
Do : Loop until WaitEvent= EventClose