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
	call 		delay500ms


	clr 		E
	clr 		rs
	clr 		rw

	call 		delay55uc

	jmp			inicio

;-----------inicio rotinas---------------

inicio:

 	ACALL		functionSet
 	call 		delay500ms
 	ACALL		functionSet
 	call		delay500ms
 	call		functionSet
 	call		functionSet

 	ACALL 		DisplayOnOffControl
 	ACALL		displayClear
 	ACALL		EntryModeSet

 	jmp 		$


;----------Inicio subrotinas-------------

displayClear:
	
	setb 		e
	call 		delay55uc

	mov 		P2,#01h														;carrega 0000 0001 B em p2

	call 		delay55uc
	clr 		e
	call 		delay55uc

	ret

FunctionSet:																;define fonte a linha de operação e o bit de interface (Se define com 8 ou 4)


	clr RS

	CLR  D7		; |
	CLR  D6		; |
	SETB D5		; |
	CLR  D4		; | high nibble set

	SETB E		    ; |
	CLR E		    ; | negative edge on E

	CALL delay			

	SETB E		    ; |
	CLR E		    ; | negative edge on E
					; same function set high nibble sent a second time

	SETB D7		; low nibble set (only P1.7 needed to be changed)

	SETB E			; |
	CLR E			; | negative edge on E
					; function set low nibble sent
	CALL delay		; wait for BF to clear

RET

DisplayOnOffControl:

; the display is turned on, the cursor is turned on and blinking is turned on
	CLR D7		; |
	CLR D6		; |
	CLR D5		; |
	CLR D4		; | high nibble set

	SETB E			; |
	CLR E			; | negative edge on E

	SETB D7		; |
	SETB D6		; |
	SETB D5		; |
	SETB D4		; | low nibble set

	SETB E			; |
	CLR E			; | negative edge on E

	CALL delay		; wait for BF to clear

	RET

EntryModeSet:

; set to increment with shift

	CLR D7		   ; |
	CLR D6	       ; |
	CLR D5		   ; |
	CLR D4		   ; | high nibble set

	SETB E		   ; |
	CLR E		   ; | negative edge on E

	CLR  D7	
	SETB D6	   ; |
	SETB D5	   ; |low nibble set
	clr  D4

	SETB E		   ; |
	CLR E		   ; | negative edge on E

	CALL delay	   ; wait for BF to clear

RET
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

delay:
	MOV R0, #50
	DJNZ R0, $
	RET