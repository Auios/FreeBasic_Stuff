'#define ShowPath
 
' ******* estrutura para armazenar movimentos do jogador (para o inimigo) ********
type RECPS
  X as byte
  Y as byte
end type
 
' ********* Declara as variaveis **********
dim as integer LIN,COL,XYT,VX,VY,COUNT
dim as integer STX,STY,ETX,ETY,PA,PB,TPCM
dim as integer DOMOV,MAXMOVS,PCMOV,LVL
dim as byte MATRIX(80,43)
dim as byte CRN(10) = {0,219,219,178,178,177,177,177,176,176,42}
dim as double TMR,NXM,DIFF
dim as string TECLA,NIV(10)
dim as recps RECMOVS(2000),FRZ(34400)
' (int) LIN = posi��o da linha (cria��o do labirinto)
' (int) COL = posi��o da coluna (cria��o do labirinto)
' (int) XYT = escolhe de direa��o (cria��o do labirinto)
' (int) VX = Velocidade X (movimenta��o) & temp X (limpeza/anima��o)
' (int) VY = Velocidade Y (movimenta��o) & temp Y (limpeza/anima��o)
' (int) COUNT = contador geral (movimenta��o,anima��o,verifica��o)
' (int) STX = posi��o X do jogador (movimenta��o)
' (int) STY = posi��o Y do jogador (movimenta��o)
' (int) PA = velocidade dire��o cima/baixo (cria��o do labirinto)
' (int) PB = velocidade dire��o baixo/cima (cria��o do labirinto)
' (int) TPCM = Tempo para come�ar a mover (inimigo/movimenta��o)
' (int) DOMOV = jogadas feitas pelo inimigo (movimenta��o inimigo/AI)
' (int) MAXMOVS = m�ximo de jogadas armazenadas do jogador (inimigo/AI)
' (int) LVL = contador indicador do n�vel (contagem)
' (byte) MATRIX(a,b) = matriz contendo parede(0) ou livre(1)
' (double) TMR = usado para timer em geral (anima��o/sincronia)
' (double) NXM = tempo para pr�ximo movimento do inimigo (movimenta��o/AI)
' (double) DIFF = timer para tempo do pr�ximo movimento (inimigo/AI)
' (string) TECLA = armazena tecla pressionada (verifica��o/movimenta��o)
' (string) NIV(a) = armazena numeral extenso do niveis (contagem)
' (2 bytes) RECMOVS(a).xy = armazena posi��es do jogador (movimenta��o/AI)
' (2 bytes) FRZ(a).xy = armazena posi��o para transi��o (cria��o labirinto)
 
' ***** inicializa tela e texto dos niveis *******
width 80,43
locate ,,0
 
randomize timer
NIV(1) = "  UM    ":NIV(2) = " DOIS   "
NIV(3) = " TRES   ":NIV(4) = "QUATRO  "
NIV(5) = " CINCO  ":NIV(6) = " SEIS   "
NIV(7) = " SETE   ":NIV(8) = " OITO   "
NIV(9) = " NOVE   ":NIV(10)= "  DEZ   "
 
' ***** Criando pontos aleatorios *******
for COUNT = 1 to 3440
  do
    VX = 1+cint(rnd*79)
    VY = 1+cint(rnd*42)
  loop until MATRIX(VX,VY)=0
  FRZ(COUNT).X = VX
  FRZ(COUNT).Y = VY
  MATRIX(VX,VY)=1
next COUNT
 
