#Include "Linked_Lists.bi"

'������� ����� ������
Var list=NewList()
'��������� �������� ������-����� ���� INTEGER
For a As Integer=1 To 300
	AddElement_In(List,a)
Next
'��������� �������� ������-������
Dim b As String 
For a As Integer=1 To 100
	b= b & "a"
	AddElement_S(List,b)
Next
' ��������� �� ������ �������
FirstElement(List)
'��������� �����
For a As Integer=1 To 300
	? GetList_in(List);
	NextElement(List)
Next
? ""  ' ������� ���� ����� �� ����� � ������� 
' ��������� ������
Do
	? GetList_S(List)
Loop Until NextElement(List)=0
sleep
'� ��� ��� � ����� �����