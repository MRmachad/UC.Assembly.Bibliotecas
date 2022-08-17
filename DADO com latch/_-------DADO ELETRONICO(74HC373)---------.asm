
;tensão de carga: 6.40V - 4.5V bancada 
;tensão que chega ao led 3,64V corrente 40MA
; -      -   antes da CI 3V	 

;tensão de carga: 5.30V - 3.7V bancada 
;tensão que chega ao led 1.90V   corrente 17.37MA
; -      -   antes da CI 2.61V	 corrente 9.39MA

;-------DADO ELETRONICO(74HC373)---------
		BT1 	equ		P3.7

		led1 	equ		p2.7
		led2 	equ		p2.6
		led3 	equ		p2.5
		led4 	equ		p2.4
		led5 	equ		p2.3
		
		OE 		equ		p2.1
		LE 		equ		p2.0

;------------reset----------------

	org 	000h

	jmp		inicio

;-------inicio rotinas-----------


inicio:
	mov 	P3,#0FFh			;define-se o porte p3 como entrada
	mov 	P2,#00h 			;define-se o porte p2 como saida 
	mov 	P2,#02h				;coloca a CI 74HC373 em alto impedancia
	mov 	R0,#00h
	jmp  	loop

loop:
	inc 	R0					;R0 forne uma seguencia aleatorio de bits pela rapida mudança de valor
	JNB		BT1,sorteia

	jmp 	loop

sorteia:
	Mov 	a,R0				;O nibble superior e um bit do nibble inferior e se torna a seguencia de amostragem

	Mov 	c,acc.7
	Mov 	led1,c

	Mov 	c,acc.6
	Mov 	led2,c

	Mov 	c,acc.5
	Mov 	led3,c

	Mov 	c,acc.4
	Mov 	led4,c

	mov 	c,acc.3
	mov 	led5,c


	setb	LE 	 			;Configura o Modo transparente
	clr	 	OE   			;/

	clr		LE 				;registra 

	jmp  	loop			;Volta ao loop aonde R0 é incrementado e recebe outra seguencia 