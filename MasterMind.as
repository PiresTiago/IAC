;<<<<<<<<<<<<<<<<=>>>>>>>>>>>>>>>>>
;<<            IAC               >>
;<<     Projeto - Mastermind     >>   
;<<                              >>
;<<Joao Leal    89486            >>
;<<Tiago Pires  89544            >>
;<<<<<<<<<<<<<<<<=>>>>>>>>>>>>>>>>>
                                                                                                             

                                                                                                                                                                                                                                                                                                                                                                          
;::::::::::::::
;:: Codigos  ::
;::::::::::::::

; X = 3h
; O = 2h
; - = 1h


;======================================
;			INTERRUPCOES
;======================================
								ORIG	FE01h
INTR_1							WORD 	INT1 ;\
INTR_2							WORD 	INT2 ; \
INTR_3							WORD 	INT3 ;  \
											 ;   > Butoes 1 a 6 para o valor da jogada
INTR_4							WORD 	INT4 ;  /
INTR_5							WORD 	INT5 ; /
INTR_6							WORD 	INT6 ;/

								ORIG 	FE0Ah
INTR_A							WORD 	INTA ; ==> Botao A para iniciar a jogada

								ORIG 	FE0Fh
INT15							WORD	INTFF	;Temporizador




;======================================
;			   DISPLAYS
;======================================

DSP4 							EQU  	FFF0h
DSP3 							EQU 	FFF1h
DSP2 							EQU 	FFF2h
DSP1 							EQU 	FFF3h


;======================================
;			 	 LCD
;======================================
LCD_ESCREVE						EQU	FFF5h
LCD_CURSOR						EQU	FFF4h
;========================================
;				MASCARAS
;========================================
Mascara							EQU 1000000000010110b ; Mascara da Chave Aleatoria
INT_MASK_ADDR					EQU			  FFFAh ; _  
													  ; > Mascara das Interrupcoes
INT_MASK 						EQU	1000010001111110b; /


;=====================================
;	Valor inicial da pilha
;=====================================
SP_INICIO 						EQU		FDFFh


;=====================================
;	Temporizador
;=====================================
TEMP 							EQU		FFF6h
CTRL_TEMP						EQU		FFF7h
LEDS                            EQU     FFF8h 
;=============================================
;	Ferramentas para escrever na Janela Texto
;=============================================
INICIA_CURSOR					EQU		FFFFh
IO_CURSOR						EQU		FFFCh
IO_ESCREVE						EQU		FFFEh
EOT 	 						EQU 	'@'


;=====================================
;	Posicoes na Janela Texto
;=====================================
POSICAO_LCD1					EQU 	8001h
POSICAO_LCD2					EQU 	8015h
POSICAO_LCD3 					EQU 	8012h
POSICAO_NUM_TENTATIVA 			EQU 	0005h
POSICAO_CODIGO_JOGADOR			EQU  	0016h
POSICAO_RESULTADO				EQU		0023h
POSICAO_TITULO 					EQU		040Ah
POSICAO_PRIMA_PARA_COMECAR		EQU		0916h
POSICAO_VITORIA					EQU 	0738h
POSICAO_DERROTA					EQU 	0733h
POSICAO_PRIMA_PARA_RECOMECAR1 	EQU 	0933h
POSICAO_PRIMA_PARA_RECOMECAR2	EQU 	0A3Ah
POSICAO_COPYRIGHT				EQU		150Dh
POSICAO_TABELA					EQU 	0003h
POSICAO_APAGAR_JANELA 			EQU 	0000h	


;=====================================
;	STRINGS
;=====================================
					 			ORIG 	8000h
