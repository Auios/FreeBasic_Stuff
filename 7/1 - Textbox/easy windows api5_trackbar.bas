#Include "windows.bi"

' To use TrackBar include commctrl.bi and use InitCommonControls()
#Include "win/commctrl.bi"
InitCommonControls( )

Dim As MSG msg
Dim As HWND hWnd, tbr1, stc1

' Create window
hWnd = CreateWindowEx( 0, "#32770", "Hello", WS_OVERLAPPEDWINDOW Or WS_VISIBLE, 100, 100, 500, 300, 0, 0, 0, 0 )
' Create track bar
tbr1 = CreateWindowEx( 0, TRACKBAR_CLASS, "", WS_VISIBLE Or WS_CHILD Or TBS_AUTOTICKS Or TBS_ENABLESELRANGE, 20, 10, 200, 30, hWnd, 0, 0, 0 )
' Create static box
stc1 = CreateWindowEx( 0, "STATIC", "0", WS_VISIBLE Or WS_CHILD, 225, 10, 50, 30, hWnd, 0, 0, 0 )

' Set track bar maximum value to 10
SendMessage( tbr1, TBM_SETRANGEMAX, 0, 10 )

While GetMessage( @msg, 0, 0, 0 )
  TranslateMessage( @msg )
  DispatchMessage( @msg )
  
  Select Case msg.hwnd
    Case hWnd
      Select Case msg.message
        Case 273
          End
      End Select
      
    Case tbr1
      Select Case msg.message
        Case Else
          ' Get trackbar value and set that number to static box text
          SetWindowText( stc1, Str( SendMessage( tbr1, TBM_GETPOS, 0, 0 ) ) )
      End Select
  End Select
Wend