	scl	equ	P1.6
	sda	equ	P1.7
	
	org	0000h
	ajmp	inicio
	
Inicio:
	acall	LCD_init	
loop:
	mov	b,#10000010b
	call	position
	call	escrevetabela
auxloop:
	call	msgleft
	call	delay30ms
	jmp	auxloop

LCD_init:
		mov	R2,#03h		
LCDStartAux:
	acall	delay15ms	;Initializing display
	mov	acc,#00110000b   ;(D7,D6,D5,D4, ,E,Rw,Rs) define o que envia
	acall	sendLCD
	djnz	R2,LCDStartAux
	
	; Set interface to be 4 bits long
	mov	acc,#00100000b   ;(D7,D6,D5,D4, ,E,Rw,Rs) define o que envia
	acall	sendLCD

	mov	acc,#00101100b   ;(D7,D6,D5,D4, ,E,Rw,Rs) define o que envia
	acall	send_inst
	
	;Display on
	mov	acc,#00001111b   ;(D7,D6,D5,D4, ,E,Rw,Rs) define o que envia
	acall	send_inst

	;Display clear
	mov	acc,#00000001b   ;(D7,D6,D5,D4, ,E,Rw,Rs) define o que envia
	acall	send_inst

	;Entry mode set
	mov	acc,#00000010b   ;(D7,D6,D5,D4, ,E,Rw,Rs) define o que envia
	acall	send_inst	
	ret
;----------------------------------
SendLCD:
	mov	R3,#03h
SendLCDaux:
	acall	sendPCF
		rlc	a
		cpl	acc.2
		djnz	R3,SendLCDaux
		ret
;----------------------------------
send_data:
	push 	acc
	call	delay1ms
	call	delay1ms
	pop	acc
	mov	b,#00000001b
	rlc	a
	mov	b.7,c
	rlc	a
	mov	b.6,c
	rlc	a
	mov	b.5,c
	rlc	a
	mov	b.4,c
	push	acc
	acall	PreSend
	pop	acc
	rlc	a
	mov	b.7,c		;nao conectado
	rlc	a
	mov	b.6,c
	rlc	a
	mov	b.5,c
	rlc	a
	mov	b.4,c
	acall	PreSend
	ret
;----------------------------------
send_inst:
	push	acc
	call	delay1ms
	call	delay1ms
	pop	acc
	mov	b,#00000000b
	rlc	a
	mov	b.7,c
	rlc	a
	mov	b.6,c
	rlc	a
	mov	b.5,c
	rlc	a
	mov	b.4,c
	push	acc
	acall	PreSend
	pop	acc
	mov	b,#00000000b
	rlc	a
	mov	b.7,c		;nao conectado
	rlc	a
	mov	b.6,c
	rlc	a
	mov	b.5,c
	rlc	a
	mov	b.4,c
	acall	PreSend
	ret
PreSend:
	mov	acc,b
	call 	sendLCD
	ret
;----------------------------------
SendPCF:	
	push	acc		;sub-rotina de start do PCF
	mov	a,#01001110b	;(D7,D6,D5,D4, ,E,Rw,Rs)	endereço 27h do PCF e modo escrita
	setb	scl
	setb	sda
	acall	delay6us	;atraso de 6 us para t: SU;STA

	clr	sda
	acall	delay6us	;atraso de 6us para t: HD;STA
	mov	R0,#08h
SendPCFWrite:			;sub-rotina de escrever no PCF
	rlc	a		;desloca o bit mais sig. para a o carry
	clr	scl		;vou escrever
	mov	sda,C		;envia o bit
	acall	delay6us	;delay de 6us para t: LOW

	setb	scl		;lê o bit
	acall	delay6us	;delay de 6us para t: HIGH

	djnz	R0,SendPCFWrite
	pop	acc
	
	call	SendPCFAck
EnviaData:
	mov	R0,#08h
			 	;(D7,D6,D5,D4, ,E,Rw,Rs) dados a serem enviados
EnviaData2:			;sub-rotina de escrever no PCF
	rlc	a		;desloca o bit mais sig. para a o carry
	clr	scl		;vou escrever
	mov	sda,C		;envia o bit
	acall	delay6us	;delay de 6us para t: LOW
	setb	scl		;lê o bit
	acall	delay6us	;delay de 6us para t: HIGH
	djnz	R0,enviadata2
	call	SendPCFAck
StopBit:
	clr	scl		;vou escrever
	clr	sda
	acall	delay6us
		
	setb	scl
	acall	delay6us

	setb	sda
	ret

SendPCFAck:
	clr	scl		;vou escrever
	setb	sda
	acall	delay6us	;2 us

	setb	scl		;bit de acknowledge
	acall	delay6us
	ret

;---------------------------------
displayON:
	mov	acc,#0Fh		;0000 1111b	;displayonoff	;D=C=B= 1 (cursor, display e blinkCursor ativos)
	acall	send_inst
	RET
displayOFF:
	mov	acc,#04h		;0000 1000b	;displayonoff	;D=C=B= 1 (cursor, display e blinkCursor ativos)
	acall	send_inst
	RET
clear:
	mov	acc,#01h		;0000 0001b	;Clear		;Limpa todo o display e retorna o cursor para a primeira posição da primeira linha 
	acall	send_inst
	ret	
homeCursor:
	mov	acc,#02h 		;0000 001x  ; retornar o curso a linhaxcoluna - 1x1
	acall	send_inst
	ret
cursorLEFT:
	mov	acc,#10h		;Move o curso (C=0) para a esquerda(R=0)
	acall 	send_inst
	ret
cursorRIGHT:
	mov	acc,#14h		; Move o curso (C=0) para a direita(R=1)
	acall 	send_inst
	ret
espaco:
	mov	acc,#' '		; Move o curso (C=0) para a direita(R=1)
	acall 	send_data
	ret
SegundaLinha:
	mov	acc,#0C0h		;1AAA AAAA ; para mover para segunda linha colocamos o endereço em 40h ou seja a = C0h
	acall 	send_inst
	ret
msgLEFT:
	mov	acc,#18h		;Move o MENSSAGEM  E O CURSOR (C=1) para a ESQUERDA(R=0), isto é a messnagem é vista sendo deslocada da esquerda para a
	acall 	send_inst	;direita
	ret
msgRIGHT:
	mov	acc,#1Ch		;Move o MENSSAGEM E O CURSOR (C=1) para a DIREITA(R=1), isto é a messnagem é vista sendo deslocada da direita para a 	
	acall 	send_inst	;esquerda
	ret
;-----------------------------------	
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
;---------------------------------
Position:	
	;pega valor do registrador B (b.7 informa qual a linha e o restante a coluna)		
	push	acc
	mov	a,b
	jnb	acc.7,Line1
Line2:
	clr	acc.7
	add	a,#3fh		;soma o valor da coluna com o ultimo valor da linha 1
	setb	acc.7
	ajmp	column
Line1:
	subb	a,#00000001b
	setb	a.7
Column:
	acall	send_inst
	pop	acc
	ret
;-----------------------------------
Delay6us:			;2(acall) + 2(nop) + 2(ret)
	nop			;1 us
	nop			;1 us
	ret			;2 us
;------------------------------------
Delay30ms:			;30032 us
	mov	R7,#0FDh
Delay30msAux:			;30032 = 1+3*59+59*253*2
	mov	R6,#3Bh
	djnz	R6,$
	djnz	R7,Delay30msAux
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