Frase_LCD1 			 			STR 	'MELHOR JOGADA:', EOT
Frase_LCD2 						STR 	'TENTATIVAS', EOT			 
Mastermind1			 			STR	'     __  ______   _________________  __  ________  _____', EOT
Mastermind2						STR	'    /  |/  / _ | / __/_  __/ __/ _ \/  |/  /  _/ |/ / _ \', EOT
Mastermind3			 			STR	'   / /|_/ / __ |_\ \  / / / _// , _/ /|_/ // //    / // /', EOT
Mastermind4			 			STR	'  /_/  /_/_/ |_/___/ /_/ /___/_/|_/_/  /_/___/_/|_/____/ ', EOT
COMECAR				 			STR	'Prima o interruptor IA para comecar', EOT
COPYRIGHT			 			STR	'<< TIAGO PIRES N89544 >>    |    << JOAO LEAL N89486 >>', EOT
FIM_DO_JOGO_MAU		 			STR 	'PERDESTE, TENTA OUTRA VEZ', EOT
FIM_DO_JOGO_BOM					STR 	'PARABENS, GANHASTE', EOT
TRY_AGAIN 			 			STR 	'Para comecar um novo jogo', EOT
TRY_AGAIN2 						STR 	'prima IA', EOT
ESTRUTURA_TABELA 				STR 	'|               |            |            |', EOT
TENTATIVA_1 					STR 	'Tentativa 1', EOT
TENTATIVA_2 					STR 	'Tentativa 2', EOT
TENTATIVA_3 					STR 	'Tentativa 3', EOT
TENTATIVA_4 					STR 	'Tentativa 4', EOT
TENTATIVA_5 		 			STR 	'Tentativa 5', EOT
TENTATIVA_6 					STR 	'Tentativa 6', EOT
TENTATIVA_7 					STR 	'Tentativa 7', EOT
TENTATIVA_8 					STR 	'Tentativa 8', EOT
TENTATIVA_9 					STR 	'Tentativa 9', EOT
TENTATIVA_10 					STR 	'Tentativa 10', EOT
TENTATIVA_11					STR 	'Tentativa 11', EOT
TENTATIVA_12					STR 	'Tentativa 12', EOT
		
;=====================================
;	WORDS
;=====================================
LED                  			WORD    FFFFh
MELHOR_JOGADA_LCD 	 			WORD 	 000Ch


                                                                                                                    
;###########################################################
;##INICIO 	INICIO 	INICIO 	INICIO 	INICIO 	INICIO 	INICIO #								
;##		INICIO  INICIO  INICIO	INICIO  INICIO  INICIO     #	 				
;##INICIO 	INICIO 	INICIO 	INICIO 	INICIO 	INICIO 	INICIO #	      												
;###########################################################      

					ORIG 	0000h
					MOV 	R7, SP_INICIO
					MOV		SP,R7
					MOV 	R6, INICIA_CURSOR
					MOV		M[IO_CURSOR],R6
					MOV 	R3, INT_MASK
					MOV 	M[INT_MASK_ADDR],R3
					JMP 	INICIO_JOGO

;###########################################
;#				 INTERRUPCOES              #
;###########################################

INT1: 				MOV 	R6, 0001h 		;Botao 1
					CALL 	ESCREVE_SEQ_JOG
					RTI

INT2:				MOV 	R6, 0002h   	;Botao 2
					CALL 	ESCREVE_SEQ_JOG
					RTI

INT3:				MOV 	R6, 0003h 		;Botao 3
					CALL 	ESCREVE_SEQ_JOG
					RTI

INT4:				MOV 	R6, 0004h  		;Botao 4
					CALL 	ESCREVE_SEQ_JOG
					RTI

INT5:				MOV 	R6, 0005h 		;Botao 5
					CALL 	ESCREVE_SEQ_JOG
					RTI

INT6:				MOV 	R6, 0006h 		;Botao 6
					CALL 	ESCREVE_SEQ_JOG
					RTI

INTA:				MOV 	R6, B00Bh    	;Botao A
					RTI

INTFF:              PUSH    R5              ;TEMPORIZADOR
                    PUSH    R2
                    MOV     R2, M[LED]
                    SHL     R2, 1
                    MOV     M[LED], R2
                    MOV     M[LEDS], R2
                    MOV     R5, 5
                    MOV     M[TEMP], R5
                    MOV     R5, 0001h
                    MOV     M[CTRL_TEMP], R5    
                    POP     R2
                    POP     R5
                    RTI


;###########################################################################################################################################################################################
;##																																														  ##
;##																							ROTINAS	    																				  ##
;##	      																																												  ##
;###########################################################################################################################################################################################


;##########################################
;				    LCD					  #
;##########################################

ESCREVE_JOGADA_LCD: MOV 	M[MELHOR_JOGADA_LCD],R4
					MOV 	R6, POSICAO_LCD3
					MOV 	M[LCD_CURSOR],R6
					INC 	R4
					ADD 	R4,48
					MOV 	M[LCD_ESCREVE],R4
					MOV 	R1,R4
					RET

