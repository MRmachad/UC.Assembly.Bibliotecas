scl	equ	P1.6
sda	equ	P1.7
	org	0000h
	ajmp	inicio
Inicio:
	acall	LCDStart		;Chama rotina de inicialização do display
;	mov	R5,#0Fh			;Quantidade de dados a serem enviados para o display
loop:
	;busca o valor a ser enviado e envia	
	mov	a,#00h
	movc	a,@a+dptr		;busca o valor a ser enviado para o lcd
	clr	acc.2			;limpa o enable
	clr	acc.1			;limpa rw
	setb	acc.0			;seta rs

	mov	R7,a			;move para o registrador auxiliar
	acall	sendPCF			;envia o valor para o lcd
	mov	a,R7
	setb	acc.2			;seta o enable
	mov	R7,a
	acall	sendpcf
	mov	a,R7
	clr	acc.2			;limpa o enable
	mov	R7,a
	acall	sendpcf

	acall 	delay30ms

	
	mov	a,#00h
	movc	a,@a+dptr		;busca o valor a ser enviado para o lcd
	rlc	a			;inverte os nibbles
	rlc	a
	rlc	a
	rlc	a
	clr	acc.2
	clr	acc.1
	setb	acc.0

	mov	R7,a			;move para o registrador auxiliar
	acall	sendPCF			;envia o valor para o lcd
	mov	a,R7
	setb	acc.2
	mov	R7,a
	acall	sendpcf
	mov	a,R7
	clr	acc.2
	mov	R7,a
	acall	sendpcf
	
;	INC	Dptr			;aponta para o proximo valor a ser enviado
;	djnz	R5,loop			;verifica se tudo ja foi enviado
	jmp	$

LCDStart:
	mov	R3,#03h		
LCDStartAux:
	acall	delay30ms	;Initializing display
	mov	a,#'A'
	acall	SwapBits
	mov	R7,#00110000b   ;(D7,D6,D5,D4, ,E,Rw,Rs) define o que envia
	acall	sendPCF
	mov	R7,#00110100b   ;(D7,D6,D5,D4, ,E,Rw,Rs) ativa o enable e envia o dado
	acall	sendPCF
	mov	R7,#00110000b   ;(D7,D6,D5,D4, ,E,Rw,Rs) desabilita o enable e completa o envio
	acall	sendPCF
	djnz	R3,LCDStartAux
	
	; Set interface to be 4 bits long
	mov	R7,#00100000b   ;(D7,D6,D5,D4, ,E,Rw,Rs) define o que envia
	acall	sendPCF
	mov	R7,#00100100b   ;(D7,D6,D5,D4, ,E,Rw,Rs) ativa o enable e envia o dado
	acall	sendPCF
	mov	R7,#00100000b   ;(D7,D6,D5,D4, ,E,Rw,Rs) desabilita o enable e completa o envio
	acall	sendPCF

	mov	R7,#00100000b   ;(D7,D6,D5,D4, ,E,Rw,Rs) define o que envia
	acall	sendPCF
	mov	R7,#00100100b   ;(D7,D6,D5,D4, ,E,Rw,Rs) ativa o enable e envia o dado
	acall	sendPCF
	mov	R7,#00100000b   ;(D7,D6,D5,D4, ,E,Rw,Rs) desabilita o enable e completa o envio
	acall	sendPCF

	;Specify number of display lines and character font
	mov	R7,#11000000b   ;(D7,D6,D5,D4, ,E,Rw,Rs) define o que envia
	acall	sendPCF
	mov	R7,#11000100b   ;(D7,D6,D5,D4, ,E,Rw,Rs) ativa o enable e envia o dado
	acall	sendPCF
	mov	R7,#11000000b   ;(D7,D6,D5,D4, ,E,Rw,Rs) desabilita o enable e completa o envio
	acall	sendPCF

	;Display on
	mov	R7,#00000000b   ;(D7,D6,D5,D4, ,E,Rw,Rs) define o que envia
	acall	sendPCF
	mov	R7,#00000100b   ;(D7,D6,D5,D4, ,E,Rw,Rs) ativa o enable e envia o dado
	acall	sendPCF
	mov	R7,#00000000b   ;(D7,D6,D5,D4, ,E,Rw,Rs) desabilita o enable e completa o envio
	acall	sendPCF

	mov	R7,#11110000b   ;(D7,D6,D5,D4, ,E,Rw,Rs) define o que envia
	acall	sendPCF
	mov	R7,#11110100b   ;(D7,D6,D5,D4, ,E,Rw,Rs) ativa o enable e envia o dado
	acall	sendPCF
	mov	R7,#11110000b   ;(D7,D6,D5,D4, ,E,Rw,Rs) desabilita o enable e completa o envio
	acall	sendPCF
	
	;Display clear
	mov	R7,#00000000b   ;(D7,D6,D5,D4, ,E,Rw,Rs) define o que envia
	acall	sendPCF
	mov	R7,#00000100b   ;(D7,D6,D5,D4, ,E,Rw,Rs) ativa o enable e envia o dado
	acall	sendPCF
	mov	R7,#00000000b   ;(D7,D6,D5,D4, ,E,Rw,Rs) desabilita o enable e completa o envio
	acall	sendPCF

	mov	R7,#00010000b   ;(D7,D6,D5,D4, ,E,Rw,Rs) define o que envia
	acall	sendPCF
	mov	R7,#00010100b   ;(D7,D6,D5,D4, ,E,Rw,Rs) ativa o enable e envia o dado
	acall	sendPCF
	mov	R7,#00010000b   ;(D7,D6,D5,D4, ,E,Rw,Rs) desabilita o enable e completa o envio
	acall	sendPCF

	;Entry mode set
	mov	R7,#00000000b   ;(D7,D6,D5,D4, ,E,Rw,Rs) define o que envia
	acall	sendPCF
	mov	R7,#00000100b   ;(D7,D6,D5,D4, ,E,Rw,Rs) ativa o enable e envia o dado
	acall	sendPCF
	mov	R7,#00000000b   ;(D7,D6,D5,D4, ,E,Rw,Rs) desabilita o enable e completa o envio
	acall	sendPCF

	mov	R7,#00100000b   ;(D7,D6,D5,D4, ,E,Rw,Rs) define o que envia
	acall	sendPCF
	mov	R7,#00100100b   ;(D7,D6,D5,D4, ,E,Rw,Rs) ativa o enable e envia o dado
	acall	sendPCF
	mov	R7,#00100000b   ;(D7,D6,D5,D4, ,E,Rw,Rs) desabilita o enable e completa o envio
	acall	sendPCF
		
	ret
