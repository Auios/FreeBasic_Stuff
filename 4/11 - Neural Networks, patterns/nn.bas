'http://ir.nmu.org.ua/bitstream/handle/123456789/126991/13065b1c29abaa6417bdac212d6cd234.pdf?sequence=1
'Page 12
'Page 135

#define switch 5
#if (switch = 1)

#include "fbgfx.bi"
#include "scrn.bas"
using fb

#define e 2.71828

randomize timer



scrn()
dim shared as single sum,value

dim shared as single pic(1,1),cor(1,1),nw(1,1)

'10
'01
cor(0,0) = 1
cor(1,0) = 0
cor(0,1) = 1
cor(1,1) = 0

sub InitNeuron()
    for ix as integer = lbound(nw,1) to ubound(nw,1)
        for iy as integer = lbound(nw,2) to ubound(nw,2)
            nw(ix,iy) = 1*rnd
        next iy
    next ix
end sub

sub initPic()
    for ix as integer = lbound(pic,1) to ubound(pic,1)
        for iy as integer = lbound(pic,2) to ubound(pic,2)
            pic(ix,iy) = 1*rnd
            print pic(ix,iy)
            
            circle((ix*50)+200,(iy*50)+100),25,rgb(255*pic(ix,iy),255*pic(ix,iy),255*pic(ix,iy)),,,,f
        next iy
    next ix
end sub

sub calc()
    sum = 0
    value = 0
    
    for ix as integer = lbound(pic,1) to ubound(pic,1)
        for iy as integer = lbound(pic,2) to ubound(pic,2)
            'sum+=pic(ix,iy) * cor(ix,iy)
            sum+=pic(ix,iy) * nw(ix,iy)
        next iy
    next ix
    
    value = 1/(1+e^-sum)
end sub

'=========================================

initNeuron()

do
    cls
    initPic()
    calc()
    
    print "==========="
    print "Sum:     " & sum   & " - " & iif(sum   > .5,"True","False")
    print "Signoid: " & value
    
    sleep
loop until multikey(sc_escape)

#elseif (switch = 2)

#include "fbgfx.bi"
#include "scrn.bas"
using fb

#define e 2.71828

randomize timer



'http://prntscr.com/7bi6wr

'v1:
'W_eight[Layer,Neuron,Connection]
'O_utput[Layer,Neuron]

'v2:
'W[neuron_that_connection_is_coming_from, neuron_that_connection_is_going_to]
'O[neuron_number]

'====================================A.2, Forward Pass

dim as uinteger couu = 0

dim shared as single w(10,10,10)
dim shared as single o(10,10)
dim shared as single d(10,10)

dim shared as single t(10,10)

dim shared as single te 'Total error

for a as integer = 0 to 8
    for s as integer = 0 to 9
        for d as integer = 0 to 9
            w(a,s,d) = 0
        next d
    next s
next a

'Set up weights (Values can be anything I believe) (0 to 1 only)
w(1, 1, 1) = .8
w(1, 1, 2) = .2
w(1, 1, 3) = .3

w(1, 2, 1) = .5
w(1, 2, 2) = .2
w(1, 2, 3) = .6

w(2, 1, 1) = .9
w(2, 1, 2) = .8
w(2, 1, 3) = .4

w(2, 2, 1) = .1
w(2, 2, 2) = .3
w(2, 2, 3) = .8

w(3, 1, 1) = .5
w(3, 1, 2) = .4

