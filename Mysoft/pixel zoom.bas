#include "fbgfx.bi"
 
const PI = atn(1)/45
const cTrans = 0
const cBlack = 17
const cWhite = 18
const cBorder = 31
#define w(_NN_) (((_NN_)+iOffsetX)*iScale)
#define h(_NN_) (((_NN_)+iOffsetY)*iScale)
 
dim shared as single iScale = 3
dim shared as integer iOffsetX=0,iOffsetY=0
dim shared as fb.image ptr pNum1
 
screenres w(160),h(240),8
line(w(0),h(0))-(w(160),h(240)),255,bf
 
palette 0,255,0,255
palette cBlack,8,8,8
palette cWhite,248,248,248
palette cBorder,88,56,72
for CNT as integer = 0 to 47
  palette 32+CNT,88+((224-88)/47)*CNT,128+((248-128)/47)*CNT,48+((144-48)/47)*CNT
next CNT
palette 255,32,64,128
 
pNum1 = ImageCreate(10*w(12),h(28))
 
iOffsetX=0:iOffsetY=0
dim as integer iN1(...) = { _
w(1),h(1),w(12),h(18),cBlack,w(0),h(0),w(11),h(17),cBlack,  _  ' **** 0 ****
w(1),h(1),w(10),h(16),cWhite,w(5),h(5),w(6),h(12),cBlack,-1,_  
w(2),h(1),w(8),h(18),cBlack,w(1),h(1),w(7),h(17),cBlack,    _  ' **** 1 ****
w(0),h(0),w(7),h(6),cBlack,w(1),h(1),w(6),h(5),cWhite,      _
w(2),h(2),w(6),h(16),cWhite,-1,                             _
w(1),h(1),w(12),h(18),cBlack,w(0),h(0),w(11),h(17),cBlack,  _  ' **** 2 ****
w(1),h(1),w(10),h(16),cWhite,w(0),h(5),w(6),h(6),cBlack,    _  
w(5),h(11),w(10),h(12),cBlack,-1,                           _
w(1),h(1),w(12),h(18),cBlack,w(0),h(0),w(11),h(17),cBlack,  _  ' **** 3 ****
w(1),h(1),w(10),h(16),cWhite,w(0),h(5),w(6),h(6),cBlack,    _  
w(0),h(11),w(6),h(12),cBlack,-1,                            _
w(6),h(1),w(12),h(18),cBlack,w(0),h(0),w(11),h(14),cBlack,  _  ' **** 4 ****
w(1),h(1),w(10),h(16),cWhite,w(1),h(13),w(6),h(17),cBlack,  _
w(1),h(15),w(5),h(17),cTrans,w(5),h(1),w(6),h(9),cBlack,-1, _
w(1),h(1),w(12),h(18),cBlack,w(0),h(0),w(11),h(17),cBlack,  _  ' **** 5 ****
w(1),h(1),w(10),h(16),cWhite,w(5),h(5),w(10),h(6),cBlack,   _
w(0),h(11),w(6),h(12),cBlack,-1,                            _
w(1),h(1),w(12),h(18),cBlack,w(0),h(0),w(11),h(17),cBlack,  _  ' **** 6 ****
w(1),h(1),w(10),h(16),cWhite,w(5),h(5),w(10),h(6),cBlack,   _  
w(5),h(11),w(6),h(12),cBlack,-1,                            _
w(6),h(1),w(12),h(18),cBlack,w(0),h(0),w(11),h(10),cBlack,  _  ' **** 7 ****
w(1),h(1),w(10),h(16),cWhite,w(1),h(9),w(6),h(17),cBlack,   _
w(1),h(11),w(5),h(17),cTrans,w(5),h(5),w(6),h(9),cBlack,-1, _
w(1),h(1),w(12),h(18),cBlack,w(0),h(0),w(11),h(17),cBlack,  _  ' **** 8 ****
w(1),h(1),w(10),h(16),cWhite,w(5),h(5),w(6),h(6),cBlack,    _
w(5),h(11),w(6),h(12),cBlack,-1,                            _
w(1),h(1),w(12),h(18),cBlack,w(0),h(0),w(11),h(17),cBlack,  _  ' **** 9 ****
w(1),h(1),w(10),h(16),cWhite,w(5),h(5),w(6),h(6),cBlack,    _  
w(0),h(11),w(6),h(12),cBlack }
 
