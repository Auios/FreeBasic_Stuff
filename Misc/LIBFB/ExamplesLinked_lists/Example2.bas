#Include "Linked_Lists.bi"

 'Создаем новый список
Var list=NewList() 
' добавляем элементы списка
AddElement_S(List,"one")
AddElement_S(List,"two")
AddElement_S(List,"three")
AddElement_S(List,"four")
/' В данный момент указатель на последнем элементе после добавления элементов списка,
считываем в цикле с конца'/
Do 
Print GetList_S(List)
Loop Until PrevElement(List)=0
' Сейчас указатель на нуле, поэтому ставим его на первый элемент
FirstElement(List)
' Заполняем во все ячейки слово "Five"
Do 
SetList_S(List,"Five")
Loop Until NextElement(List)=0
' ставим указатель на последний элемент
LastElement(List)
' считываем с конца
Do 
Print GetList_S(List)
Loop Until PrevElement(List)=0

Sleep