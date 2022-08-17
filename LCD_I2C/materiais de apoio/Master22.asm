scl	equ	P1.6
sda	equ	P1.7
	org	0000h
	ajmp	inicio
Inicio:
	acall	LCDStart		;Chama rotina de inicialização do display
	jmp	$

LCDStart:
	mov	R2,#03h		
LCDStartAux:
	acall	delay30ms	;Initializing display
	mov	R7,#00110000b   ;(D7,D6,D5,D4, ,E,Rw,Rs) define o que envia
	acall	sendLCD

	djnz	R2,LCDStartAux
	
	; Set interface to be 4 bits long
	mov	R7,#00100000b   ;(D7,D6,D5,D4, ,E,Rw,Rs) define o que envia
	acall	sendLCD


	mov	R7,#00100000b   ;(D7,D6,D5,D4, ,E,Rw,Rs) define o que envia
	acall	sendLCD


	;Specify number of display lines and character font
	mov	R7,#11000000b   ;(D7,D6,D5,D4, ,E,Rw,Rs) define o que envia
	acall	sendLCD


	;Display on
	mov	R7,#00000000b   ;(D7,D6,D5,D4, ,E,Rw,Rs) define o que envia
	acall	sendLCD


	mov	R7,#11110000b   ;(D7,D6,D5,D4, ,E,Rw,Rs) define o que envia
	acall	sendLCD

	
	;Display clear
	mov	R7,#00000000b   ;(D7,D6,D5,D4, ,E,Rw,Rs) define o que envia
	acall	sendLCD


	mov	R7,#00010000b   ;(D7,D6,D5,D4, ,E,Rw,Rs) define o que envia
	acall	sendLCD

	;Entry mode set
	mov	R7,#00000000b   ;(D7,D6,D5,D4, ,E,Rw,Rs) define o que envia
	acall	sendLCD


	mov	R7,#00100000b   ;(D7,D6,D5,D4, ,E,Rw,Rs) define o que envia
	acall	sendLCD

		
	ret
;-------------------------------------
SendLCD:
	mov	R3,#03h
SendLCDaux:
	acall	sendPCF
	rlc	a
	cpl	acc.2
	mov	R7,a
	djnz	R3,SendLCDaux
	ret
;----------------------------------------
SendPCF:			;sub-rotina de start do PCF
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
	
SendPCFAck:
	clr	scl		;vou escrever
	clr	sda
	acall	delay6us	;2 us

	setb	scl		;bit de acknowledge
	acall	delay6us

	mov	a,R7	 	
	mov	R0,#08h
EnviaData:				;sub-rotina de escrever no PCF
	rlc	a		;desloca o bit mais sig. para a o carry
	clr	scl		;vou escrever
	mov	sda,C		;envia o bit
	acall	delay6us	;delay de 6us para t: LOW

	setb	scl		;lê o bit
	acall	delay6us	;delay de 6us para t: HIGH

	djnz	R0,enviadata
SendPCFAck2:
	clr	scl		;vou escrever
	setb	sda		;acknowlegde não é enviado e o proximo bit é o de stop
	acall	delay6us

	setb	scl		
	acall	delay6us
StopBit:
	clr	scl		;vou escrever
	clr	sda
	acall	delay6us
		
	setb	scl
	acall	delay6us

	setb	sda
	ret
;----------------------------------------
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







