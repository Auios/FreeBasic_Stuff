#Include "window9.bi"
Var hwnd=OpenWindow("",100,100,300,300)
WindowStartDraw(hwnd) '�������� ���������
  RoundBoxDraw(65,65,150,150,50000,50000,,,1000,50) ' ������ ������������� 
StopDraw ' ����������� ���������
Do : Loop until WaitEvent= EventClose
