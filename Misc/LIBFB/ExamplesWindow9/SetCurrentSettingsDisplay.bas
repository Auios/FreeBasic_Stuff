#Include "window9.bi"
Dim As String Setting,currentSetting
Dim As Integer inputnumber,number=1
currentSetting=GetCurrentSettingsDisplay
Do
 Setting=EnumSettingsDisplay()
 If Setting<>"" Then
  ? "Number" & " " & number  & Chr(9) & Setting
 Else
  Exit Do
 EndIf
 number+=1
Loop
ResetEnum
number=1
Input "input number"; inputnumber
Do
 Setting=EnumSettingsDisplay()
 If Setting<>"" Then
  If inputnumber=number Then
   SetCurrentSettingsDisplay(GetWidthDesktop(Setting),_
   GetHeightDesktop(Setting),GetBitsDesktop(Setting),GetFrequencyDesktop(Setting))
   Exit Do
  EndIf
 Else
  Exit Do
 EndIf
 number+=1
Loop
Sleep(5000)
SetCurrentSettingsDisplay(GetWidthDesktop(currentSetting),_
GetHeightDesktop(currentSetting),GetBitsDesktop(currentSetting),GetFrequencyDesktop(currentSetting))