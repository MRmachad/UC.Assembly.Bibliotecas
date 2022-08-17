;LCD modo 8 bits, 2 linha - Matriz 7x5 e 8x5; vcc -> 5V
	LCD	equ	P1
	RS	equ	P3.7
	RW	equ	P3.6
	E	equ	P3.5
	org	0000h
	jmp	lcd_init
lcd_init:
	clr	RW
	clr	RS
	clr	E
	acall	delay15ms
	mov	a,#00110000b	;func
	acall	send_inst
	acall	delay15ms
	acall	send_inst
	acall	delay1ms
	acall	send_inst
	mov	a,#00111000b	;2 linha - Matriz 7x5
	acall	send_inst
	acall	busy_check
	
	mov	a,#00000110b	;entry mode set
	acall	Send_inst
	acall	busy_check

	mov	a,#00011111b	;display on	
	acall	Send_inst
	acall	busy_check

	mov	a,#00000001b	;display clear
	acall	Send_inst
	acall	busy_check
	ajmp	$
	
Send_Inst:
	mov	LCD,a
	setb	E
	nop
	clr	E
	ret
Busy_Check:
	mov	LCD,#0FFh
	clr	RS
	nop
	setb	RW
	nop
	setb 	E
	nop
	clr	E
	mov	a,LCD
	jb	acc.7,Busy_check
	clr	RW
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
	db 'LCD'
end