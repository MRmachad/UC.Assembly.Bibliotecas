;TESTE 90 graos negativoSERVO
	org 	000h
	jmp 	inicio 
;---------------------
inicio:
	clr	p2.0
	mov	r6,#13h
	
noventa:
	
	mov 	b,r6
	setb	p2.0				;inicia pulso em "1"	
 	mov	r5,#0f9h
 	djnz	r5,$
 	
 	clr	P2.0			; complemento do tempo menos 1
aux2: 
	call    delay1Ms
	djnz	b,aux2
	mov	r5,#0f9h
 	djnz	r5,$
	JMP 	noventa

delay1Ms:						;1MS= 1000uc
	
	Mov 	R0,#0f8h			;1000uc totais de ciclos de maquina 
	Mov 	R1,#0f8h
	djnz	R0,$	
	djnz	R1,$
	ret

	end
