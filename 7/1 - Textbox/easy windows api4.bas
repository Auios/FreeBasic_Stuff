#Include "windows.bi"

Dim As MSG msg
Dim As HWND hWnd, btn1, edt1

' Create window
hWnd = CreateWindowEx( 0, "#32770", "Hello", WS_OVERLAPPEDWINDOW Or WS_VISIBLE, 100, 100, 500, 300, 0, 0, 0, 0 )
' Create button
btn1 = CreateWindowEx( 0, "BUTTON", "Button #1", WS_VISIBLE Or WS_CHILD, 20, 10, 100, 30, hWnd, 0, 0, 0 )
' Create edit box
edt1 = CreateWindowEx( 0, "EDIT", "Type text here...", ws_border Or WS_VISIBLE Or WS_CHILD Or WS_HSCROLL Or WS_VSCROLL Or ES_AUTOHSCROLL Or ES_AUTOVSCROLL Or ES_MULTILINE, 20, 50, 200, 100, hWnd, 0, 0, 0 )

While GetMessage( @msg, 0, 0, 0 )
  TranslateMessage( @msg )
  DispatchMessage( @msg )
  
  Select Case msg.hwnd
    Case hWnd
      Select Case msg.message
        Case 273
          End
          
        ' If left mouse button was pressed in window area then
        ' check if is edit box text = "". If it is then set
        ' the edit box text to "Type text here" and set focus
        ' to the window
        Case WM_LBUTTONDOWN
          Dim As ZString*1024 txt
          
          GetWindowText( edt1, txt, SizeOf( txt ) )
          If txt = "" Then SetWindowText( edt1, "Type text here..." )
          
          SetFocus( hWnd )  ' Set focus to the window
          
        Case Else
          ' Create rect variable and store window size in it
          Dim As RECT rct: GetClientRect( hWnd, @rct )
          
          ' Resize the edit box
          MoveWindow( edt1, 20, 50, rct.right-40, rct.bottom-60, TRUE )
      End Select
      
    Case btn1
      Select Case msg.message
        ' If left mouse button was pressed in button area then
        ' check if is edit box text = "". If it is then set
        ' the edit box text to "Type text here"
        Case WM_LBUTTONDOWN
          ' When button is pressed set the text
          ' of button to "pressed"
          SetWindowText( btn1, "Clicked!" )
          
          Dim As ZString*1024 txt
          
          GetWindowText( edt1, txt, SizeOf( txt ) )
          If txt = "" Then SetWindowText( edt1, "Type text here..." )
          
        ' If left mouse button was released from the button area
        ' then set the button text to "Button #1" and show
        ' massage box with text from text box
        Case WM_LBUTTONUP
          SetWindowText( btn1, "Button #1" )
          
          Dim As ZString*1024 txt
          
          GetWindowText( edt1, txt, SizeOf( txt ) )
          MessageBox( hWnd, txt, "Hello", MB_OK )
      End Select
      
    Case edt1
      Select Case msg.message
        ' When textbox was pressed then clar the textbox text if
        ' text = "Type text here..."
        Case WM_LBUTTONDOWN
          Dim As ZString*1024 txt
          
          GetWindowText( edt1, txt, SizeOf( txt ) )
          If txt = "Type text here..." Then SetWindowText( edt1, "" )
      End Select
  End Select
Wend