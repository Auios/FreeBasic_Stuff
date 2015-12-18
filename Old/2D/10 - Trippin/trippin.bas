dim as integer xres,yres
screeninfo xres,yres
xres = 800
yres = 600
screenres xres,yres,16,,0
randomize timer


Sub FBSinCos(Angle As Double, byRef fbSin As Double, byRef fbCos As Double)
  Asm
    fld qword Ptr [Angle] 'Angle -> st(0)
    fsincos               'compute sin AND cos
    mov edx, [fbCos]      'Addr. of fbCos -> EDX
    fstp qword Ptr [edx]  'St(0) = cos -> fbCos
    mov edx, [fbSin]      'Addr. of fbSin -> EDX
    fstp qword Ptr [edx]  'St(0) = sin -> fbSin
  End Asm
End Sub

function framecounter() as double
    Static As Double frame,fps
    frame=frame+1
    Static As Double t1,t2
    If frame>=fps Then
        t1 = Timer
        fps = frame/(t1-t2)
        'Windowtitle "Frames per second = " & fps
        t2=Timer
        frame=0
    End If
    function=fps
End function

dim as double sine,cosine
dim as single c1,c2
dim as single s1,s2
dim as single x1,x2
dim as single y1,y2
dim as single deg1,deg2
dim as single toggle,span
dim as single rad1
dim as single rad2

dim as integer xctr, yctr, radius, divisions, fullcircle

xctr = xres/2
yctr = yres/2

radius = (xres*yres)/((xres+yres)*4)

divisions = 30

rad1 = atn(1) / divisions
rad2 = atn(1) / (divisions/2)
fullcircle = atn(1)*15 / rad1

span = 0
toggle = 0

dim as integer cusx,cust,tick=0,tickret=100
cust=.5
do
    tick+=1
    if tickret=tick then
        cusx=(8*rnd)
        tickret=tick+100
    end if
    
    var fps=framecounter
    screenlock
    cls
'    draw string(10,10),"FPS -----> " & fps
'    draw string(10,20),"Tick ----> " & tick
'    draw string(10,30),"CusX ----> " & cusx
    
    for deg1 = 0 to fullcircle step 1
       
       FBSinCos(deg1*rad1,sine,cosine) 
'        c1=cos(deg1*rad)
'        s1=sin(deg1*rad)
        
        c1=cosine
        s1=sine
        
        x1=radius*c1
        y1=radius*s1
        
        for deg2 = 0 to fullcircle step 10
            
            FBSinCos(deg2*rad2,sine,cosine)
            'c2=cos(deg2*rad)
            's2=sin(deg2*rad)
            
            c2=cosine
            s2=sine
            
            x2=radius*s2*(log(deg2*rad1*s2*atn(span)))*atn(deg2*rad2*s2/s1)*atn(deg2*rad2*c1*s1*c2*span)*sin(deg2/(s1*c1*s1*c1)*rad1*rad1*atn(span))*tan(span)
            y2=radius*c2*(log(deg2*rad1*c2*atn(span)))*atn(deg2*rad2*c2/c1)*atn(deg2*rad2*c1*s1*c2*span)*sin(deg2/(s1*c1*s1*c1)*rad1*rad1*atn(span))*tan(span)
        
            pset(xctr+x1+x2   ,yctr+y1+y2   ),rgb(255,0,0)
'            pset(xctr/x1*x2      ,yctr+y1      ),rgb(255,255,255)
            pset(xctr+x2      ,yctr+y2      ),rgb(255,255,0)
        
        next
    next

    screenunlock
    sleep 1,1

    select case toggle
        case 0
            span += rad1*.5
            if span >=  +(fullcircle/270) then toggle = 1
            cls
        case 1
           span -= rad1*cusx
            if span <=  -(fullcircle/270) then toggle = 0
            cls
    end select
    
loop until inkey=chr(27)

screen 0
end 0