;----------------------------------
SwapBitsInst:
	mov	b,#00000000b
	rlc	a
	mov	b.7,c
	rlc	a
	mov	b.6,c
	rlc	a
	mov	b.5,c
	rlc	a
	mov	b.4,c
	acall	SendI2C
	rlc	a
	mov	b.7,c		;nao conectado
	rlc	a
	mov	b.6,c
	rlc	a
	mov	b.5,c
	rlc	a
	mov	b.4,c
	acall	SendI2c
	ret
;----------------------------------
StartPCF:			
	setb	scl
	setb	sda
	acall	delay6us	;atraso de 6 us para t: SU;STA

	clr	sda
	acall	delay6us	;atraso de 6us para t: HD;STA
	ret
;----------------------------------
SendI2C:
	push	a
	mov	a,b
	acall	SendPCF
	acall	SendPCFAck
	pop	a
	ret
trocaDeAddress:	
	call	sendPCFACK2
	acall	stopbit
	acall	sendi2c
	ret
;---------------------------------
SendStopI2C:
	acall	SendPCF
	acall	SendPCFAck2
	acall	StopBit
	ret
;---------------------------------
SendPCF:			;sub-rotina de start do PCF
	mov	R2,#08h
	mov	R3,#03h
SendPCFWrite:			;sub-rotina de escrever no PCF
	rlc	a		;desloca o bit mais sig. para a o carry
	clr	scl		;vou escrever
	mov	sda,C		;envia o bit
	acall	delay6us	;delay de 6us para t: LOW

	setb	scl		;lê o bit
	acall	delay6us	;delay de 6us para t: HIGH

	djnz	R2,SendPCFWrite
	
	rlc	a
	cpl	acc.2
	djnz	R3,SendPcfWrite
	ret
;--------------------------------------------------	
SendPCFAck:
	clr	scl		;vou escrever
	clr	sda
	acall	delay6us	;2 us

	setb	scl		;bit de acknowledge
	acall	delay6us
	ret
;---------------------------------
SendPCFAck2:
	clr	scl		;vou escrever
	setb	sda		;acknowlegde não é enviado e o proximo bit é o de stop
	acall	delay6us

	setb	scl		
	acall	delay6us
	ret
;---------------------------------
StopBit:
	clr	scl		;vou escrever
	clr	sda
	acall	delay6us
		
	setb	scl
	acall	delay6us

	setb	sda
	ret
;-----------------------------------
Delay6us:			;2(acall) + 2(nop) + 2(ret)
	nop			;1 us
	nop			;1 us
	ret			;2 us

Delay30ms:			;30032 us
	mov	R7,#0FDh
Delay30msAux:			;30032 = 1+3*59+59*253*2
	mov	R6,#3Bh
	djnz	R6,$
	djnz	R7,Delay30msAux
	ret
	
end