'Main training loop
do
    'Set up pattern 1
    o(1,1) = 0
    o(1,2) = 0
    o(1,3) = 1
    t(3,1) = 1
    te = 0
    
    for l as integer  = 1 to 3 'Layer
        for n as integer = 1 to 3 'Neurons
            for c as integer = 1 to 3 'Connections
                o(l+1,n)+=o(l,c) * w(l,n,c) 'Sum weighted inputs to neuron
            next c
            o(l+1,n) = 1/(1+exp(-1 * o(l+1,n))) 'Calculate sigmoid
        next n
    next l
    
    'Calculate Error
    d(3,1) = o(3,1) * (1 - o(3,1)) * (t(3,1) - o(3,1))
    
    'Total error for this pattern
    te+=d(3,1)^2
    
    'Reverse pass - Calculate weight change
    for l as integer = 3 to 1 step -1 'Going backwards from the last layer
        for n as integer = 1 to 8 'Neurons
            for c as integer = 1 to 8 'Weights
                w(l,n,c)+= d(l+1,n) * o(l,c)
            next c
        next n
        
        'Reverse pass - Calculate errors
        for n as integer = 1 to 8
            for c as integer = 1 to 8
                d(l,n)+= d(l+1,c) * w(l,c,n)
            next c
            d(l,n)*= o(l,n) * (1-o(l,n))
        next n
    next l
    
    'Pattern 2 - Stages as above
    o(1,1) = 1
    o(1,2) = 0
    o(1,3) = 0
    t(3,1) = 0
    
    for l as integer = 1 to 3 'Layer
        for n as integer = 1 to 3 'Neurons
            for c as integer = 1 to 3 'Connections
                'Sum weighted inputs to neuron
                o(l+1,n)+= o(l,c) * w(l,n,c)
            next c
            o(l+1,n) = 1/(1+exp(-1*o(l+1,n))) 'Calculate Sigmoid
        next n
    next l
    
    d(3,1) = o(3,1) * (1 - o(3,1)) * (t(3,1) - o(3,1))
    te+= d(3,1) ^ 2
        
    for l as integer = 3 to 1 step -1
        for n as integer = 1 to 8
            for c as integer = 1 to 8
                w(l,n,c)+= d(l+1,n) * o(l,c)
            next c
        next n
        
        for n as integer = 1 to 8
            for c as integer = 1 to 8
                d(l,n)+=d(l+1,c) * w(l,c,n)
            next c
            d(l,n)*=o(l,n) * (1-o(l,n))
        next n
    next l
    
    couu+=1
    print couu & ": " & te 'Final error
    
    sleep 5
loop until te < .0002 or multikey(sc_escape)

print "Pattern 1, target 1"

o(1,1) = 0
o(1,2) = 0
o(1,3) = 0

for l as integer = 1 to 3
    for n as integer = 1 to 3
        for c as integer = 1 to 3
            o(l+1,n)+=o(l,c) * w(l,n,c) 'Sum weighted inputs to neuron
        next c
        o(l+1,n) = 1/(1+exp(-1 * o(l+1,n))) 'Calculate sigmoid
    next n
next l

print "Output = " & o(3,1)


sleep

#elseif (switch=3)

#include "fbgfx.bi"
#include "scrn.bas"
using fb

#define e 2.71828

randomize timer



scrn()

'variables
dim shared as single out1,out2
dim shared as single length

'Setup neuron's weights
dim shared as single w1a,w2a,w1b,w2b,in1a,in2a,in1b,in2b
w1a = 1
w1b = 0

w2a = 0
w2b = 1
'10
'01

'Setup inputs
in1a = -.707
in2a =  .707
in1b =  .707
in2b =  .707

for t as integer = 1 to 100
    'Pattern 1
    out1 = in1a * w1a + in1b * w1b
    out2 = in1a * w2a + in1b * w2b
    
    'If Neuron 1 wins
    if out1 > out2 then
        w1a+= .1 * (in1a - w1a) 'Change weights
        w1b+= .1 * (in1b - w1b)
        
        length = sqr((w2a ^ 2) + (w2b ^ 2))
        w2a/= length
        w2b/= length
    end if
    
    'Pattern 2
    out1 = in2a * w1a + in2b * w1b
    out2 = in2a * w2a + in2b * w2b
    
    if out1 > out2 then
        w1a+= .1 * (in2a - w1a) 'Change weights
        w1b+= .1 * (in2b - w1b)
        
        length = sqr((w1a ^ 2) + (w1b ^ 2))
        w1a/= length
        w1b/= length
    end if
    
    if out1 > out2 then
        w2a+= .1 * (in2a - w2a) 'Change weights
        w2b+= .1 * (in2b - w2b)
        
        length = sqr((w2a ^ 2) + (w2b ^ 2))
        w2a/= length
        w2b/= length
    end if
    var x = 400
    var y = 300
    line(x,y)-(x+w1a*50,y-w1b*50)
    line(x,y)-(x+w2a*50,y-w2b*50)
    line(x,y)-(x+in1a*50,y-in1b*50)
    line(x,y)-(x+in2a*50,y-in2b*50)
    
    sleep 10
    
next t

'print Final weights after 100 iterations

print "First weights =  " & w1a & " " & w1b
print "second weights = " & w2a & " " & w2b
sleep

#elseif (switch=4)
#lang "qb"

SCREEN 7
REM set up neuron's weights
w1a = 1: w1b = 0: REM first neuron
w2a = 0: w2b = 1: REM second neuron
REM set up inputs
in1a = -.707: in1b = .707: REM first pattern
in2a = .707: in2b = -.707: REM second pattern
FOR t = 1 TO 100 
    REM pattern number 1
 out1 = in1a * w1a + in1b * w1b
 out2 = in1a * w2a + in1b * w2b
 REM if neuron 1 wins
 IF out1 > out2 THEN
 w1a = w1a + .1 * (in1a - w1a): REM change weights
 w1b = w1b + .1 * (in1b - w1b)
 length = SQR((w1a ^ 2) + (w1b ^ 2)): REM normalise weight vector to
