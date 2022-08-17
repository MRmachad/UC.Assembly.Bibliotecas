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
		E 		EQU		P3.7


;------------lCD 16X2 -------------------


	org 		000h	

	mov 		p2,#000h															;define o port p2 como saída

	clr 		E
	clr 		rs
	clr 		rw

	mov 		r2,#10h
aux1:		
	call		delay1ms	
	djnz 		r2,aux1

	

	jmp			config

;-----------inicio rotinas---------------

config:

	call		functionset

	mov 		r2,#6h
aux2:		
	call		delay1ms	
	djnz 		r2,aux2

	call		functionset

	call		delay55uc
 	call 		delay55uc

	call		functionset


 	ACALL 		DisplayOnOffControl
 	ACALL		displayClear
 	ACALL		EntryModeSet

 	jmp 		$


;----------Inicio subrotinas-------------

displayClear:
	

	mov 		P2,#01h														;carrega 0000 0001 B em p2

	call 		delay55uc	
	SETB		E
	CLR 		E
	call 		delay55uc

	ret

FunctionSet:																;define fonte a linha de operação e o bit de interface (Se define com 8 ou 4)

	CLR			D7
	CLR			D6
	SETB		D5

	SETB		D4															; Configura pra 8 bit de entrada  
	setb		D3															; Seleciona a primeira linha
	CLR 		D2															; 5X8 dot character font

	call 		delay55uc	
	SETB		E
	CLR 		E
	call 		delay55uc


	ret

DisplayOnOffControl:

	
	CLR			D7
	CLR			D6
	CLR			D5
	CLR			D4
	SETB 		D3

	SETB		D2															; Liga display 	
	SETB		D1															; Ativa cursor
	SETB		D0															; deliga blink

	call 		delay55uc	
	SETB		E
	CLR 		E
	call 		delay55uc


	ret

EntryModeSet:

	
	CLR			D7
	CLR			D6
	CLR			D5
	CLR			D4
	CLR 		D3

	SETB		D2														
	SETB		D1															; Seta a direção do cursor 
	SETB		D0															; Especifica a mudança de display

	call 		delay55uc	
	SETB		E
	CLR 		E
	call 		delay55uc

	
	
	ret

;--------------delays-----------------

delay1MS:	
		
	mov 	r0,#0ffh
	mov		r1,#0ffh

	djnz	r0,$
	djnz	r1,$

	ret

delay55uc:

	MOV R0, #19																;25 em decimal
	DJNZ R0, $

	RET


	END 
