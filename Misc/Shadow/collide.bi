Public Function collide_object(x As integer,y As integer,x2 As integer,y2 As integer,speed As integer,width2 As integer,height2 As integer,width1 As integer,height1 As Integer,direc As Integer)As Integer
Dim As Integer distx,disty
'Line (0+x,(height1/2)+y)-((width1/2)+x,0+y),RGB(255,255,255)
'Line ((width1/2)+x,0+y)-(width1+x,(height1/2)+y),RGB(255,255,255)
'Line ((width1/2)+x,height1+y)-(width1+x,(height1/2)+y),RGB(255,255,255)
'Line (0+x,(height1/2)+y)-((width1/2)+x,height1+y),RGB(255,255,255)
'
'Line (0+x2,0+y2)-(width2+x2,0+y2),RGB(255,255,255)
'Line (0+x2,height2+y2)-(width2+x2,height2+y2),RGB(255,255,255)
'Line (0+x2,0+y2)-(0+x2,height2+y2),RGB(255,255,255)
'Line (width2+x2,0+y2)-(width2+x2,height2+y2),RGB(255,255,255)

                if x>x2 then distx=x-x2
                if x<=x2 then distx=x2-x
                if y>y2 then disty=y-y2
                if y<=y2 then disty=y2-y
      If Sqr(distx*distx + disty*disty)>500 Then Return 1

If direc=1 Then
         If x2>=(width1/2)+x And x2<=width1+x and y2-speed>=height1+y+(((width1/2)+x-x2)/(width1/height1)) Then 
            Return 1
         ElseIf x2>=width1+x Then
            Return 1
         ElseIf x2+width2<=0+x Then
            Return 1
         ElseIf x2+width2>=(width1/2)+x And x2<=(width1/2)+x And y2-speed>=height1+y Then
            Return 1
         ElseIf y2-speed+height2<=y+(height1/2)-1 Then
            Return 1
         ElseIf x2+width2<=(width1/2)+x And x2+width2>=0+x and y2-speed>=height1+y+(((x2+width2)-((width1/2)+x))/(width1/height1)) Then
            Return 1
         Else
            Return 0
         End If
End if

If direc=2 Then
         If x2>=(width1/2)+x And x2<=width1+x and y2+speed+height2<=y+(((x2)-((width1/2)+x))/(width1/height1)) Then
            Return 1
         elseif x2>=width1+x Then
            Return 1
         ElseIf x2+width2<=0+x Then
            Return 1
         elseif x2+width2>=(width1/2)+x And x2<=(width1/2)+x And y2+speed+height2<=y Then
            Return 1
         ElseIf y2+speed>=y+(height1/2) Then
            Return 1
         elseif x2+width2<=(width1/2)+x And x2+width2>=0+x and y2+speed+height2<=y-(((x2+width2)-((width1/2)+x))/(width1/height1)) Then
            Return 1
         Else
            Return 0
         End If
End If


If direc=3 Then 
         If y2>=(height1/2)+y And y2<=height1+y and x2+speed+width2<=x+(((y2)-((height1/2)+y))*(width1/height1)) Then
            Return 1
         elseif y2>=height1+y Then
            Return 1
         ElseIf y2+height2<=y Then
            Return 1
         elseif y2+height2>=(height1/2)+y And y2<=(height1/2)+y And x2+speed+width2<=x Then
            Return 1
         ElseIf x2+speed>=x+(width1/2) Then
            Return 1
         elseif y2+height2<=(height1/2)+y And y2+height2>=0+y and x2+speed+width2<=x-(((y2+height2)-((height1/2)+y))*(width1/height1)) Then
            Return 1
         Else
            Return 0
         End If
End If
If direc=4 Then
         If y2>=(height1/2)+y And y2<=height1+y and x2-speed>=(width1/2)+x+((height1+y-y2)*(width1/height1)) Then 
            Return 1
         ElseIf y2>=height1+y Then
            Return 1
         ElseIf y2+height2<=y Then
            Return 1
         ElseIf y2+height2>=(height1/2)+y And y2<=(height1/2)+y And x2-speed>=width1+x Then
            Return 1
         ElseIf x2-speed+width2<x+(width1/2)-1 Then
            Return 1
         ElseIf y2+height2<=(height1/2)+y And y2+height2>=0+y and x2-speed>=width1+x+(((y2+height2)-((height1/2)+y))*(width1/height1)) Then
            Return 1
         Else
            Return 0
         End If
End If

End Function