'one unit
 w1a = w1a / length: w1b = w1b / length
 END IF
 REM if neuron 2 wins
 IF out2 > out1 THEN
 w2a = w2a + .1 * (in1a - w2a)
 w2b = w2b + .1 * (in1b - w2b)
 length = SQR((w2a ^ 2) + (w2b ^ 2))
 w2a = w2a / length: w2b = w2b / length
 END IF
 REM pattern number 2
 out1 = in2a * w1a + in2b * w1b
 out2 = in2a * w2a + in2b * w2b
 IF out1 > out2 THEN
 w1a = w1a + .1 * (in2a - w1a)
 w1b = w1b + .1 * (in2b - w1b)
 length = SQR((w1a ^ 2) + (w1b ^ 2))
 w1a = w1a / length: w1b = w1b / length
 END IF
 IF out2 > out1 THEN
 w2a = w2a + .1 * (in2a - w2a)
 w2b = w2b + .1 * (in2b - w2b)
 length = SQR((w2a ^ 2) + (w2b ^ 2))
 w2a = w2a / length: w2b = w2b / length
 END IF
REM draw weight and input vectors
LINE (50, 50)-(50 + w1a * 50, 50 - w1b * 50)
LINE (50, 50)-(50 + w2a * 50, 50 - w2b * 50)
LINE (50, 50)-(50 + in1a * 50, 50 - in1b * 50)
LINE (50, 50)-(50 + in2a * 50, 50 - in2b * 50)
REM pause to let user see result
DO
 ans$ = INKEY$
LOOP UNTIL ans$ <> ""
NEXT t
REM print final weights after 100 interations
PRINT " first weights = "; w1a; " "; w1b
PRINT " Second weights = "; w2a; " "; w2b
PRINT " press a to return"
DO
 ans$ = INKEY$
LOOP UNTIL ans$ = "a"

#elseif (switch=5)
#lang "qb"
SCREEN 7
CLS
REM set up time constants for neurons
n1t1 = 5: n1t3 = 10
n2t1 = 5: n2t3 = 10
REM Initialise each neuron's internal clock to zero
clk1 = 0: clk2 = 0
REM Set up weights in network
w12 = -1: w21 = -1
REM set up initial conditions
o1 = -1: o2 = 1
REM neuron thresholds
thres1 = 0: thres2 = 0
REM Main program time step
FOR t = 1 TO 200

 REM neuron 1
 REM set up neuron's inputs and calculate its output
 i1 = o2
 net1 = i1 * w21

 REM if neuron is triggered
 IF net1 > thres1 AND clk1 = 0 THEN
 o1 = 1
 clk1 = clk1 + 1
 END IF
 REM if neuron is producing a pulse
 IF clk1 > 0 AND clk1 <= n1t1 THEN
 clk1 = clk1 + 1 
 o1 = 1
 END IF
 REM if neuron has produced a pulse and is in rest period
 IF clk1 > n1t1 AND clk1 <= n1t3 THEN
 o1 = -1
 clk1 = clk1 + 1
 END IF
 REM if neuron has fired and is ready to be retriggered
 IF clk1 > n1t3 THEN
 o1 = -1
 clk1 = 0
 END IF

 REM print neuron's output on screen
 PSET (t * 2, 50 - (o1 * 10))
 REM neuron 2, the various parts of the algorithm follow neuron ones.
 i2 = o1: REM connect input 2 to output 1
 net2 = i2 * w12

 IF net2 > thres2 AND clk2 = 0 THEN
 o2 = 1
 clk2 = clk2 + 1
 END IF
 IF clk2 > 0 AND clk2 <= n2t1 THEN
 clk2 = clk2 + 1
 o2 = 1
 END IF
 IF clk2 > n2t1 AND clk2 <= n2t3 THEN
 o2 = -1
 clk2 = clk2 + 1
 END IF
 IF clk2 > n2t3 THEN
 o2 = -1
 clk2 = 0
 END IF
 PSET (t * 2, 100 - (o2 * 10))
NEXT t
sleep
#endif


'sum =  (0.7 * 1) + (0.1 * 0) + (0.2 * 1) + (0.9 * 0)
'
'value = 1/(1+e^-sum)
'print sum
'print value