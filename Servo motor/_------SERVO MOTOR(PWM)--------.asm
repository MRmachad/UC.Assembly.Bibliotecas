;------SERVO MOTOR(PWM)--------

	Pulso 	equ		p2.0		;saida para o pulso 
	BT1 	equ	 	p2.7		;Botões para acionamento 
	BT2		equ		p2.6		; /
	BT3		equ	 	p2.5		; /

;-----------Reset-----------

	org 	000h

	jmp 	inicio

inicio:
	mov 	P2,#0f0h 			;define o nibble superior como entrada e o nibble inferior como saida de dados

	jmp 	loop

loop:
	
	JNB 	BT1,noventa			;aguarda o bota ser selecionado, ou seja mandar zero para o pino
	JNB 	BT2,centoe80
	JNB 	BT3,zero

	jmp 	loop

;--------rotinas pwm ----------- (pulso de 50Hz confome o controle do servo controle do servo)

noventa:
	
	mov 	R2,#02h				;tempo de Ms (IMPORTANTE :O comando djnz decrementa e depois faz o teste, então se coloca o numero de vezes de ciclo mais 1)  
	setb	p2.0				;inicia pulso em "1"	
aux:
	call	delay1Ms
	djnz	R2,aux 
 	
 	clr		P2.0
	mov 	R2,#12h				; complemento do tempo menos 1
aux2: 
	call    delay1Ms
	djnz	R2,aux2

	JNB 	BT2,centoe80
	JNB 	BT3,zero

	JMP 	noventa


centoe80:

	
	setb	p2.0				;inicia pulso em "1"	
	call	delay1Ms 
 	
 	clr		P2.0
	mov 	R2,#13h				; complemento do tempo menos 1

aux3: 
	call    delay1Ms
	djnz	R2,aux3

	JNB 	BT1,noventa
	JNB 	BT3,zero	

	jmp 	centoe80


zero:

	Mov 	R2,#0ffh
	setb	p2.0				;inicia pulso em "1"	

	call	delay1Ms			;1Ms
	djnz	R2,$				;0.5Ms
 	
 	
 	clr		P2.0
	mov 	R2,#12h				; complemento do tempo menos 1
aux4: 
	call    delay1Ms
	djnz	R2,aux4

	Mov 	R2,#0ffh
	djnz	R2,$

	JNB 	BT1,noventa			
	JNB 	BT2,centoe80
	

	jmp 	zero

delay1Ms:						;1MS= 1000uc
	
	Mov 	R0,#0fDh			;1017uc totais de ciclos de maquina 
	Mov 	R1,#0fDh
	djnz	R0,$	
	djnz	R1,$

	ret
	