ESCREVE_LCD: 	 	PUSH 	R2
					PUSH 	R3
					PUSH 	R6
					MOV 	R6,POSICAO_LCD1
					MOV 	M[LCD_CURSOR], R6
					MOV 	R2, Frase_LCD1
					CALL 	CICLO_ESCRITA_LCD
					MOV 	R6,POSICAO_LCD2
					MOV 	M[LCD_CURSOR], R6
					MOV 	R2, Frase_LCD2
					CALL 	CICLO_ESCRITA_LCD
					POP 	R6
					POP 	R3
					POP 	R2
					RET

CICLO_ESCRITA_LCD:	PUSH 	R6
ESCRITA_LCD_LOOP:	MOV     R3, M[R2]
	                CMP     R3, EOT
	                BR.Z    RETURN_ESCRITA_LCD
					MOV		M[LCD_ESCREVE],R3
					INC		R2
					INC     R6
					MOV		M[LCD_CURSOR],R6
	                BR      ESCRITA_LCD_LOOP
RETURN_ESCRITA_LCD:	POP 	R6
					RET




ESCREVE_SEQ_JOG:	PUSH 	R2
					AND 	R2, F000h
					CMP 	R2,R0
					POP 	R2
					BR.NZ	SEGUNDO_DIGITO
					ROR 	R6, 4
					ADD 	R2,R6
					MOV 	R6,0
					RET

SEGUNDO_DIGITO: 	PUSH 	R2
					AND 	R2,0F00h
					CMP 	R2,R0
					POP 	R2
					BR.NZ	TERCEIRO_DIGITO
					ROR 	R6,8
					ADD 	R2,R6
					MOV 	R6,0
					RET

TERCEIRO_DIGITO: 	PUSH 	R2
					AND 	R2,00F0h
					CMP 	R2,R0
					POP 	R2
					BR.NZ 	QUARTO_DIGITO
					ROL 	R6,4
					ADD 	R2,R6
					MOV 	R6,0
					RET

QUARTO_DIGITO: 		ADD 	R2,R6
					MOV 	R6,R2
					RET

;##########################################
;				   DISPLAYS				  #
;##########################################

APAGA_DISPLAYS: 	MOV 	M[DSP1], R0
					MOV 	M[DSP2], R0
					MOV 	M[DSP3], R0
					MOV 	M[DSP4], R0
					RET

CONTAGEM_JOGADAS:	INC 	R4
					PUSH 	R2
					PUSH 	R4
					MOV 	R2, 10
					DIV 	R4, R2
					MOV 	M[DSP4], R2
					MOV 	M[DSP3], R4
					POP 	R4
					POP 	R2
					CMP  	R4, 12			
					JMP.Z	DERROTA	   ;Apos 12 tentativas(jogadas) o jogo termina	
					RET		

;##########################################
;				CHAVE ALEATORIA 		  #
;##########################################

CHAVE_ALEATORIA:	MOV 	R3, 4
					MOV 	R5, 0
CICLO:            	PUSH	R1
GERADOR_ALEATORIO:  AND 	R1, 0001h
					CMP 	R0, R1
					POP 	R1
					BR.NZ 	ALTERNATIVA
					ROR 	R1, 4
					BR 		RESTO	
ALTERNATIVA:		XOR		R1, Mascara
					ROR 	R1, 4

RESTO:				MOV 	R2, 5
					PUSH 	R1
					AND 	R1, FFF0h
					MOV 	R4, R1
					POP 	R1
					AND 	R1, 000Fh
					DIV 	R1, R2
					INC 	R2
					ADD 	R4, R2
					MOV 	R1, R4
					ROR 	R1, 4
					INC 	R5
					CMP 	R3,R5
					BR.NZ 	RESTO
					RET

;##########################################
; TEMPORIZADOR/INSERIR SEQUENCIA JOGADOR  #
;##########################################

 INTRODUZIR_TENT:	MOV 	R6,5
 					PUSH    R5
                    MOV     R5, 5
                    MOV     M[TEMP], R5
                    MOV     R5, 1b
                    MOV     M[CTRL_TEMP], R5
                    ENI         
                    MOV     R5, FFFFh
                    MOV     M[LED], R5
                    MOV     M[LEDS], R5 
                    POP     R5               
INTRODUZIR_LOOP:    PUSH    R4
                    MOV     R4, M[LED]
                    CMP     R4, 0
                    POP     R4
                    BR.Z    FIM_DO_TEMPO
				 	CMP		R6, R2
					BR.NZ 	INTRODUZIR_LOOP
