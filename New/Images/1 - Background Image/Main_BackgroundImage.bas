ScreenRes 800,600,32
Dim bg As Any Ptr = ImageCreate(800,600)
BLoad "bg.bmp", bg
Put(0,0),bg
ImageDestroy(bg)
Sleep