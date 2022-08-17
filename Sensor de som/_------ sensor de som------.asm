;------ sensor de som------

	org 	000h
	jmp 	inicio 

;----------inicio codigo---------

inicio:
	
	Mov 	P2,#0fh		;define nibble superior como saida e o inferior como entrada 0000 1111
	setb	P2.7		;inicia desligado
	jmp 	loop

loop:
	jnb		p2.0,acende

	jmp 	loop

acende:
	clr		p2.7
	call	delay1s
	call	delay1s
	setb	p2.7
	ret

delay1s:
	mov		R0,#0A0H
	mov		R1,#8H

	delay1000S:

	mov		b,#0FFH
	djnz	b,$
	djnz	R0,delay1000S
	djnz	R1,delay1000S
	ret

	end