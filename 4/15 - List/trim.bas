dim as string myword = "Hello"

print len(myword)
for i as integer = 1 to len(myword)
    print len(mid(myword,i,2)),mid(myword,i,2)
next i


sleep