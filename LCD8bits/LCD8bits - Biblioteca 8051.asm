;LCD modo 8 bits, 2 linha - Matriz 7x5 e 8x5; vcc -> 5V
	LCD	equ	P1
	RS	equ	P3.7
	RW	equ	P3.6
	E	equ	P3.5
	
	org	0000h
	acall	lcd_init
	jmp 	loop

loop:
	ACALL ESCREVETABELA
auxloop:
	ACALL	msgRIGHT
	ACALL   DELAY15MS
	ACALL	DELAY15MS
	ACALL   DELAY15MS
	ACALL	DELAY15MS
	ACALL   DELAY15MS
	ACALL	DELAY15MS
	ACALL   DELAY15MS
	ACALL	DELAY15MS
	ACALL   DELAY15MS
	ACALL	DELAY15MS
	ACALL   DELAY15MS
	ACALL	DELAY15MS
	jmp 	auxloop
	
;----------------------OPERAÇÕES-------------------
lcd_init:
	CLR	E
	mov	a,#38h		;0011 1000b	;func set  ;Modo de utilização do display
	acall	send_inst
	acall	delay15ms
	
	acall	send_inst	;0011 1000b	;func set  ;Modo de utilização do display
	acall	delay15ms
	
	mov	a,#06h		;0000 0110b	;entrymode ;Estabelece o sentido de deslocamento do cursor X=1 (dir) S =0 não desloca msg
	acall	SEND_INST

	CALL	displayON
	call	clear
	
	acall	busy_check
	RET
	
displayON:
	acall	busy_check
	mov	a,#0Fh		;0000 1111b	;displayonoff	;D=C=B= 1 (cursor, display e blinkCursor ativos)
	acall	SEND_INST
	RET
displayOFF:
	acall	busy_check
	mov	a,#04h		;0000 1000b	;displayonoff	;D=C=B= 1 (cursor, display e blinkCursor ativos)
	acall	SEND_INST
	RET
clear:
	acall	busy_check
	mov	a,#01h		;0000 0001b	;Clear		;Limpa todo o display e retorna o cursor para a primeira posição da primeira linha 
	acall	SEND_INST
	ret	
homeCursor:
	acall	busy_check 
	mov	a,#02h 		;0000 001x  ; retornar o curso a linhaxcoluna - 1x1
	acall	send_inst
	ret
cursorLEFT:
	acall	busy_check
	mov	a,#10h		;Move o curso (C=0) para a esquerda(R=0)
	acall 	send_inst
	ret
cursorRIGHT:
	acall	busy_check
	mov	a,#14h		; Move o curso (C=0) para a direita(R=1)
	acall 	send_inst
	ret
espaco:
	acall	busy_check
	mov	a,#' '		; Move o curso (C=0) para a direita(R=1)
	acall 	send_Data
	ret
SegundaLinha:
	acall	busy_check
	mov	a,#0C0h		;1AAA AAAA ; para mover para segunda linha colocamos o endereço em 40h ou seja a = C0h
	acall 	send_inst
	ret
msgLEFT:
	acall	busy_check
	mov	a,#18h		;Move o MENSSAGEM  E O CURSOR (C=1) para a ESQUERDA(R=0), isto é a messnagem é vista sendo deslocada da esquerda para a
	acall 	send_inst	;direita
	ret
msgRIGHT:
	acall	busy_check
	mov	a,#1Ch		;Move o MENSSAGEM E O CURSOR (C=1) para a DIREITA(R=1), isto é a messnagem é vista sendo deslocada da direita para a 	
	acall 	send_inst	;esquerda
	ret
	
escreveTabela:
	PUSH	ACC
	mov 	dptr,#WORDS
auxt:
	acall	busy_check
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
	call	busy_check
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
	clr	RW
	setb	RS
	mov	LCD,a
	setb	E
	nop
	clr	E
	ret
Send_Inst:
	clr	RW
	clr	RS
	mov	LCD,a
	setb	E
	nop
	clr	E
	ret
Busy_Check:
	mov	LCD,#0FFh
	setb	RW
	clr	RS
	setb	E
	nop
	mov	a,LCD
	clr	E
	jb	acc.7,Busy_check
	
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
