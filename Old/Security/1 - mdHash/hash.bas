#Include Once "md/security/mdMessageDigest.bi"
Dim As String result
Dim As String text = "MyPassword"

Dim As mdMessageDigest m = mdMessageDigest.getInstance("SHA-512")'SHA-1,MD5
result = m.createHash(text)

Print result

sleep