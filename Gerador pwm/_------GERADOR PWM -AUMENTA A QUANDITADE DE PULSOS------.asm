;GERADOR PWM -  AUMENTA A QUANDITADE DE PULSOS 

;---------------vetor de origem(reset)------------

	org 	0000h
	jmp		inicio

;------------------------------------------------

	ORG 	0003h

	INC 	R3

	RETI
;----------------------------------------

inicio:

	MOV 	A,#00h
	MOV		P0,A 			;CONFIGURA P0 COMO SAIDA 

	MOV 	IE,#10000001B	;HABILITA INTERRUPÇÕES
	MOV		IP,#00h         ;DEFINE PRIORIDADE BAIXA PARA O INT0
	MOV 	TCON,#00h 		;SENSIVEL A O NIVEL LOGICO 

	MOV 	P0,#10000000B	;

	MOV		R3,#00H
	INC 	R3

PULSOS:

	
	CLR		P0.7	;LIGA LED
	CALL 	DELAY
	SETB	P0.7

	CALL	DELAY01MS

	JMP 	PULSOS



DELAY:
	MOV		B,R3
	JMP 	aux1

aux2:
	MOV		R0,#0FFH
	DJNZ	R0,$
	JMP 	aux1

aux1:	
	DJNZ	B,aux2

	RET

DELAY01MS:

	MOV		R1,#64H

esp:
	MOV 	R0,#0FFH
 	DJNZ	R0,$
 	DJNZ	R1,esp

RET