iOffsetX=0:iOffsetY=18
dim as integer iN2(...) = { _
w(0),h(0),w(7),h(10),cBlack,w(1),h(1),w(6),h(9),cWhite,     _  ' **** 0 ****
w(3),h(3),w(4),h(7),cBlack,-1,                              _
w(0),h(0),w(5),h(4),cBlack,w(1),h(4),w(5),h(10),cBlack,     _  ' **** 1 ****
w(1),h(1),w(4),h(3),cWhite,w(2),h(3),w(4),h(9),cWhite,-1,   _
w(0),h(0),w(7),h(10),cBlack,w(1),h(1),w(6),h(9),cWhite,     _  ' **** 2 ****
w(1),h(3),w(4),h(4),cBlack,w(3),h(6),w(6),h(7),cBlack,-1,   _
w(0),h(0),w(7),h(10),cBlack,w(1),h(1),w(6),h(9),cWhite,     _  ' **** 3 ****
w(1),h(3),w(4),h(4),cBlack,w(1),h(6),w(4),h(7),cBlack,-1,   _
w(0),h(0),w(7),h(7),cBlack,w(3),h(7),w(7),h(10),cBlack,     _  ' **** 4 ****
w(1),h(1),w(6),h(6),cWhite,w(4),h(6),w(6),h(9),cWhite,      _
w(3),h(1),w(4),h(4),cBlack,-1,                              _
w(0),h(0),w(7),h(10),cBlack,w(1),h(1),w(6),h(9),cWhite,     _  ' **** 5 ****
w(3),h(3),w(6),h(4),cBlack,w(1),h(6),w(4),h(7),cBlack,-1,   _
w(0),h(0),w(7),h(10),cBlack,w(1),h(1),w(6),h(9),cWhite,     _  ' **** 6 ****
w(3),h(3),w(6),h(4),cBlack,w(3),h(6),w(4),h(7),cBlack,-1,   _
w(0),h(0),w(7),h(4),cBlack,w(3),h(3),w(7),h(10),cBlack,     _  ' **** 7 ****
w(1),h(1),w(6),h(3),cWhite,w(4),h(3),w(6),h(9),cWhite,-1,   _
w(0),h(0),w(7),h(10),cBlack,w(1),h(1),w(6),h(9),cWhite,     _  ' **** 8 ****
w(3),h(3),w(4),h(4),cBlack,w(3),h(6),w(4),h(7),cBlack,-1,   _
w(0),h(0),w(7),h(10),cBlack,w(1),h(1),w(6),h(9),cWhite,     _  ' **** 9 ****
w(3),h(3),w(4),h(4),cBlack,w(1),h(6),w(4),h(7),cBlack }
 
iOffsetX = 0
for CNT as integer = 0 to ubound(iN1)-1 step 5
  if iN1(CNT)=-1 then iOffsetX += 1: CNT += 1
  var iX=iOffsetX*12*iScale
  line pNum1,(iX+iN1(CNT),iN1(CNT+1))-(iX+iN1(CNT+2)-1,iN1(CNT+3)-1),iN1(CNT+4),bf  
next CNT
 
iOffsetX = 0
for CNT as integer = 0 to ubound(iN2)-1 step 5
  if iN2(CNT)=-1 then iOffsetX += 1: CNT += 1
  var iX=iOffsetX*7*iScale
  line pNum1,(iX+iN2(CNT),iN2(CNT+1))-(iX+iN2(CNT+2)-1,iN2(CNT+3)-1),iN2(CNT+4),bf  
next CNT
 
 
put (4*iScale,64*iScale),pNum1,pset
 
 
sleep