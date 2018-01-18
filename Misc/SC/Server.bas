'Server
#include "fbgfx.bi"
#include "wshelper.bi"
#include "debugTools.bi"

#include "Connection.bas"

using fb

dim as boolean runApp = true
dim as integer wdim,old_wdim, conWdth, conHght
dim as string cmdString

dim shared as Connection server

server.startServer(28000)
wdim = width()
conWdth = hiWord(wdim)
conHght = loWord(wdim)

while(runApp)
    wdim = width()
    if(wdim <> old_wdim) then
        print "omg"
        old_wdim = wdim
        conWdth = hiWord(wdim)
        conHght = loWord(wdim)
    end if
    
    'locate(conWdth-1,5,0):print conWdth
    
    if(multikey(sc_escape)) then runApp = false
    
    sleep(50,1)
wend

server.shutDown()

sleep()