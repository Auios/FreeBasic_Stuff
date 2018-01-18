#ifdef __FB_UNIX__
Const TEST_COMMAND = "ls *"
#else
Const TEST_COMMAND = "PipeTestOut.exe"
#endif

Open Pipe TEST_COMMAND For Input As #1

Dim As String ln
Do Until EOF(1)
    Line Input #1, ln
    Print ln & " LOL"
Loop

Close #1

sleep