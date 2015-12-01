#include "fbgfx.bi"
 
' Program Config (ajudst at will)
const WindowWidth = 800, WindowHeight = 600
const BlockSz=32, Buttons = 99
' Number of quads on the screen (rounded up!)
const QuadXCnt = ((WindowWidth+(BlockSz-1))\BlockSz)-1
const QuadYCnt = ((WindowHeight+(BlockSz-1))\BlockSz)-1
 
' tiny macro to convert form pixel number to quad number
#define PixToQuad(_NUM_) ((_NUM_)\BlockSz)
 
type Button   'For each button
  as integer iLT,iTP 'Left/Top
  as integer iRT,iBT 'Right/Bottom
end type
type Quadrant 'For each quadrant item
  iCount as integer   'How Many Itens in this quadrant?
  pArray as ushort ptr 'Array of ButtonID's (max 64k)
end type
 
' Shared Declarations to be accessible by functions          
' to have more quadrant groups would be good if              
' a pointer to the quadrant were passed to quadrant functions
redim shared as Button tButtons(Buttons)
redim shared as Quadrant tQuads(QuadXCnt,QuadYCnt)
 
' ======================================================================================
' =================================== QUADRANT FUNCTIONS ===============================
' ======================================================================================
 
' ***** Return Quadrant rect of a button ******
' ******* output to 4 byref variables *********
' *********************************************
#define byref4(_T_,_A_,_B_,_C_,_D_) byref _A_ as _T_,byref _B_ as _T_,byref _C_ as _T_,byref _D_ as _T_
function GetQuadrantRect( iButtonID as integer , byref4(integer,qLT,qTP,qRT,qBT)) as integer
  with tButtons(iButtonID)
    ' if button is totally outside screen don't add to any quadrant  if .iRT < 0 and .iBT < 0 then return 0 'fail
    if .iLT >= WindowWidth and .iTP >= WindowHeight then return 0 'fail
    ' Make sure the left/top side statys on quadrant limits
    qLT = iif( .iLT<0 , 0 , PixToQuad(.iLT) )
    qTP = iif( .iTP<0 , 0 , PixToQuad(.iTP) )
    ' Make sure the right/bottom side stays on quadrant limits
    qRT = iif( .iRT>=WindowWidth  , QuadXCnt , PixToQuad(.iRT) )
    qBT = iif( .iBT>=WindowHeight , QuadYCnt , PixToQuad(.iBT) )
  end with
  return 1 'success
end function
 
' ********** Add To Quadrant *************
' ** Doesnt check if it already exists ***
' ****************************************
sub AddToQuadrant( iButtonID as integer )
  with tButtons( iButtonID )
   
    dim as integer qLT,qTP,qRT,qBT
    if GetQuadrantRect(iButtonID,qLT,qTP,qRT,qBT)=0 then exit sub
   
    ' Add the ButtonID to each quadrant inside the button are
    for iY as integer = qTP to qBT
      for iX as integer = qLT to qRT        
        with tQuads(iX,iY)
          'Reallocate Every 16 entries (make room for +16)
          if (.iCount and 15)=0 then
            ' Using pointers instead of dynamic arrays "because blargh"    
            ' Allocation is in bytes and i multiply by the size of element
            ' that in this case i have set as "ushort" (16bit)            
            ' note: even if NULL is passed as old pointer to reallocate    
            ' it will still do the normal allocation so it's safe          
            .pArray = reallocate(.pArray,(.iCount+16)*sizeof(ushort))          
          end if
          'Set ButtonID and increase count/index
          .pArray[.iCount] = iButtonID: .iCount += 1
        end with
      next iX
    next iY
   
  end with
end sub
 
