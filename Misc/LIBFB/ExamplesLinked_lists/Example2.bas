#Include "Linked_Lists.bi"

 '������� ����� ������
Var list=NewList() 
' ��������� �������� ������
AddElement_S(List,"one")
AddElement_S(List,"two")
AddElement_S(List,"three")
AddElement_S(List,"four")
/' � ������ ������ ��������� �� ��������� �������� ����� ���������� ��������� ������,
��������� � ����� � �����'/
Do 
Print GetList_S(List)
Loop Until PrevElement(List)=0
' ������ ��������� �� ����, ������� ������ ��� �� ������ �������
FirstElement(List)
' ��������� �� ��� ������ ����� "Five"
Do 
SetList_S(List,"Five")
Loop Until NextElement(List)=0
' ������ ��������� �� ��������� �������
LastElement(List)
' ��������� � �����
Do 
Print GetList_S(List)
Loop Until PrevElement(List)=0

Sleep