' ***** inicia o contador de niveis **********
for LVL = 1 to 10
  ' **** zera o mapa (labirinto) *******
  for VX = 0 to 80
    for VY = 0 to 42
      MATRIX(VX,VY) = 0
    next VY
  next VX
 
  ' **** anuncia o nivel e aguarda *******
  color 14,8:cls:color 14,1
  locate 20,32:print "                ";
  locate 21,32:print "  Nivel "+NIV(LVL);
  locate 22,32:print "                ";
  locate 42,20:print "Pressione qualquer tecla para continuar.";
  while inkey$ <> ""
    sleep 15
  wend
  sleep 1000,1:sleep
 
  ' **** seta variaveis para constru��o do labirinto *********
  LIN = 1+rnd*41
  COL = 0:VX=1:VY=0
  STY=LIN:STX=1
  'ETX=STX:ETY=STY
  if LIN > 20 then
    PA = -1:PB = 1
  else
    PA = 1:PB = -1
  end if
 
  ' ************ inicia cria��o do caminho para o fim ********
  while COL < 80
   
    ' ********* insere paredes e verifica posi��o *********
    COL += VX:LIN += VY
    if LIN >= 41 then PA = -1:PB = 1:LIN=41
    if LIN <= 1 then PA = 1:PB = -1:LIN=1
    MATRIX(COL,LIN) = -1
    COL += VX:LIN += VY
    if LIN >= 41 then PA = -1:PB = 1:LIN=41
    if LIN <= 1 then PA = 1:PB = -1:LIN=1
    MATRIX(COL,LIN) = -1
   
    ' ******** escolhe dire��o a seguir ***********
    do
      XYT = cint(rnd*5)
      if XYT = 5 then
        VX=1:VY=0:exit do
      end if
      if XYT > 1 then
        VY=PA:VX=0:exit do
        exit do
      end if
      if XYT < 2 then
        VY=PB:VX=0:exit do
      end if
    loop  
  wend
 
  ' ************* insere pontos para esconder o caminho ************
  for COUNT = 1 to 2000
    COL = 2+rnd*77
    LIN = 1+rnd*41
    if MATRIX(COL,LIN) = 0 then
      MATRIX(COL,LIN) = -2
    end if
  next COUNT
 
  ' ********** desenha o labirinto criado na tela ************
  color ((LVL-((LVL>7)*8))+1)
  color ,0
  TMR = timer
  for COUNT = 1 to 3440
    COL = FRZ(COUNT).X
    LIN = FRZ(COUNT).Y
    locate LIN,COL    
    color ((LVL-((LVL>7)*8))+1)
    if MATRIX(COL,LIN) then      
      if MATRIX(COL,LIN) = -1 then        
        #ifdef ShowPath
          color (((LVL-((LVL>7)*8))+1)+8)
          print "�";
        #else
          print chr$(177);
        #endif
      else
        print chr$(177);
      end if
    else      
      print chr$(CRN(LVL));      
    end if
    while (timer-TMR)< 1/2500
      sleep 1
    wend
    TMR += 1/2500
  next COUNT
 
  ' ******* seta variaveis dos jogadores **********
  MAXMOVS = 0:  PCMOV = -1
  RECMOVS(0).X = STX
  RECMOVS(0).Y = STY
  DIFF = .55-(LVL*.03) 'tempo de cada movimento
  TPCM = (12-LVL) 'tempo de vantagem
 
  ' ****** come�o do loop do jogador *****
  TMR = timer:NXM = TMR
  do
    ' **** desenha jogador *****
    VX=0:VY=0:color 10
    locate STY,STX
    print chr$(1); 'carinha jogador
    ' ***** verifica��o de movimenta��o do inimigo *****
    do
      if PCMOV>=0 or (timer-TMR)>TPCM then
        ' **** move/cria inimigo ********
        if (timer-NXM)>= DIFF then
          color 12
          ' ****** se nenhum movimento feito cria inimigo *******
          if PCMOV = -1 then
            PCMOV += 1
            locate RECMOVS(PCMOV).Y,RECMOVS(PCMOV).X
            print chr$(2); 'carinha inimigo
            ' ***** sen�o altera posi��o do inimigo ******
          else
            locate RECMOVS(PCMOV).Y,RECMOVS(PCMOV).X
            print " ";
            PCMOV += 1
            locate RECMOVS(PCMOV).Y,RECMOVS(PCMOV).X
            print chr$(2); 'carinha inimigo
            ' **** verifica se inimigo alcan�ou jogador ****
            if PCMOV >= MAXMOVS then
            'if RECMOVS(PCMOV).X = STX and RECMOVS(PCMOV).Y = STY then
              ' ***** anima��o de fim de jogo ******
              locate 43,1
              TMR = timer
              for VY = 1 to 80
                TECLA = ""
                for COUNT = 1 to 43*3
                  color rnd*15,rnd*15
                  print chr$(32+rnd*222);
                next COUNT
                print TECLA;
                while (timer-TMR)<1/30
                  sleep 1
                wend
                TMR += 1/18
              next VY
              ' ******* texto de fim de jogo *******
              color 14,1
              locate 20,33:print "               ";
              locate 21,33:print "  Fim de jogo  ";
              locate 22,33:print "               ";
              ' *** aguarda e termina ****
              while inkey$ <> ""
                sleep 15
              wend
              sleep 1000,1:sleep
              end
            end if
          end if
          NXM = timer 'reseta contador do inimigo (movimento)
        end if
      end if
      ' ***** verifica se tecla pressionada ******
      sleep 15
      TECLA = inkey$
    loop until TECLA <> ""
    ' **** verifica qual dire��o player seguiu *****
    select case TECLA
    case chr$(255)+"H" 'cima
      if MATRIX(STX,STY-1) <> 0 and STY>1 then VY=-1:DOMOV=1
    case chr$(255)+"P" 'baixo
      if MATRIX(STX,STY+1) <> 0 and STY<42 then VY=1:DOMOV=1
    case chr$(255)+"K" 'esquerda
      if MATRIX(STX-1,STY) <> 0 and STX>1 then VX=-1:DOMOV=1
    case chr$(255)+"M" 'direita
      if MATRIX(STX+1,STY) <> 0 and STX<80 then VX=1:DOMOV=1
    case chr$(27) 'ESC = fim de jogo
      end
    end select
    ' **** verifica se houve altera��o de posi��o ****
    if DOMOV then
      locate STY,STX
      print " ";
      STX+=VX:STY+=VY
      if PCMOV > 0 then
        if RECMOVS(PCMOV).X = STX and RECMOVS(PCMOV).Y = STY then
          PCMOV -= 1
        end if
      end if
      ' **** verifica se jogador j� esteve aki ****
      ' **** para o inimigo poder cortar caminho *****
      for COUNT = PCMOV+1 to MAXMOVS
        if RECMOVS(COUNT).X = STX and RECMOVS(COUNT).Y = STY then
          exit for
        end if
      next COUNT
      ' **** atualiza��o posi��o para inimigo ******
      MAXMOVS = COUNT
      RECMOVS(MAXMOVS).X = STX
      RECMOVS(MAXMOVS).Y = STY
    end if
    ' **** retorna at� que player venca (ou perca) ****
  loop until STX >= 80 or TECLA = chr$(233)
  ' ***** anima��o de vit�ria *******
  TMR = timer
  for COUNT = 1 to 3440
    VX = FRZ(COUNT).X
    VY = FRZ(COUNT).Y
    locate VY,VX
    print !" ";
    while (timer-TMR)< 1/2500
      sleep 1
    wend
    TMR += 1/2500
  next COUNT
  color 14,9:cls:color 14,4
  locate 20,32:print "                ";
  locate 21,32:print "  ! Parabens !  ";
  locate 22,32:print "                ";
  sleep 2000,1
  ' **** retorna at� que ele ganhe o jogo *****
next LVL
' **************************
' ********** FIM ***********
' **************************
sleep