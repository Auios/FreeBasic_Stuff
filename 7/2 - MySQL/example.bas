#include "AuLib.bi"

using aulib

dim as AuSQL sql

sql.connect("localhost","root","5018","Telchaxy")

sql.query("SELECT * FROM people")
print(sql.getRowCount())
print(sql.getFieldCount())

while(sql.getRow())
    dim as string x
    for i as integer = 0 to sql.getFieldCount()-1
        x+=sql.getItem(i) & iif(i = sql.getFieldCount()-1,"", ", ")
    next i
    print x
wend

sql.close()
sleep()
