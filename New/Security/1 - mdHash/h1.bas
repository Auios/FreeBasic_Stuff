#include "fbgfx.bi"
#Include Once "md/security/mdMessageDigest.bi"
Dim As String result
Dim As String text = "MyPassword"

'dim as integer f
'f = freefile
'
'open "A.dll" for binary as #f
'
'dim as byte dtta(lof(f))
'
'print lof(f)
'sleep 1000,1
'
'for i as integer = 0 to ubound(dtta)
'    get #f,,dtta(i)
'    
'    print hex(dtta(i)),i
'    
'    if multikey(fb.sc_escape) then exit for
'next i
'
'close #f
'

Dim As mdMessageDigest m = mdMessageDigest.getInstance("SHA-1")'SHA-1,MD5,SHA-512

result = m.createFileHash("Assembly-CSharp.dll")

Print result

sleep