;LCD modo 8 bits, 2 linha - Matriz 7x5 e 8x5; vcc -> 5V
	D7	equ	p1.7
	D6	equ	p1.6
	D5	equ	p1.5
	D4	equ	p1.4
	RS	equ	P1.3
	RW	equ	P1.2
	E	equ	P1.1
	
	org	0000h
	mov	P1,#00h
	acall	lcd_init
	jmp 	loop

loop:
	mov 	B,#10000011B
	call	position
	MOV	A,#'a'
	call	send_data


	jmp 	$
	
;----------------------OPERAÇÕES-------------------
lcd_init:
	acall	delay15ms
	acall	delay15ms
	setb	D4	
	setb	D5
	clr	D6
	clr	D7	;0011
	setb	E
	nop	

	clr	E

	acall	delay15ms
	setb	D4	
	setb	D5
	clr	D6
	clr	D7	;0011
	setb	E
	nop	

	clr	E

	acall	delay15ms
	setb	D4	
	setb	D5
	clr	D6
	clr	D7	;0011
	setb	E
	nop	

	clr	E

	acall	delay15ms
	clr	D4	
	setb	D5
	clr	D6
	clr	D7	;0010
	setb	E
	nop	

	clr	E
	;----------------------
	
	mov	a,#28h			;funcion					
	acall	Send_Inst

	mov	a,#06h			;entrymode
	acall	Send_inst

	acall	DisplayON

	acall	clear
		
	RET
	
displayON:
	mov	a,#0Fh		;0000 1111b	;displayonoff	;D=C=B= 1 (cursor, display e blinkCursor ativos)
	acall	SEND_INST
	RET
displayOFF:
	mov	a,#08h		;0000 1000b	;displayonoff	;D=C=B= 1 (cursor, display e blinkCursor ativos)
	acall	SEND_INST
	RET
clear:
	mov	a,#01h		;0000 0001b	;Clear		;Limpa todo o display e retorna o cursor para a primeira posição da primeira linha 
	acall	SEND_INST
	ret	
homeCursor:
	mov	a,#02h 		;0000 001x  ; retornar o curso a linhaxcoluna - 1x1
	acall	send_inst
	ret
cursorLEFT:
	mov	a,#10h		;Move o curso (C=0) para a esquerda(R=0)
	acall 	send_inst
	ret
cursorRIGHT:
	mov	a,#14h		; Move o curso (C=0) para a direita(R=1)
	acall 	send_inst
	ret
espaco:
	mov	a,#' '		; Move o curso (C=0) para a direita(R=1)
	acall 	send_Data
	ret
SegundaLinha:
	mov	a,#0C0h		;1AAA AAAA ; para mover para segunda linha colocamos o endereço em 40h ou seja a = C0h
	acall 	send_inst
	ret
msgLEFT:
	mov	a,#18h		;Move o MENSSAGEM  E O CURSOR (C=1) para a ESQUERDA(R=0), isto é a messnagem é vista sendo deslocada da esquerda para a
	acall 	send_inst	;direita
	ret
msgRIGHT:
	mov	a,#1Ch		;Move o MENSSAGEM E O CURSOR (C=1) para a DIREITA(R=1), isto é a messnagem é vista sendo deslocada da direita para a 	
	acall 	send_inst	;esquerda
	ret
	
escreveTabela:
	PUSH	ACC
	mov 	dptr,#WORDS
auxt:
	MOV	A,#00H
	MOVC	A,@A+dptr
	Cjne	A,#00h,envia
	jmp 	fim
envia:
	acall	send_data
	inc	dptr
	MOV	A,#00H
	jmp	auxt
fim:	
	pop	ACC
	ret
	
Position:	
	;pega valor do registrador B (b.7 informa qual a linha e o restante a coluna)		
	push	acc
	mov	a,b
	jnb	a.7,Line1
Line2:
	clr	acc.7
	add	a,#3fh		;soma o valor da coluna com o ultimo valor da linha 1
	setb	acc.7
	ajmp	column
Line1:
	subb	a,#00000001b
	setb	a.7
Column:
	acall	Send_Inst
	pop	acc
	ret
Send_Data:
	PUSH	ACC
	CALL	busy_check
	POP	ACC
	clr	RW
	setb	RS
	call	swapBitsEnvio
	ret
Send_Inst:
	PUSH	ACC
	CALL	busy_check
	POP	ACC
	clr	RW
	clr	RS
	call	swapBitsEnvio
	ret
Busy_Check:
	setb	RW
	clr	RS
	acall	aux
	RLC	A
	MOV	B.7,c
	RLC	A
	MOV	B.6,c
	RLC	A
	MOV	B.5,c
	RLC	A
	MOV	B.4,c
	acall	aux
	RLC	A
	MOV	B.3,c
	RLC	A
	MOV	B.2,c
	RLC	A
	MOV	B.1,c
	RLC	A
	MOV	B.0,c
	MOV 	A,B
	jb	ACC.7,Busy_Check	
	RET
aux:
	setb	D7
	setb	D6
	setb	D5
	setb	D4
	setb	E
	nop
	mov	A,P1
	clr	E	
	ret
swapBitsEnvio:
	CALL	AUXSWAP
	CALL	AUXSWAP	
	RET
AUXSWAP:
	RLC  A
	mov D7,C
	RLC  A
	mov D6,C
	RLC  A
	mov D5,C
	RLC  A
	mov D4,C
	setb	E
	nop
	clr	E
	ret


;-----------------------------------------------
delay1ms:		;2
	mov	a,#0F8h	;1
	djnz	acc,$	;248*2
	mov	a,#0F9h ;1
	djnz	acc,$	;249*2	
	ret		;2
			;1000 us = 1 ms
;-----------------------------------------------
delay15ms:		;2
	acall	delay1ms
	acall	delay1ms
	acall	delay1ms
	acall	delay1ms
	acall	delay1ms
	acall	delay1ms
	acall	delay1ms
	acall	delay1ms
	acall	delay1ms
	acall	delay1ms
	acall	delay1ms
	acall	delay1ms
	acall	delay1ms
	acall	delay1ms
	acall	delay1ms
	ret
;-----------------------------------------------
	;Dados memória de programa
WORDS:
	db 'QUEM EH LEONARDO ?',00H
end

