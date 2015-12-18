print rgba(255,0,0,255)
print rgb(255,0,0)
print
print rgba(255,0,0,0)
print
print rgba(0,0,0,0)
print rgba(1,0,0,0)
print rgba(0,1,0,0)
print rgba(0,0,1,0)
print
print rgba(0,0,0,1)
print rgba(0,0,0,2)
print
print rgba(255,255,255,255)
print rgba(0,0,0,255)
print rgba(255,0,0,255)
print rgba(0,255,0,255)
print rgba(0,0,255,255)
print

var R = 255
var G = 255
var B = 255
var A = 255
dim as uinteger result1 = 256^2*R+256*G+B+16777216*A
dim as uinteger result2 = A shl 8*3+R shl 8*2+G shl 8*1+B
dim as uinteger result3 = A*2^24+R*2^16+G*2^8+B
print rgba(R,G,B,A)
print result1
print result2
print result3
sleep