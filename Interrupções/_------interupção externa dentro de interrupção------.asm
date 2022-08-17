;-----25/02/2020 Ações dentro de Interrupção ------

;--------vetor de reset---------
	org		000h
	jmp 	inicio

;-------vetor de interrupção(int0) ----- 
	org 	003h

	CALL	delay01s
	CALL	delay01s
	CALL	delay01s
	CALL	delay01s
	CALL	delay01s

	JNB		P3.7,interrup1	   ;se o botão for precionado ele vai para a Sub interrupção precionada
	JNB		P3.6,interrup2
	JNB		P3.5,interrup3			
		

	RETI

inicio:

	MOV 	P2,#000h 		;Define como saida o port p2 
	MOV     P2,#0ffh 		;Inicia-se desligado
	MOV 	P3,#0ffh 		;Define como entrada o port3
	MOV 	IE,#10000001B	;Habilita interupções e interrupçoe externa INT 0
	MOV 	IP,#00h 		;Define a sensiblidade da interrupção 
	MOV 	TCON,#00h		;SENSIVEL A BORDA 
	jmp		loop

loop:

	SETB 	P2.0		;INICIA-SE DESLIGADO
	CALL 	delay1s
	CLR		P2.0		;LIGA LED
	CALL 	delay1s

	JMP 	loop

interrup1:
	CLR  	P2.7		;Liga motor
	CALL 	delay1s
	CALL 	delay1s
	SETB 	P2.7		;desliga motor

	ret

interrup2:
	CLR 	P2.0		;INICIA-SE ligado
	CALL 	delay1s
	CALL 	delay1s
	CALL 	delay1s
	CALL 	delay1s
	CALL 	delay1s
	SETB	P2.0		;DESLIGA LED
	
	ret

interrup3:
	SETB  	P2.7
	SETB	P2.0
	CALL 	delay1s
	CLR 	P2.7
	CLR 	P2.0
	CALL 	delay1s
	CALL 	delay1s
	CALL 	delay1s
	CALL 	delay1s

	ret
	
delay1s:
	mov		R0,#0A0H
	mov		R1,#8H
	delay1000S:
	mov		b,#0FFH
	djnz	b,	$
	djnz	R0,delay1000S
	djnz	R1,delay1000S

	ret


delay01s:
 	
 	Mov 	R2,#64h

aux1:
	Mov 	R1,#0ffh
	Mov 	R0,#0ffh

	djnz 	R0,$ 
	djnz	R1,$
aux:
	djnz	R2,aux1

	ret

	

	END
