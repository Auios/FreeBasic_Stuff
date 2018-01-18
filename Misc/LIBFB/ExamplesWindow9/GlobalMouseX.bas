#Include"window9.bi"

Do 
  If GetAsyncKeyState(&h1B)<0 Then Exit Do ' ESC 
    ? GlobalMouseX & "x" & GlobalMouseY
Loop

