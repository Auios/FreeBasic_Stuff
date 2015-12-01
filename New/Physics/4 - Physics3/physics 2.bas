
#include "fbgfx.bi"
#include "color16.bi"
Using FB
Randomize Timer

dim shared as integer Scrnx,Scrny
Sub Initialize_Screen() 'Initialize the screen
    scrnx = 800
    scrny = 600
    screenres 800,600,2,16,0
    windowtitle "Physics v.2"
end sub

dim shared as double Distance,N,Force,Accel 'N = Time
dim shared as double Pi = Atn(1)*4 'Pi = 1 * Inverse Tangent * 4

'Accel = Distance/Time^2
'Force = Mass*Accel
'Angle = 0
'Theta = Angle*Pi/180

dim shared as integer i,Selected,Total = 3
dim shared as integer Tab_Input
dim shared as string Cmd
Selected = 1
type Prop_Ent 'Entity Properties
    as double X,Y
    as double Mass
    as double Speed
    as double X_Scl,Y_Scl
    as double X_Vel,Y_Vel,Avg_Vel
    as double Turn
    as double Angle
    as double Theta
    as double Force
    as double Acceleration
    as double Distance
    as uinteger Clr
end type
dim shared as Prop_Ent Ent(Total)

type Prop_Cam 'Camera Properties
    as integer X,Y
    as integer Speed = 5
end type
dim shared as Prop_Cam Cam

sub Initialize_Values() 'Initialize Values
    for i = 1 to Total
        With Ent(i)
            .X = Int(ScrnX*Rnd)
            .Y = Int(ScrnY*Rnd)
            .Clr = RGB(255*rnd,255*rnd,255*rnd)
            .Mass = Int(30*Rnd+10)
            .Speed = int(.Mass/10)
            .Angle = 360*Rnd
            .Theta = .Angle*Pi/180
            .Turn = int(360/100)
        End With
    Next i
End Sub

sub Client_Input() 'Keyboard Input
    'Camera Movement Control
    if Tab_Input = 0 then
        With Cam
            if multikey(Sc_up) then .Y+=.Speed
            if multikey(Sc_down) then .Y-=.Speed
            if multikey(Sc_left) then .X+=.Speed
            if multikey(Sc_right) then .X-=.Speed
        End With
        
        'Entity Movment Control
        With Ent(Selected)
            if multikey(Sc_w) then
                for i = 1 to Total
                    Distance = Sqr((.X-Ent(i).X)^2+(.Y-Ent(i).Y)^2)
                    if Distance > Ent(Selected).Mass then
                        .X+=.Mass/4*cos(.Theta)
                        .Y-=.Mass/4*sin(.Theta)
                    end if
                next i
            End if
            
            if multikey(Sc_s) then
                .X-=.Mass/4*cos(.Theta)
                .Y+=.Mass/4*sin(.Theta)
            End if
            
            if multikey(Sc_d) then .Angle-=.Turn
            if multikey(Sc_a) then .Angle+=.Turn
        End With
        
        'Tab Input
        if multikey(Sc_Tab) then
            Tab_Input = 1
            while inkey <> "":Wend
        end if
    end if
end sub

sub Cmd_Input()
    if Tab_Input = 1 then
        var Key_Press = inkey$
        select case Key_Press
            case chr$(8) 'Backspace
                if len(Cmd) then Cmd = left$(Cmd,len(Cmd)-1) 
            case chr$(13) 'Enter
                select case Cmd '-----------------------------------------------Commands
                case "Help"
                case "ResetCam"
                    with Cam
                        .X = 0
                        .Y = 0
                    end with
                end select
                Cmd = ""
                Tab_Input = 0
            case chr$(27) 'Escape
                Cmd = ""
                Tab_Input = 0
            case else
                Cmd += Key_Press
        end select
    end if
    while inkey <> "":Wend
end sub

sub Calculate() 'Calculate Data
    for i = 0 to Total
        With Ent(i)
            .Theta = .Angle*Pi/180
        end with
    next i
end sub

sub Render() 'Visuals
    Cls
    ScreenLock
    
    with Cam
        line(.X,.Y)-(.X+Scrnx-1,.Y+Scrny-1),White,"b"
    end with
    
    for i = 1 to Total
        with Ent(i)
            line(Cam.X+.X,Cam.Y+.Y)-(Cam.X+.X+.Mass*cos(.Theta),Cam.Y+.Y-.Mass*sin(.Theta)),.Clr
            circle(Cam.X+.X,Cam.Y+.Y),.Mass,.Clr
        end with
    next
    
    if Tab_Input = 1 then Draw string(5,15),"Command: " & Cmd,white
    
    ScreenUnlock
end sub

Initialize_Screen()
Initialize_Values()

do 'Main Program Loop
    Client_Input()
    Cmd_Input()
    Calculate()
    Render()
    sleep 10,1
loop until multikey(Sc_Escape)