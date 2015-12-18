Dim As Integer mode, w, h
'' Find which 8bit resolutions are supported
mode = ScreenList(8)
While (mode)
    w = HiWord(mode)
    h = LoWord(mode)
    Print Str(w) + "x" + Str(h)
    mode = ScreenList
Wend
sleep