' ****** Remove item from quadrants ******
sub RemoveFromQuadrant( iButtonID as integer )
  with tButtons( iButtonID )
   
    dim as integer qLT,qTP,qRT,qBT
    if GetQuadrantRect(iButtonID,qLT,qTP,qRT,qBT)=0 then exit sub
   
    ' Add the ButtonID to each quadrant inside the button are
    for iY as integer = qTP to qBT
      for iX as integer = qLT to qRT        
        with tQuads(iX,iY)
          'Reallocate Every 16 entries (make room for +16)
          if .iCount then
            for CNT as integer = 0 to .iCount
              if .pArray[CNT] = iButtonID then
                for CN2 as integer = CNT to .iCount-1
                  .pArray[CN2] = .pArray[CN2+1]
                next CN2
                exit for
              end if
            next CNT          
            .iCount -= 1
            if (.iCount and 15)=0 then              
              'Reallocate in case it reached the -16 boundary
              .pArray = reallocate(.pArray,(.iCount+16)*sizeof(ushort))          
            end if
          end if
        end with
      next iX
    next iY
  end with
end sub
 
' ******** Find a Button based on it's position ****
' ** Checks for buttons only on a single quadrant **
' **** return ButtonID or -1  in case not found ****
' **************************************************
function FindButtonByPos( iX as integer , iY as integer ) as integer
  if cuint(iX) >= WindowWidth  then return -1 'offscreen
  if cuint(iY) >= WIndowHeight then return -1 'offscreen
  with tQuads( PixToQuad(iX) , PixToQuad(iY) )
    'Check every button on this quad        
    'note that .iCount of 0 will be 0 to -1
    'which will skip the for nicely :)      
    for CNT as integer = 0 to .iCount-1
      var iButton = .pArray[CNT] 'Button ID from array
      with tButtons( iButton )
        'is Pos inside this button?
        if iX >= .iLT andalso iX <= .iRT then          
          if iY >= .iTP andalso iY <= .iBT then
            return iButton 'Found IT!
          end if
        end if
      end with
    next CNT
  end with
  return -1 'Not Found IT!
end function
 
' ******* Bring a Button to top of Z order *********
' * Must be done in all quadrants the button is in *
' **************************************************
sub BringButtonToTop( iButtonID as integer )
  with tButtons( iButtonID )
 
    dim as integer qLT,qTP,qRT,qBT
    if GetQuadrantRect(iButtonID,qLT,qTP,qRT,qBT)=0 then exit sub
 
    for iY as integer = qTP to qBT
      for iX as integer = qLT to qRT
        with tQuads(iX,iY)
          ' Search and Reorder Button
          for CNT as integer = 0 to .iCount-1
            if .pArray[CNT] = iButtonID then 'Found Button on this Quad
              if CNT = 0 then exit for 'already on top
              var pTemp = .pArray[CNT]
              'move down other buttons on list
              for CN2 as integer = CNT-1 to 0 step -1
                .pArray[CN2+1] = .pArray[CN2]                
              next CN2
              .pArray[0] = pTemp 'Set Button to top
              exit for 'no need to continue search
            end if
          next CNT
        end with
      next iX
    next iY
 
  end with
end sub
 
' ======================================================================================
' =================================== OTHER FUNCTIONS ==================================
' ======================================================================================
 
' *******************************
' *** Draw a button on screen ***
' *******************************
sub DrawButton( iButtonID as integer )
  with tButtons( iButtonID )
    line (.iLT,.iTP)-(.iRT,.iBT),iButtonID+24,bf
    line (.iLT,.iTP)-(.iRT,.iBT),0,b,&h5555
    var sNum = "" & iButtonID
    var iX = ((.iLT+.iRT)\2)-(len(sNum)*4)
    var iY = ((.iTP+.iBT)\2)-4
    for iY2 as integer = iY-1 to iY+1
      for iX2 as integer = iX-1 to iX+1
        draw string (iX2,iY2),sNum,0
      next iX2
    next iY2
    draw string (iX,iY),sNum,15                  
  end with
end sub
 
