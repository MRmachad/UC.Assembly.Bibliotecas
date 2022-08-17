;-----21/02/2020 teste gravador------

;--------vetor de reset---------


inicio:

	MOV 	P2,#000h 	;Define como saida o port p2
	jmp		loop

loop:

	SETB 	P2.0		;INICIA-SE DESLIGADO
	CALL 	delay1s
	CLR		P2.0		;LIGA LED
	CALL 	delay1s

	JMP 	loop


delay1s:
	mov		R0,#0A0H
	mov		R1,#8H

	delay1000S:

	mov		b,#0FFH
	djnz	b,$
	djnz	R0,delay1000S
	djnz	R1,delay1000S
	ret



	END