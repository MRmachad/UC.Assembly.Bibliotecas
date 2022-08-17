;------------MINEMONICOS-----------------
		D0		EQU		P2.0
		D1		EQU		P2.1
		D2		EQU		P2.2
		D3		EQU		P2.3
		D4		EQU		P2.4
		D5		EQU		P2.5
		D6		EQU		P2.6
		D7		EQU		P2.7

		RS 		EQU 	P0.7
		RW		EQU		P0.6
		E 		EQU		P0.5


;------------lCD 16X2 -------------------

	org 		000h	

	call 		delay1MS
	call 		delay1MS
	call 		delay1MS
	call 		delay1MS

	clr 		E

	jmp			inicio

;-----------inicio rotinas---------------

inicio:

 	ACALL		functionSet
 	ACALL 		DisplayOnOffControl
 	ACALL		EntryModeSet

loop:
	
	mov 		a,#00110000B												;zero do lcd
	CALL		writer
	call 		delay500ms

	jmp 		loop

;----------Inicio subrotinas-------------

FunctionSet:																;define fonte a linha de operação e o bit de interface (Se define com 8 ou 4)


	CLR 		RS	
	CLR 		RW

	CLR			D7
	CLR			D6
	SETB		D5

	SETB		D4															; Configura pra 8 bit de entrada  
	setb		D3															; Seleciona a primeira linha
	CLR 		D2															; 5X8 dot character font

	SETB		E	
	CLR 		E

	CALL 		delayR

	ret

DisplayOnOffControl:


	CLR 		RS	
	CLR 		RW

	CLR			D7
	CLR			D6
	CLR			D5
	CLR			D4
	SETB 		D3

	SETB		D2															; Liga display 	
	SETB		D1															; Ativa cursor
	CLR			D0															; deliga blink

	SETB 		E
	CLR 		E


	CALL 		delayR

	ret

EntryModeSet:


	CLR 		RS	
	CLR 		RW

	CLR			D7
	CLR			D6
	CLR			D5
	CLR			D4
	CLR 		D3

	SETB		D2														
	SETB		D1															; Seta a direção do cursor 
	SETB		D0															; Especifica a mudança de display

	SETB 		E
	CLR 		E


	CALL 		delayR
	
	
	ret

;------------ESCRITA-----------

Writer:
	


	SETB  		RS	
	CLR 		RW	
																			;Nibble superior
	mov 		c,acc.7
	mov 		D7,c

	mov 		c,acc.6
	mov 		D6,c
                    
    mov 		c,acc.5
	mov 		D5,c                                              

	mov 		c,acc.4
	mov 		D4,c

																			;Nibble inferior 

	mov 		c,acc.3
	mov 		D3,c

	mov 		c,acc.2
	mov 		D2,c

	mov 		c,acc.1
	mov 		D1,c

	mov 		c,acc.0
	mov 		D0,c

	SETB 		E
	CLR 		E

	SETB 		RW

	CALL 		delayR

	ret

;--------------delays-----------------

delay1MS:	
		
	mov 	r0,#0ffh
	mov		r1,#0ffh

	djnz	r0,$
	djnz	r1,$

	ret

delayR:

	MOV R0, #50
	DJNZ R0, $

	RET

delay500ms:
	
	mov r2,#0ffh
	mov r3,#0ffh

aux2:
	djnz r2,aux1



aux4:
	djnz r1,aux3

	ret	

aux3:	
	mov r0,#0ffh
	mov r1,#0ffh

	djnz r1,$
	djnz r2,$

	jmp aux4

aux1:	
	mov r0,#0ffh
	mov r1,#0ffh

	djnz r1,$
	djnz r2,$

	jmp aux2