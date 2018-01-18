#Include "window9.bi"
Dim As String st="Hello"
? st, "CRC=";FastCRC32(@st,Len(st))
st=Encode64(st)
? st
st=Decode64(st)
? st,"CRC=";FastCRC32(@st,Len(st))
Sleep