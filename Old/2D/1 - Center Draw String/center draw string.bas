dim shared as integer scrnx,scrny
screeninfo scrnx,scrny
screenres scrnx,scrny,16,2,1

dim shared as uinteger white,red,green,blue,grey
white = rgb(255,255,255)
red = rgb(255,0,0)
green = rgb(0,255,0)
blue = rgb(0,0,255)
grey = rgb(75,75,75)

dim as string phrase
dim as integer length
dim as double middle
phrase = "This is a phrase."
length = len(phrase)
middle = length*4

line(scrnx/2,0) - (scrnx/2,scrny),grey
line(0,scrny/2) - (scrnx,scrny/2),grey
draw string(scrnx/2-middle,scrny/2-4),phrase,white
sleep