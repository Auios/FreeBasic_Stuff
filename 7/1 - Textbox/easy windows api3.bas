#Include "windows.bi"

Dim As MSG msg     ' Message variable (stores massages)
Dim As HWND hWnd, btn1   ' Window variable and objects variables

' Create window
hWnd = CreateWindowEx( 0, "#32770", "Hello", WS_OVERLAPPEDWINDOW Or WS_VISIBLE, 100, 100, 500, 300, 0, 0, 0, 0 )
' Create button
btn1 = CreateWindowEx( 0, "BUTTON", "Click Me!", WS_VISIBLE Or WS_CHILD, 0, 0, 0, 0, hWnd, 0, 0, 0 )

While GetMessage( @msg, 0, 0, 0 )    ' Get message from window
  TranslateMessage( @msg )
  DispatchMessage( @msg )
 
  Select Case msg.hwnd
    Case hWnd        ' If msg is window hwnd: get messages from window
      Select Case msg.message
        Case 273
          End
         
        Case Else
          Dim As RECT rct: GetClientRect( hWnd, @rct )
          MoveWindow( btn1, 10, 10, rct.right-20, rct.bottom-20, TRUE )
      End Select

    Case btn1        ' If msg is button hwnd: get messages from button
      Select Case msg.message
        Case WM_LBUTTONDOWN        ' If is left button pressed then show message box
          MessageBox( hWnd, "Button is clicked!", "Message", MB_OK Or MB_ICONINFORMATION )
         
    End Select
  End Select
Wend