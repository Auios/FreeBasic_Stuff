#include "drawfont.bas"
screenres 600,400,32
WindowTitle "Mysoft FontDraw Testing!"
Paint (1, 1), rgb(255,255,255)
DrawFont(,11,11,"Mysoft FontDraw Test","Times New Roman",14,rgb(0,0,0),FS_BLUR or FS_BOLD)
DrawFont(,13,13,"Mysoft FontDraw Test","Times New Roman",14,rgb(20,20,20),FS_BLUR or FS_BOLD)
DrawFont(,12,12,"Mysoft FontDraw Test","Times New Roman",14,rgb(255,255,255),FS_BOLD)

DrawFont(,12,60,"Mysoft FontDraw Test","Arial",8,rgb(0,0,0),)

DrawFont(,11,79,"Mysoft FontDraw Test","Arial",8,rgb(150,150,250),)
DrawFont(,13,79,"Mysoft FontDraw Test","Arial",8,rgb(150,150,250),)
DrawFont(,11,81,"Mysoft FontDraw Test","Arial",8,rgb(250,150,150),)
DrawFont(,13,81,"Mysoft FontDraw Test","Arial",8,rgb(250,150,150),)
DrawFont(,12,80,"Mysoft FontDraw Test","Arial",8,rgb(255,255,255),)

DrawFont(,12,110,"Mysoft FontDraw Test","Georgia",28,rgb(0,0,0),)
DrawFont(,12,200,"Mysoft FontDraw Test","BIRTH OF A HERO",28,rgb(0,0,0),)
DrawFont(,12,250,"Mysoft FontDraw Test","BIRTH OF A HERO",28,rgb(0,0,0), FS_ANTIALIAS)
sleep