' ******************************
' *** Make the button blinks ***
' ******************************
sub BlinkButton( iButtonID as integer, iTimes as integer )
  with tButtons( iButtonID )
    for CNT as integer = 1 to iTimes
      line(.iLT,.iTP)-(.iRT,.iBT),15,bf
      line(.iLT,.iTP)-(.iRT,.iBT),0,b,&hAAAA
      sleep 50,1
      DrawButton( iButtonID )
      sleep 50,1
    next CNT
  end with
end sub
 
' **** show all buttons that are inside a quadrant *****
' * uses a secondary screen page to not disturb screen *
' *** waits left button to be released before return ***
' **** not quadrant function because debug purposes ****
sub ShowButtonsFromQuadrant( iX as integer , iY as integer , iJustDraw as integer = 0 )  
  if cuint(iX) >= WindowWidth  then exit sub 'offscreen
  if cuint(iY) >= WIndowHeight then exit sub 'offscreen
  ' second video page
  if iJustDraw=0 then screenset 1,1:cls  
  ' Draw all buttons on quadrant
  with tQuads( PixToQuad(iX) , PixToQuad(iY) )
    for CNT as integer = .iCount-1 to 0 step -1
      DrawButton( .pArray[CNT] )
    next CNT
  end with
  if iJustDraw then exit sub
  ' Draw Quadrant Lines
  for iY as integer = 0 to WindowHeight step BlockSz
    line(0,iY)-(WindowWidth,iY),0,,&h5555
    line(0,iY)-(WindowWidth,iY),15,,&hAAAA
  next iY
  for iX as integer = 0 to WindowWidth step BlockSz
    line(iX,0)-(iX,WindowHeight),0,,&h5555
    line(iX,0)-(iX,WindowHeight),15,,&hAAAA
  next iX
  ' Wait for button to be released
  do 'iY = temp :P
    if getmouse(iY,iY,,iX)=0 andalso iX=0 then exit do
    sleep 1,1
  loop
  ' back to first video page
  screenset 0,0
end sub
 
' ****************************************
' *** Drag a button around the screen ****
' *** Return after rbutton is released ***
' ****************************************
sub DragButton( iButtonID as integer, iX as integer, iY as integer )
  if cuint(iX) >= WindowWidth  then exit sub 'offscreen
  if cuint(iY) >= WIndowHeight then exit sub 'offscreen
 
  with tButtons( iButtonID )
    ' iX and iY are drag relative to button
    var iOffX = iX-(.iLT), iOffY = iY-(.iTP)
   
    ' Get affected quadrants
    dim as integer qLT,qTP,qRT,qBT
    GetQuadrantRect(iButtonID,qLT,qTP,qRT,qBT)
   
    ' * Button must be removed from quadrant *
    RemoveFromQuadrant( iButtonID )
   
    var iMustRemove=1,iOX=0,iOY=0,dStart=timer
    var iSX=(.iRT-.iLT),iSY=(.iBT-.iTP)
    ' Temp Image that will save background
    dim as fb.image ptr pBack = ImageCreate(iSX+1,iSY+1)
   
    do
      dim as integer NX,NY,NB
      if getmouse(NX,NY,,NB)=0 then
        if NX<>iX or NY<>iY then 'Only update if mouse moves
          iX = NX: iY = NY 'To keep updating only if moves
          if iMustRemove then
            ' * Delete Button Image (affects z-order) *
            iMustRemove=-1
            line(.iLT,.iTP)-(.iRT,.iBT),0,bf
            for iYY as integer = qTP*BlockSz to qBT*BlockSz step BlockSz
              for iXX as integer = qLT*BlockSz to qRT*BlockSz step BlockSz
                ShowButtonsFromQuadrant( iXX , iYY , 1 )
              next iXX
            next iYY
          else            
            put (iOX,iOY),pBack,pset 'Remove Temp Dragging Button
          end if              
          ' Keep Background rect on screen limits
          iOX = iX-iOffX : iOY = iY-iOffY
          if iOX < 0 then iOX = 0
          if iOY < 0 then iOY = 0
          var iXX = iOX+(.iRT-.iLT)
          var iYY = iOY+(.iBT-.iTP)
          if iXX >= WindowWidth  then iXX =  WindowWidth-1
          if iYY >= WindowHeight then iYY = WindowHeight-1
          get (iOX,iOY)-(iXX,iYY), pBack 'Grab new bg
          'Update to new position (for draw)
          .iLT = iOX : .iRT = iOX+iSX
          .iTP = iOY : .iBT = iOY+iSY
          DrawButton( iButtonID )          
        end if        
      end if  
     
      ' Was button released?
      if (NB and 2)=0 then
        ImageDestroy( pBack ) 'Destroy Temp Image
        AddToQuadrant( iButtonID )    'Reinsert Button to Quadrant
        BringButtonToTop( iButtonID ) 'And put it on top (!)
        DrawButton( iButtonID )       'Draw It one last time.
        exit do 'Done!
      end if
     
      ' Draws an outline border to show that it's been dragging
      if iMustRemove<>-1 then
        var iSwap = -(((timer-dStart)*18) and 1) 'Swap borders 10x/s
        line (.iLT,.iTP)-(.iRT,.iBT),14,b,&h5555 xor iSwap
        line (.iLT,.iTP)-(.iRT,.iBT),1,b,&hAAAA xor iSwap
      else
        iMustRemove=0
      end if      
      sleep 10,1
    loop 'Keep looping until rbutton is released
  end with    
 
