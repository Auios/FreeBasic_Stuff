#Include Once "fbgfx.bi"
Using fb

Sub drawAllegroCircle(cx As Single,cy As Single,radius As Single)
	Dim As Double rtod,rad,pi = Atn(1)*4
	Dim As Single x,y
	
	rtod = 180/pi
	rad = 45/rtod
	
	x = radius*Cos(rad)
	y = radius*Sin(rad)
	
	'Upper right
	Line(cx,cy-radius)-(cx+x,cy-y)
	Line(cx+radius,cy)-(cx+x,cy-y)
	
	'Lower Left
	Line(cx,cy+radius)-(cx-x,cy+y)
	Line(cx-radius,cy)-(cx-x,cy+y)
	
	'============================
	
	rad = 45/rtod
	x = radius*Cos(rad)
	y = radius*Sin(rad)
	
	'Upper Left
	Line(cx,cy-radius)-(cx-x,cy-y)
	Line(cx-radius,cy)-(cx-x,cy-y)
	
	'Lower Right
	Line(cx,cy+radius)-(cx+x,cy+y)
	Line(cx+radius,cy)-(cx+x,cy+y)
End Sub

ScreenRes 800,600

drawAllegroCircle(400,300,150)
Circle(400,300),150

Sleep

Screen 0
Print "End program"
End 0