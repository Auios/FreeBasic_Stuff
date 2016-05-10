#include "fbgfx.bi"
#include "aulib.bi"
#include "file.bi"

using fb, auios

dim as string filename = "img.png"
dim as integer ff = freefile

type AuPNG
    as ubyte signature(0 to 7)
    as ubyte bitDepth
    as ubyte compressionMethod
    as ubyte filterMethod
    as ubyte interlaceMethod
    as ulong h,w
    as ulong chunkSize
    as longint size
    as string fileName
    as ubyte tmp
end type

dim as AuPNG png

open filename for binary as ff

with PNG
    .size = fileLen(fileName)
    get #ff,1,.signature()
    get #ff,9,.chunkSize
    get #ff,20,.w
    get #ff,24,.h
end with

close #ff

with PNG
    print "File size: " & .size
    print "Signature:"
    for i as integer = 0 to 7
        print .signature(i)
    next i
    
    print "Len: " & .chunkSize
    
    print "Width: " & .w
    print "Height: " & .h
end with
sleep