FIM_DO_TEMPO:		RET 	


;#####################################################
;CONTAGEM X: Rotina que compara os dígitos que estao #
;			 na mesma posicao entre a sequencia      #
;			 do jogador e a gerada aleatoriamente    # 
;#####################################################
COMPARACAO_X:		PUSH 	R1
					PUSH 	R2
					AND 	R1, 000Fh
					AND 	R2, 000Fh
					CMP 	R1, R2
					POP 	R2
					POP 	R1
					CALL.Z 	MOV_X
					RET
					

CONTAGEM_X:			CALL 	COMPARACAO_X
					ROR 	R1, 4
					ROR 	R2, 4
					CALL 	COMPARACAO_X
					ROR 	R1, 4
					ROR 	R2, 4
					CALL 	COMPARACAO_X
					ROR 	R1, 4
					ROR 	R2, 4
					CALL 	COMPARACAO_X
					ROR 	R1, 4
					ROR 	R2, 4
					RET
				
;*******************************************************
;*	IMPLEMENTACAO DOS X's: 					           *
;*		Sub-rotina que coloca em R3 os X's encontrados * 	
;*******************************************************				

MOV_X: 				PUSH 	R3
					AND 	R3, F000h
					CMP 	R3, R0
					POP 	R3
					BR.Z	MOV_X4
					PUSH 	R3
					AND 	R3, 0F00h
					CMP 	R3, R0
					POP 	R3
					BR.Z 	MOV_X3
					PUSH 	R3
					AND 	R3, 00F0h
					CMP 	R3, R0
					POP 	R3
					BR.Z 	MOV_X2
					PUSH 	R3
					AND 	R3, 000Fh
					CMP 	R3, R0
					POP 	R3
					BR.Z 	MOV_X1
					
MOV_X4:				ADD 	R3, 3000h
					CALL 	RM_X
					RET 	

MOV_X3:				ADD 	R3, 0300h
					CALL 	RM_X	
					RET


MOV_X2:				ADD 	R3, 0030h	
					CALL 	RM_X
					RET

MOV_X1:				ADD 	R3, 0003h	
					CALL 	RM_X
					RET

;************************************************************
;*	REMOCAO DOS PARES:						                *
;* 		Sub-rotina que remove os digitos iguais que estejam *
;*		nas mesmas posicoes das	duas sequencias             *    
;************************************************************	

RM_X:				AND 	R1, FFF0h
					AND 	R2, FFF0h
					RET

;################################################################
;#	CONTAGEM O: Rotina que compara os dígitos entre a sequencia #
;#				do jogador e a gerada aleatoriamente            #
;################################################################

COMPARACAO_O:		PUSH 	R1
					PUSH 	R2
					AND 	R2, 000Fh
					CMP 	R2, R0
					BR.Z 	RETORNO_ALTERNATIVO
					AND 	R1, 000Fh
					CMP 	R1, R2
					POP 	R2
					POP 	R1
					CALL.Z 	MOV_O
					RET
					
RETORNO_ALTERNATIVO: POP 	R1
					 POP 	R2
					 RET

CONTAGEM_O:			CALL 	COMPARACAO_O
					ROR 	R1, 4
					CALL 	COMPARACAO_O
					ROR 	R1, 4
					CALL 	COMPARACAO_O
					ROR 	R1, 4
					CALL 	COMPARACAO_O
					ROR 	R1, 4

					ROR 	R2, 4
					CALL 	COMPARACAO_O
					ROR 	R1, 4
					CALL 	COMPARACAO_O
					ROR 	R1, 4
					CALL 	COMPARACAO_O
					ROR 	R1, 4
					CALL 	COMPARACAO_O
					ROR 	R1, 4

					ROR 	R2, 4
					CALL 	COMPARACAO_O
					ROR 	R1, 4
					CALL 	COMPARACAO_O
					ROR 	R1, 4
					CALL 	COMPARACAO_O
					ROR 	R1, 4
					CALL 	COMPARACAO_O
					ROR 	R1, 4

					ROR 	R2, 4
					CALL 	COMPARACAO_O
					ROR 	R1, 4
					CALL 	COMPARACAO_O
					ROR 	R1, 4
					CALL 	COMPARACAO_O
					ROR 	R1, 4
					CALL 	COMPARACAO_O
					ROR 	R1, 4
					ROR 	R2, 4
					RET
					
