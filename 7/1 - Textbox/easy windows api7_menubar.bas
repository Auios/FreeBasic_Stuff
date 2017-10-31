#Include "windows.bi"

Dim As MSG msg
Dim As HWND hWnd, edt1
Dim As HMENU hMenu, hMessages, hEdit  ' Menu variables

hWnd = CreateWindowEx( 0, "#32770", "Hello", WS_OVERLAPPEDWINDOW Or WS_VISIBLE, 100, 100, 500, 300, 0, 0, 0, 0 )
edt1 = CreateWindowEx( WS_EX_CLIENTEDGE, "EDIT", "Hello", WS_VISIBLE Or WS_CHILD, 0, 0, 300, 30, hWnd, 0, 0, 0 )

' Create menus
hMenu = CreateMenu( )
hMessages = CreateMenu( )
hEdit = CreateMenu( )

' Create menus
InsertMenu( hMenu, 0, MF_POPUP, CInt( hMessages ), "&Messages" )
InsertMenu( hMenu, 0, MF_POPUP, CInt( hEdit ), "&Edit" )

' Create Messages submenus
AppendMenu( hMessages, 0, 1, "Message &Hello" )
AppendMenu( hMessages, 0, 2, "Message &Error" )
AppendMenu( hMessages, 0, 3, "Message &Information" )
AppendMenu( hMessages, 0, 4, "Message &Question" )
AppendMenu( hMessages, 0, 0, 0 )
AppendMenu( hMessages, 0, 5, "E&xit" )

' Create Edit submenus
AppendMenu( hEdit, 0, 6, "Set &Title" )

' Set hMenu to hWnd window
SetMenu( hWnd, hMenu )
' Draw menu bar
DrawMenuBar( hWnd )

While GetMessage( @msg, 0, 0, 0 )
  TranslateMessage( @msg )
  DispatchMessage( @msg )
  
  Select Case msg.hwnd
    Case hWnd
      Select Case msg.message
        Case 161
          If msg.wParam = 20 Then
            Dim As Integer res
            
            ' Confirm window close
            res = MessageBox( hWnd, "Do you realy want to quit?", "Exit", MB_YESNO Or MB_ICONQUESTION )
            If res = 6 Then End
          EndIf
          
        Case 273 ' Menu commands
          Select Case msg.wParam
            ' Messages menu
            Case 1 ' Message hello
              MessageBox( hWnd, "Hello, World!", "Hello", MB_OK )
              
            Case 2 ' Message error
              MessageBox( hWnd, "This is error message!", "Error", MB_OK Or MB_ICONERROR )
              
            Case 3 ' Message information
              MessageBox( hWnd, "This is information message!", "Information", MB_OK Or MB_ICONINFORMATION )
              
            Case 4 ' Message question
              Dim As Integer res
              
              showagain:
              res = MessageBox( hWnd, "This is question message! Show again?", "Question", MB_YESNO Or MB_ICONQUESTION )
              
              ' if result = 6 (Yes) then show again the message
              If res = 6 Then GoTo showagain
              
            Case 5 ' Exit
              Dim As Integer res
              
              ' Confirm exit
              res = MessageBox( hWnd, "Do you realy want to quit?", "Exit", MB_YESNO Or MB_ICONQUESTION )
              If res = 6 Then End
            
            ' Edit menu
            Case 6 ' Set title
              Dim As ZString*255 txt
              
              GetWindowText( edt1, @txt, SizeOf( txt ) )
              SetWindowText( hWnd, txt )
          End Select
      End Select
  End Select
Wend