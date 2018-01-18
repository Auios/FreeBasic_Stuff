#macro NovaPalavra(GID,PALA)
dim shared as integer GID
WORDIDX += 1
if WORDIDX > WMAXID then
  WMAXID += 16
  redim preserve LANGWORD(WMAXID)
end if  
GID = WORDIDX
#ifdef MakeLang
LANGWORD(WORDIDX) = PALA
print #WFILE,WORDIDX & "," & PALA
#endif
#endmacro

''
'' Preparação para criar/carregar palavras
''
dim shared as string LANGWORD()
dim as integer WORDIDX
dim as integer WMAXID
dim as integer WFILE  
WMAXID = 16
redim preserve LANGWORD(WMAXID)
#ifdef MakeLang
WFILE = Freefile()
open "Config\Lang\Default.txt" for output as #WFILE
#endif

''
'' Adicionando Indices ou palavras
''
NovaPalavra(LW_PRONTO,"Pronto.")
NovaPalavra(LW_MENUARQUIVO, "Arquivo")
NovaPalavra(LW_ARQABRIR,"Abrir")
NovaPalavra(LW_ARQSAIR,"Sair")
NovaPalavra(LW_MENUJANELAS,"Janelas")
NovaPalavra(LW_JANFECHATUDO,"Fechar Todas")

#ifdef MakeLang
close #WFILE
#else

''
'' Carregando arquivo de linguagem
''
scope  
  dim as integer WFILE,COUNT
  dim as string WTMP,MYTXT
  for COUNT = 0 to ubound(LANGWORD)
    WTMP = str$(COUNT)
    LANGWORD(COUNT) = "[#" + string$(5-len(WTMP),"0"+WTMP) + WTMP + "]"
  next COUNT
  WFILE = Freefile()
  WTMP = "Config\Lang\Portuguese.txt"
  CheckErrorEx(dir$(WTMP)="","Arquivo de linguagem não encontrado: "+WTMP)
  open WTMP for input as #WFILE
  do
    if eof(WFILE) then exit do
    do
      if eof(WFILE) then exit do
      input #WFILE,MYTXT
    loop until val(MYTXT) > 0
    COUNT = val(MYTXT)    
    do
      if eof(WFILE) then exit do
      input #WFILE,WTMP
      WTMP = trim$(WTMP)
    loop until WTMP <> ""
    LANGWORD(COUNT) = WTMP
  loop
  
  close #WFILE
  
end scope
#endif