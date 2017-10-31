#Include "windows.bi"

' To use ProgressBar include commctrl.bi and use InitCommonControls()
#Include "win/commctrl.bi"
InitCommonControls( )

' Define pbm_setbkcolor message
'#Define PBM_SETBKCOLOR 8193

Dim As MSG msg
Dim As HWND hWnd, pgb1, pgb2, pgb3, pgb4, pgb5  ' Define window and progress bars

' Create Window
hWnd = CreateWindowEx( 0, "#32770", "Hello", WS_OVERLAPPEDWINDOW Or WS_VISIBLE, 100, 100, 500, 300, 0, 0, 0, 0 )
' Create 5 progress bars
pgb1 = CreateWindowEx( 0, PROGRESS_CLASS, "", WS_VISIBLE Or WS_CHILD, 20, 20, 460, 20, hWnd, 0, 0, 0 )
pgb2 = CreateWindowEx( 0, PROGRESS_CLASS, "", WS_VISIBLE Or WS_CHILD, 20, 50, 460, 20, hWnd, 0, 0, 0 )
pgb3 = CreateWindowEx( 0, PROGRESS_CLASS, "", WS_VISIBLE Or WS_CHILD, 20, 80, 460, 20, hWnd, 0, 0, 0 )
pgb4 = CreateWindowEx( 0, PROGRESS_CLASS, "", WS_VISIBLE Or WS_CHILD, 20, 110, 460, 20, hWnd, 0, 0, 0 )
pgb5 = CreateWindowEx( 0, PROGRESS_CLASS, "", WS_VISIBLE Or WS_CHILD, 20, 140, 460, 20, hWnd, 0, 0, 0 )

' Set progressbar ranges from 1 to 10
SendMessage( pgb1, PBM_SETRANGE, 0, MAKELPARAM( 1, 10 ) )
SendMessage( pgb2, PBM_SETRANGE, 0, MAKELPARAM( 1, 10 ) )
SendMessage( pgb3, PBM_SETRANGE, 0, MAKELPARAM( 1, 10 ) )
SendMessage( pgb4, PBM_SETRANGE, 0, MAKELPARAM( 1, 10 ) )
SendMessage( pgb5, PBM_SETRANGE, 0, MAKELPARAM( 1, 10 ) )

' Set progres bar foreground color
SendMessage( pgb1, PBM_SETBARCOLOR, 0, BGR( 255, 0, 0 ) )
SendMessage( pgb2, PBM_SETBARCOLOR, 0, BGR( 255, 255, 0 ) )
SendMessage( pgb3, PBM_SETBARCOLOR, 0, BGR( 255, 0, 255 ) )
SendMessage( pgb4, PBM_SETBARCOLOR, 0, BGR( 0, 255, 0 ) )
SendMessage( pgb5, PBM_SETBARCOLOR, 0, BGR( 0, 0, 255 ) )

' Set progress bar background color
SendMessage( pgb1, PBM_SETBKCOLOR, 0, BGR( 128, 0, 0 ) )
SendMessage( pgb2, PBM_SETBKCOLOR, 0, BGR( 128, 128, 0 ) )
SendMessage( pgb3, PBM_SETBKCOLOR, 0, BGR( 128, 0, 128 ) )
SendMessage( pgb4, PBM_SETBKCOLOR, 0, BGR( 0, 128, 0 ) )
SendMessage( pgb5, PBM_SETBKCOLOR, 0, BGR( 0, 0, 128 ) )

Dim As UInteger r1, r2, r3, r4, r5  ' Define variables to store progress values
SetTimer( hWnd, 0, 1, 0 )    ' Set timer to 1 milisecond

While GetMessage( @msg, 0, 0, 0 )
  TranslateMessage( @msg )
  DispatchMessage( @msg )
  
  Select Case msg.hwnd
    Case hWnd
      Select Case msg.message
        Case 273
          End
          
        Case WM_TIMER    ' When timer was changed do some stuff
          If r1 > 10 Then r1 = 0: r2 += 1
          If r2 > 10 Then r2 = 0: r3 += 1
          If r3 > 10 Then r3 = 0: r4 += 1
          If r4 > 10 Then r4 = 0: r5 += 1
          If r5 > 10 Then r5 = 0
          
          r1 += 1
          
          ' Set progress bar values
          SendMessage( pgb1, PBM_SETPOS, r1, 0 )
          SendMessage( pgb2, PBM_SETPOS, r2, 0 )
          SendMessage( pgb3, PBM_SETPOS, r3, 0 )
          SendMessage( pgb4, PBM_SETPOS, r4, 0 )
          SendMessage( pgb5, PBM_SETPOS, r5, 0 )
      End Select
  End Select
Wend