; put data in RAM

ORG	 	0000H
MOV 	P3,#00000100B				; P3 = 0000 0000 CONFIGURA COMO SAIDA E P3.2 COMO ENTRADA



AJMP	INICIO

;------------------------------


;----------------------------------	
	INICIO:

	MOV P3,#0FFH

	MOV 30H, #'D'
	MOV 31H, #'I'
	MOV 32H, #'S'
	MOV 33H, #'T'
	MOV 34H, #'A'
	MOV 35H, #'N'
	MOV 36H, #'C'
	MOV 37H, #'I'
	MOV 38H, #'A'
	MOV 39H, #00111010B		;DOIS PONTOS ":"
	MOV 3AH, #'2'
	MOV 3BH, #0
	MOV 3CH, #0				; end of data marker

	;MOV 	IE,#10000001B		;HABILITA AS INTERRUPCÕES EXTERNAS "INT0"
	;MOV 	IP,#00000000B 		;DEFINE BAIXA PRIORIDADE
	;MOV 	TCON,#00000000B		;INTERRUPÇÃO SENSIVEL A BORDA DE DESCIDA 
;-------------------------------------	
	RS  EQU P2.5
	E   EQU P2.4
	DB7 EQU P2.3
	DB6 EQU P2.2
	DB5 EQU P2.1
	DB4 EQU P2.0

	TRIGGER	EQU	P3.0
	Eco		EQU	P3.2

;---------------------------------------

ACALL functionset
ACALL entrymodeset
ACALL displayonoffcontrol

	
;---------------------------------------
ESCRITA:

	SETB RS	
	MOV R1, #30H
;---------------------------------------
loop:
	MOV A, @R1		
	JZ  FINISHH
	CALL sendCharacter	
	INC R1			
	JMP loop	

;---------------------------------------------
FINISHH:
 mov a,#00110000B
finish:
	ACALL  CURSORDISPLAYSHIFT

	ACALL  TEMPODAONDA
	SETB   RS
	ADD	   A,#30H	
	ACALL  sendCharacter
	
	jmp    FINISH


;---------------começo subr0tinas----------------------

sendCharacter:

	MOV C, ACC.7		
	MOV DB7, C			
	MOV C, ACC.6		
	MOV DB6, C			
	MOV C, ACC.5		
	MOV DB5, C			
	MOV C, ACC.4		
	MOV DB4, C			

	SETB E			
	CLR E			

	MOV C, ACC.3		
	MOV DB7, C			
	MOV C, ACC.2		
	MOV DB6, C			
	MOV C, ACC.1	
	MOV DB5, C		
	MOV C, ACC.0	
	MOV DB4, C			

	SETB E		
	CLR E	
	CALL delay	

	RET
;----------------------------------------------

delay:
	MOV R0, #50
	DJNZ R0, $
	RET

;-----------------------------------------------------------------------------------------
functionset:	

	clr RS

	CLR  DB7		; |
	CLR  DB6		; |
	SETB DB5		; |
	CLR  DB4		; | high nibble set

	SETB E		    ; |
	CLR E		    ; | negative edge on E

	CALL delay			

	SETB E		    ; |
	CLR E		    ; | negative edge on E
					; same function set high nibble sent a second time

	SETB DB7		; low nibble set (only P1.7 needed to be changed)

	SETB E			; |
	CLR E			; | negative edge on E
					; function set low nibble sent
	CALL delay		; wait for BF to clear

RET
;-----------------------------------------------------------------------------------------------
entrymodeset:

; set to increment with shift

	CLR DB7		   ; |
	CLR DB6	       ; |
	CLR DB5		   ; |
	CLR DB4		   ; | high nibble set

	SETB E		   ; |
	CLR E		   ; | negative edge on E

	CLR  DB7	
	SETB DB6	   ; |
	SETB DB5	   ; |low nibble set
	clr  DB4

	SETB E		   ; |
	CLR E		   ; | negative edge on E

	CALL delay	   ; wait for BF to clear

RET
;----------------------------------------------------------------------------------------------------

displayonoffcontrol:

; the display is turned on, the cursor is turned on and blinking is turned on
	CLR DB7		; |
	CLR DB6		; |
	CLR DB5		; |
	CLR DB4		; | high nibble set

	SETB E			; |
	CLR E			; | negative edge on E

	SETB DB7		; |
	SETB DB6		; |
	SETB DB5		; |
	SETB DB4		; | low nibble set

	SETB E			; |
	CLR E			; | negative edge on E

	CALL delay		; wait for BF to clear

	RET

;-----------------------------------------------------------------------------------------------------
CURSORDISPLAYSHIFT:

	CLR RS
	CLR DB7
	CLR DB6
	CLR DB5
	SETB DB4 ;NIBLE SUPERIOR

	SETB E
	CLR E

	CLR RS
	CLR DB7
	CLR DB6
	CLR DB5
	CLR DB4

	SETB E
	CLR E

	CALL DELAY
	RET
;-------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------
TEMPODAONDA:



	CLR 	TRIGGER


	MOV 	TH0,#00000000B	;ZERA O CONTADOR ANTES DE MEDIR A DISTÂNCIA
	MOV 	TL0,#00000000B 	;ZERA O CONTADOR ANTES DE MEDIR A DISTÂNCIA

	CALL 	SETTG

	
	CALL	DISPARA_TIMER

	ESP2:
    JNB     ECO,ESP2	     		  ;ESPERA A BORDA DE DESCIDA DO ECO


	MOV 	A,TL0
	CALL	PARATIMER

	
			
	CLR 	C
	
	CALL 	DECREMENTA

	DEC 	B
	MOV 	A,B




	RET

;---------------------------------------------------------------------------------------------------

DISPARA_TIMER:
	
	MOV 	TCON,#10H	
	MOV 	TMOD,#01H
	RET

;-----------------------------------------------------------------------------------------------------

PARATIMER:
	MOV 	TCON,#00H
	RET
;-----------------------------------------------------------------------------------------------------

DELAY50uS:
	DELAY_50uS:
	PUSH	B
	MOV		B, #20
	DJNZ 	B, $
	POP 	B
	RET
;-----------------------------------------------------------------------------------------------------
delay1s:
	mov		R0,#0A0H
	mov		R1,#8H
	delay1000S:
	mov		b,#0FFH
	djnz	b,	$
	djnz	R0,delay1000S
	djnz	R1,delay1000S
	ret
;-----------------------------------------------------------------------------------------------------
DELAY60MS:

	mov		R0,#3BH
	

	delay1000:
	mov		b,#0FFH
	djnz	b,	$
	djnz	R0,delay1000

	ret
;-----------------------------------------------------------------------------------------------------
REPOSITOR:
DEC     TH0
MOV 	A,#0FFH
CLR 	C
JMP 	DECREMENTA

DECREMENTA:	

subtrair:
	SUBB	A,#03AH
	INC     B
	JNC		subtrair
	MOV 	A,TH0
 	CJNE	A,00H,REPOSITOR
	

	RET
;-----------------------------------------------------------------------------------------------------
SETTG:
	SETB	TRIGGER
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP 
	NOP
	NOP
	CLR     TRIGGER

	CALL	DELAY60MS

	RET