;************************************************
;*	IMPLEMENTACAO DOS O's E REMOCAO DOS PARES:  *
;*		Sub-Rotina que coloca em R3 os O's      *
;*		encontrados e remove os digitos iguais  *
;*		nas duas sequencias                     *
;************************************************				

MOV_O: 				PUSH 	R3
					AND 	R3, F000h
					CMP 	R3,R0
					POP 	R3
					BR.Z	MOV_O4
					PUSH 	R3
					AND 	R3, 0F00h
					CMP 	R3,R0
					POP 	R3
					BR.Z 	MOV_O3
					PUSH 	R3
					AND 	R3, 00F0h
					CMP 	R3,R0
					POP 	R3
					BR.Z 	MOV_O2
					PUSH 	R3
					AND 	R3, 000Fh
					CMP 	R3,R0
					POP 	R3
					BR.Z 	MOV_O1

MOV_O4:				ADD 	R3,2000h
					SHR 	R1, 4
					ROL 	R1, 4
					SHR 	R2, 4
					ROL 	R2, 4
					RET 	

MOV_O3:				ADD 	R3,0200h
					SHR 	R1, 4
					ROL 	R1, 4
					SHR 	R2, 4
					ROL 	R2, 4
					RET


MOV_O2:				ADD 	R3,0020h
					SHR 	R1, 4
					ROL 	R1, 4
					SHR 	R2, 4
					ROL 	R2, 4	
					RET

MOV_O1:				ADD 	R3,0002h
					SHR 	R1, 4
					ROL 	R1, 4
					SHR 	R2, 4
					ROL 	R2, 4
					RET

;####################################################
;# CONTAGEM NULO: Rotina que verifica quais sao os  #
;#				  digitos que sobraram na sequencia #
;#				  gerada aleatoriamente			    #
;####################################################

VERIFICA_NULO: 		PUSH 	R1
					AND 	R1, 000Fh
					CMP 	R1, R0
					POP 	R1
					CALL.NZ MOV_NULO
					RET

CONTAGEM_NULO:		CALL 	VERIFICA_NULO
					ROR 	R1, 4
					CALL 	VERIFICA_NULO
					ROR 	R1, 4
					CALL 	VERIFICA_NULO
					ROR 	R1, 4
					CALL 	VERIFICA_NULO
					ROR 	R1, 4
					RET

;*******************************************************
;*	IMPLEMENTACAO DOS NULOS                            *
;*	   Sub-Rotina que coloca em R3 o numero de digitos *
;*	   que nao eram iguais nas duas sequencias         *
;*******************************************************			

MOV_NULO:			PUSH 	R3
					AND 	R3, F000h
					CMP 	R3, R0
					POP 	R3
					BR.Z	MOV_NULO1
					PUSH 	R3
					AND 	R3, 0F00h
					CMP 	R3, R0
					POP 	R3
					BR.Z 	MOV_NULO2
					PUSH 	R3
					AND 	R3, 00F0h
					CMP 	R3, R0
					POP 	R3
					BR.Z 	MOV_NULO3
					PUSH 	R3
					AND 	R3, 000Fh
					CMP 	R3, R0
					POP 	R3
					BR.Z 	MOV_NULO4
					
MOV_NULO1:			ADD 	R3, 1000h
					RET 	

MOV_NULO2:			ADD 	R3, 0100h	
					RET


MOV_NULO3:			ADD 	R3, 0010h	
					RET

MOV_NULO4:			ADD 	R3, 0001h	
					RET

;#####################################
;##			JANELA DE TEXTO 		##    										
;#####################################

CICLO_ESCRITA:		PUSH 	R6
CICLO_ESCRITA_LOOP:	MOV     R3, M[R2]
	                CMP     R3, EOT
	                BR.Z    RETURN_ESCRITA
					MOV	 	M[IO_ESCREVE],R3
					INC		R2
					INC     R6
					MOV	 	M[IO_CURSOR],R6
	                BR      CICLO_ESCRITA_LOOP
RETURN_ESCRITA:		POP 	R6
					RET

;****************************************************
;* MAIN MENU: Rotina que escreve na janela de texto *
;* 			  a pagina inicial do Programa 		    *
;****************************************************

MAIN_MENU:			PUSH 	R6
					PUSH	R2
