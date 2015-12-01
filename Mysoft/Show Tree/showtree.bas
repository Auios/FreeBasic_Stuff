#include "dir.bi"
 
sub ShowTree(sFolder as string,iLevel as integer=0)  
  ' Array showing "last level" flag
  static as byte ptr pLevels
  if pLevels = 0 then
    pLevels = allocate(16) 'Start with 16 items
  else
    if (iLevel and 15)=15 then
      pLevels = reallocate(pLevels,iLevel+17)
    end if
  end if
 
  'First Lets enumerate all FOLDERS on the current path since
  'Dir$() wont work recursively...
  var iFound=0,sDir=dir$(sFolder+"/*",fbDirectory)
  redim as string sList(15) 'Start with 16 items
 
  pLevels[iLevel] = 1
  while len(sDir)
    if sDir <> "." and sDir <> ".." then 'Ignore Dummy Folders
      'More Space on the list if apply
      if (iFound and 15)=15 then redim preserve sList(iFound+16)
      'Add Item
      sList(iFound) = sDir: iFound += 1
    end if
    'Get Next Item
    sDir = dir$()    
  wend
 
  'Now Show the current folder while recursively enumerating subfolders them as well
  for CNT as integer = 0 to iFound-1
    'Print Previous Levels
    color 3
    for I as integer = 0 to iLevel-1
      if pLevels[I] then print !"\179   "; else print "    ";
    next I
    'Print Current Level|Item (normal/last node)
    if CNT = iFound-1 then
      print !"\192\196\196\196";: pLevels[iLevel]=0
    else
      print !"\195\196\196\196";
    end if
    color 7: print sList(CNT)
    'Recursively Check children folders of next level
    ShowTree(sFolder+"/"+sList(CNT),iLevel+1)
  next CNT
 
  ' Deallocating Level flag array
  if iLevel = 0 then deallocate(pLevels):pLevels=0
 
end sub
 
var sStartDir = exepath
print sStartDir
 
ShowTree(sStartDir)
sleep