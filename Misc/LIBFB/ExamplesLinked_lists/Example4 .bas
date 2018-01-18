#Include "Linked_Lists.bi"
'Создаем новый список
Var list=NewList()
' добавляем элементы списка
For a As Byte=1 To 8
	AddElement_S(List,Str(a))
Next

MoveElement(List,5,8)
InsertElement_S(list,8,"9")
firstElement(List)
Do
	print GetList_S(List)
Loop Until nextElement(List)=0

Sleep