MASTERMIND:			MOV		R6,POSICAO_TITULO			;escreve a string do Titulo do jogo
					MOV		M[IO_CURSOR],R6
					MOV		R2,Mastermind1
					CALL 	CICLO_ESCRITA
					ADD 	R6, 0100h			
					MOV		M[IO_CURSOR],R6
					MOV		R2,Mastermind2
					CALL 	CICLO_ESCRITA
					ADD 	R6, 0100h			
					MOV		M[IO_CURSOR],R6
					MOV		R2,Mastermind3
					CALL 	CICLO_ESCRITA	
					ADD 	R6, 0100h		
					MOV		M[IO_CURSOR],R6
					MOV		R2,Mastermind4
					CALL 	CICLO_ESCRITA

AUTORES:			MOV		R6,POSICAO_COPYRIGHT		;escreve a string 'Copyright'
					MOV		M[IO_CURSOR],R6
					MOV		R2,COPYRIGHT
					CALL 	CICLO_ESCRITA

PRIMA_COMECAR:		MOV		R6,POSICAO_PRIMA_PARA_COMECAR		;escreve a string de comecar
					MOV		M[IO_CURSOR],R6
					MOV		R2,COMECAR
					CALL 	CICLO_ESCRITA
					POP 	R2
					POP 	R6
					RET

;*************************************************************
;* ESTRUTURA TABELA: Rotina que escreve na janela de texto   *
;*                   a tabela e o numero total de tentativas *
;*                   que o jogador tem           			 *
;*************************************************************

NOVA_LINHA_TABELA: 	ADD		R6, 0200h
					MOV 	M[IO_CURSOR], R6
					RET


TABELA: 			PUSH 	R2
					PUSH 	R3
					PUSH 	R4
					PUSH 	R5
					PUSH 	R6
					MOV 	R4, 23
					MOV 	R6,POSICAO_TABELA
N_COLUNAS:			MOV 	M[IO_CURSOR], R6
					MOV 	R2, ESTRUTURA_TABELA
					CALL 	CICLO_ESCRITA
					INC 	R5
					ADD 	R6,0100h
					CMP  	R5,R4
					BR.NZ  	N_COLUNAS
					MOV 	R6,POSICAO_NUM_TENTATIVA
					MOV 	M[IO_CURSOR], R6

					MOV 	R2, TENTATIVA_1
					CALL	CICLO_ESCRITA
					CALL 	NOVA_LINHA_TABELA

					MOV 	R2, TENTATIVA_2
					CALL	CICLO_ESCRITA
					CALL 	NOVA_LINHA_TABELA

					MOV 	R2, TENTATIVA_3
					CALL	CICLO_ESCRITA
					CALL 	NOVA_LINHA_TABELA

					MOV 	R2, TENTATIVA_4
					CALL	CICLO_ESCRITA
					CALL 	NOVA_LINHA_TABELA

					MOV 	R2, TENTATIVA_5
					CALL	CICLO_ESCRITA
					CALL 	NOVA_LINHA_TABELA

					MOV 	R2, TENTATIVA_6
					CALL	CICLO_ESCRITA
					CALL 	NOVA_LINHA_TABELA

					MOV 	R2, TENTATIVA_7
					CALL	CICLO_ESCRITA
					CALL 	NOVA_LINHA_TABELA

					MOV 	R2, TENTATIVA_8
					CALL	CICLO_ESCRITA
					CALL 	NOVA_LINHA_TABELA

					MOV 	R2, TENTATIVA_9
					CALL	CICLO_ESCRITA
					CALL 	NOVA_LINHA_TABELA

					MOV 	R2, TENTATIVA_10
					CALL	CICLO_ESCRITA
					CALL 	NOVA_LINHA_TABELA

					MOV 	R2, TENTATIVA_11
					CALL	CICLO_ESCRITA
					CALL 	NOVA_LINHA_TABELA

					MOV 	R2, TENTATIVA_12
					CALL	CICLO_ESCRITA

					POP 	R6
					POP 	R5
					POP 	R4
					POP 	R3
					POP 	R2
					RET

;*************************************************************************
;* REPRESENTACAO SEQUENCIA INSERIDA PELO JOGADOR E O RESPETIVO RESULTADO *
;*************************************************************************

REPRES_RESULTADO:	CMP 	R4, 0
					CALL.Z 	POSICAO_RESULTADOS
					CMP 	R4, 0
					BR.Z 	RESULTADO__1
					ADD 	R5, 0200h