end sub
 
' ======================================================================================
' ================================== MAIN PROGRAM START ================================
' ======================================================================================
 
' *** Creating Some Buttons ***
for CNT as integer = 0 to Buttons
  with tButtons(CNT)
   .iLT = int(rnd*WindowWidth)  '0 to Wid-1
   .iTP = int(rnd*WindowHeight) '0 to Hei-1
   .iRT = .iLT+32+rnd*64
   .iBT = .iTP+16+rnd*24      
  end with  
  AddToQuadrant( CNT )  
next CNT
 
' *** Speed Test For Button Find ***
#if 0
scope
  dim as integer iFound,iMiss
  dim as double TMR = timer
  do
    var iPX = int(rnd*WindowWidth)  '0 to wid-1
    var iPY = int(rnd*WindowHeight) '0 to hei-1
    if FindButtonByPos( iPX , iPY ) >= 0 then
      iFound += 1
    else
      iMiss += 1
    end if  
  loop until (timer-TMR) >= 1
  print "Total: " & iMiss+iFound
  print "Found: " & iFound
  print "Miss.: " & iMiss
  sleep
end scope
#endif
 
' **************** Pratical TEST with z-order *****************
screenres WindowWidth, WindowHeight,8,2
 
' Drawing All Buttons in reverse order (z-order)
for iBut as integer = Buttons to 0 step -1
  DrawButton( iBut )  
next iBut
 
dim as integer iLDown,iMX,iMY,iMB
do
  if getmouse(iMX,iMY,,iMB)=0 then
    if (iMB and 3) then
      if iLDown=0 then
        iLDown = 1 'Clicked
       
        ' Clicked on a button?
        var iBut = FindButtonByPos( iMX , iMY )        
        if iBut >= 0 then 'found button!
         
          BringButtonToTop( iBut )
          DrawButton( iBut )        
               
          'Shift+click? then showing all buttons on quadrant
          if multikey(fb.SC_LSHIFT) or multikey(fb.SC_RSHIFT) then 'Shift+Click?
            ShowButtonsFromQuadrant( iMX , iMY )
          elseif (iMB=2) then 'Right Click to Drag
            DragButton( iBut , iMX , iMY )
          else 'Make Button Blink
            BlinkButton( iBut , 2 )
          end if
         
        end if
      end if
    else
      iLDown = 0
    end if
  end if
  sleep 1,1
loop until multikey(fb.SC_ESCAPE)

screen 0