#Include "Linked_Lists.bi"

'Создаем новый список
Var list=NewList()
'добавляем элементы списка-числа типа INTEGER
For a As Integer=1 To 300
	AddElement_In(List,a)
Next
'добавляем элементы списка-строки
Dim b As String 
For a As Integer=1 To 100
	b= b & "a"
	AddElement_S(List,b)
Next
' указатель на первый элемент
FirstElement(List)
'считываем числа
For a As Integer=1 To 300
	? GetList_in(List);
	NextElement(List)
Next
? ""  ' отделим наши числа от строк в консоли 
' считываем строки
Do
	? GetList_S(List)
Loop Until NextElement(List)=0
sleep
'И все это в одном листе