#Include "Linked_Lists.bi"
? "One list"
'Создаем новый список
Var list=NewList()
' добавляем элементы списка
AddElement_B(List,1)
AddElement_B(List,2)
AddElement_B(List,3)
AddElement_B(List,4)
AddElementHead_B(List,50)
InsertElement_B(List,3,100)
' указатель на конец списка
LastElement(List)
'считываем
Do
	Print GetList_B(List)
Loop Until PrevElement(List)=0

? "Two List"
'Создаем новый список
Var list1=NewList()
' добавляем элементы списка
AddElement_Sh(List1,3000)
AddElement_Sh(List1,5000)
AddElement_Sh(List1,6000)
AddElement_Sh(List1,7000)
AddElementHead_SH(List1,2000)
InsertElement_SH(List1,3,4000)
' указатель на начало
SelectElement(List1,1)
'считываем второй список
Do
	Print GetList_SH(List1)
Loop Until NextElement(List1)=0
? "Copy One to Two List"
' копируем из одного списка в другой, попутно преобразуя тип
For a As Integer=1 To 6
	SetValueElement_SH(list1,a,Cast(Short,GetValueElement_B(List,a)))
Next
DeleteElement(List1,3)
DeleteElement(List1,1)
' указатель на начало
FirstElement(List1)
' считываем второй список
do
	Print GetList_SH(List1)
Loop Until NextElement(List1)=0
Sleep