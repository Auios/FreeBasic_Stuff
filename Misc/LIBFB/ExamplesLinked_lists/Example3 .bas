#Include "Linked_Lists.bi"
? "One list"
'������� ����� ������
Var list=NewList()
' ��������� �������� ������
AddElement_B(List,1)
AddElement_B(List,2)
AddElement_B(List,3)
AddElement_B(List,4)
AddElementHead_B(List,50)
InsertElement_B(List,3,100)
' ��������� �� ����� ������
LastElement(List)
'���������
Do
	Print GetList_B(List)
Loop Until PrevElement(List)=0

? "Two List"
'������� ����� ������
Var list1=NewList()
' ��������� �������� ������
AddElement_Sh(List1,3000)
AddElement_Sh(List1,5000)
AddElement_Sh(List1,6000)
AddElement_Sh(List1,7000)
AddElementHead_SH(List1,2000)
InsertElement_SH(List1,3,4000)
' ��������� �� ������
SelectElement(List1,1)
'��������� ������ ������
Do
	Print GetList_SH(List1)
Loop Until NextElement(List1)=0
? "Copy One to Two List"
' �������� �� ������ ������ � ������, ������� ���������� ���
For a As Integer=1 To 6
	SetValueElement_SH(list1,a,Cast(Short,GetValueElement_B(List,a)))
Next
DeleteElement(List1,3)
DeleteElement(List1,1)
' ��������� �� ������
FirstElement(List1)
' ��������� ������ ������
do
	Print GetList_SH(List1)
Loop Until NextElement(List1)=0
Sleep