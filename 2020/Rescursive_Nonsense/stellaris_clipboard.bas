#include "windows.bi"

Sub SaveToClipBoard(Text As String)       'write Text to the clipboard
   Var Num=GlobalAlloc(GMEM_MOVEABLE,Len(Text)+1)
   memcpy(GlobalLock(num), @text[0], Len(Text)+1)
   Var Chars=GlobalLock(Num)
    GlobalUnlock(Num)
    OpenClipboard(0)
    EmptyClipboard()
    SetClipboardData(CF_TEXT,Chars)
    CloseClipboard()
End Sub

dim as integer c = 9
dim as string ptr a = new string[c+1]
a[0] = "planet_class pc_arid"
a[1] = "planet_class pc_desert"
a[2] = "planet_class pc_savannah"
a[3] = "planet_class pc_alpine"
a[4] = "planet_class pc_arctic"
a[5] = "planet_class pc_tundra"
a[6] = "planet_class pc_continental"
a[7] = "planet_class pc_ocean"
a[8] = "planet_class pc_tropical"
a[9] = "planet_class pc_nuked"

randomize(timer())

while(true)
    dim as integer r = c*rnd()
    print(a[r])
    SaveToClipBoard(a[r])
    sleep(1000, 1)
    if(inkey() = chr(27)) then exit while
wend

delete[] a