#Include "window9.bi"
Dim As Byte Ptr sourse=Allocate(10000005),Dest= Allocate(10000)
Dim As Integer sizeCompress
For a As Integer=1 To 10000000
 Poke  sourse+a, a
Next

sizeCompress=compressMem(dest,sourse,10000000) 
? "Compress=" & sizeCompress
? "Decompress="& DeCompressMem(dest,sizeCompress,sourse)
Sleep
DeAllocate(sourse):DeAllocate(dest)