RESULTADO__1:		PUSH 	R5	
					ROL 	R3, 4
					CALL 	ESCREVE_RESULTADO
					ROL 	R3, 4
					CALL 	ESCREVE_RESULTADO
					ROL 	R3, 4
					CALL 	ESCREVE_RESULTADO
					ROL 	R3, 4
					CALL 	ESCREVE_RESULTADO
					POP 	R5
					RET

POSICAO_RESULTADOS: MOV 	R5,POSICAO_RESULTADO
					MOV		M[IO_CURSOR],R5
					RET

ESCREVE_RESULTADO: 	PUSH 	R3
					AND 	R3, 000Fh
					MOV		M[IO_CURSOR],R5
					CMP 	R3, 0003h
					CALL.Z 	ESCREVE_X
					CMP 	R3, 0002h
					CALL.Z 	ESCREVE_O
					CMP 	R3, 0001h
					CALL.Z 	ESCREVE_NULO
					POP 	R3
					ADD 	R5, 2
					MOV		M[IO_CURSOR],R5
					RET

ESCREVE_X:			MOV 	R6, 'X'
					MOV 	M[IO_ESCREVE], R6
					RET

ESCREVE_O:			MOV		R6, 'O'
					MOV 	M[IO_ESCREVE], R6
					RET

ESCREVE_NULO: 		MOV		R6, '-'
					MOV 	M[IO_ESCREVE], R6
					RET
;===============================================
REPRES_CODIGO_JOG:	CMP 	R4, 0
					CALL.Z 	POSICAO_CODIGOS
					CMP 	R4, 0
					BR.Z 	CODIGO__1
					ADD 	R7, 0200h 
CODIGO__1:			PUSH 	R7
					ROL 	R2, 4
					CALL 	ESCREVE_CODIGO
					ROL 	R2, 4
					CALL 	ESCREVE_CODIGO			
					ROL 	R2, 4
					CALL 	ESCREVE_CODIGO			
					ROL 	R2, 4
					CALL 	ESCREVE_CODIGO
					POP 	R7
					RET

POSICAO_CODIGOS: 	MOV 	R7,POSICAO_CODIGO_JOGADOR
					MOV		M[IO_CURSOR],R7
					RET

ESCREVE_CODIGO:  	PUSH 	R2
					AND 	R2, 000Fh
					ADD 	R2,48
					MOV		M[IO_CURSOR],R7
					MOV 	M[IO_ESCREVE], R2	
					POP 	R2
					ADD 	R7, 2
					MOV		M[IO_CURSOR],R7
					RET

;********************************************
;* DERROTA: Rotina que escreve na janela    *
;*			de texto que o jogador perdeu   *
;********************************************

ESCREVE_DERROTA:	PUSH 	R2
					PUSH 	R6
					MOV 	R6, POSICAO_DERROTA
					MOV 	M[IO_CURSOR], R6
					MOV 	R2, FIM_DO_JOGO_MAU
					CALL 	CICLO_ESCRITA
					CALL 	ESCREVE_RECOMECAR
					POP 	R6
					POP 	R2
					RET

;********************************************
;* VITORIA: Rotina que escreve na janela    *
;*			de texto que o jogador ganhou   *
;********************************************

ESCREVE_VITORIA:	PUSH 	R2
					PUSH 	R6
					MOV 	R6, POSICAO_VITORIA
					MOV 	M[IO_CURSOR], R6
					MOV 	R2, FIM_DO_JOGO_BOM
					CALL 	CICLO_ESCRITA
					CALL 	ESCREVE_RECOMECAR
					POP 	R6
					POP 	R2
					RET

;*************************************************
;* RECOMECAR JOGO:  Rotina que escreve na janela *
;*					de texto indicacoes para     *
;*					recomecar o jogo             *
;*************************************************

ESCREVE_RECOMECAR:	PUSH 	R2
					PUSH 	R6
					MOV 	R6,POSICAO_PRIMA_PARA_RECOMECAR1
					MOV 	M[IO_CURSOR], R6
					MOV 	R2, TRY_AGAIN
					CALL 	CICLO_ESCRITA
					MOV 	R6,POSICAO_PRIMA_PARA_RECOMECAR2
					MOV 	M[IO_CURSOR], R6
					MOV 	R2, TRY_AGAIN2
					CALL 	CICLO_ESCRITA
					PUSH    R5
                    MOV     R5, 0000h
                    MOV     M[LED], R5
                    MOV     M[LEDS], R5 
                    POP     R5
                    POP 	R6
                    POP 	R2 
					RET

;********************************************
;* APAGAR JANELA: Rotina que apaga a janela *
;*				  de texto toda			    *
;********************************************

APAGAR_JANELA: 		PUSH 	R2
					PUSH 	R4
					PUSH 	R6
					MOV 	R4, 1850h
					MOV 	R6, 0000h
					MOV		R2, ' '	

CICLO_APAGAR:		INC 	R6
					MOV		M[IO_CURSOR],R6
					MOV		M[IO_ESCREVE],R2
					CMP 	R6, R4
					BR.NZ	CICLO_APAGAR
					POP 	R6
					POP 	R4
					POP 	R2
					RET
			
;###########################################################################################################################################################################################
;##																																														  ##
;##																						INICIO DO JOGO    																				  ##
;##	      																																												  ##
;###########################################################################################################################################################################################


INICIO_JOGO:		CALL 	MAIN_MENU 
INICIO_NOVO_JOGO:	CALL 	APAGA_DISPLAYS
					MOV 	R1, 0     ;
					MOV 	R2, 0	  ;
					MOV 	R3, 0 	  ;Inicializacao da jogada com todos os registos a 0 
					MOV 	R4, 0     ;
					MOV 	R5, 0     ;
					MOV 	R6, 0     ;
					ENI
					PUSH 	R6
PRIMA_IA:			INC 	R1        ;Enquanto nao for premido o interruptor A o programa incrementa R1 (ponto de partida para gerar a chave aleatoria)
					CMP		R6, B00Bh ;Rotina que nao permite o programa avancar enquanto o interruptor A nao for pressionado
					BR.NZ 	PRIMA_IA
					POP 	R6
					DSI
					PUSH 	R2
					PUSH 	R3
					PUSH 	R4 
					PUSH 	R5
					CALL 	CHAVE_ALEATORIA ;Gerador da sequencia aleatoria e colocacao da mesma em R1
					POP 	R5
					POP 	R4
					POP 	R3
					POP 	R2
					CALL	APAGAR_JANELA
					CALL 	TABELA
					PUSH    R5
                    MOV     R5, FFFFh
                    MOV     M[LEDS], R5
                    POP     R5
INTRODUZIR_R2:		ENI
					PUSH 	R6
					CALL 	INTRODUZIR_TENT ;Rotina que nao permite o programa avancar enquanto o jogador nao introduzir a sua sequencia
					POP 	R6
					PUSH    R4
                    MOV     R4, M[LED]
                    CMP     R4, R0
                    POP     R4
                    JMP.Z   DERROTA
					DSI		                
					CMP		R2,R1            	
					JMP.Z 	VITORIA ;Caso a sequecia gerada aleatoriamente e a introduzida pelo jogador sejam iguais, o jogo segue um ramo 'a parte
					MOV 	R3, R0
					PUSH 	R1
					PUSH 	R2  			
					CALL 	ESCREVE_LCD 	
					CALL    CONTAGEM_X
					CALL 	CONTAGEM_O
					CALL 	CONTAGEM_NULO
					POP 	R2
					POP 	R1
					CALL 	REPRES_RESULTADO   ;Representacao do resultado da comparacao entre a sequencia secreta e a do jogador na janela de texto
					CALL 	REPRES_CODIGO_JOG  ;Representacao da sequencia inserida pelo jogador na janela de texto
					CALL 	CONTAGEM_JOGADAS   ;Contagem do numero de jogadas que o jogador efetua num jogo
					MOV 	R2, R0
					JMP 	INTRODUZIR_R2  ;Apos cada jogada, o jogo reinicia, partindo do ponto em que e' pedido a insercao de uma sequencia


;###########################################################################################################################################################################################
;##																																														  ##
;##																							FIM DO JOGO    																				  ##
;##	      																																												  ##
;###########################################################################################################################################################################################

DERROTA:			CALL 	ESCREVE_DERROTA
					JMP		INICIO_NOVO_JOGO

VITORIA:			MOV 	R3, 3333h
					CALL 	REPRES_RESULTADO
					CALL 	REPRES_CODIGO_JOG
					CALL	ESCREVE_VITORIA
					PUSH 	R5
					MOV 	R5, M[MELHOR_JOGADA_LCD]
					CMP 	R4, R5
					POP 	R5
					CALL.N 	ESCREVE_JOGADA_LCD
					JMP		INICIO_NOVO_JOGO
			
