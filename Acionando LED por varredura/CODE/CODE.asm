;Sistemas Microprocessados 
;30/09/2020
;Autores: Leonardo Machado e Michelle Teles
;
;Acionamento de 4 Led em current side por varredura de botão
;O acinamentos podem ser individuais ou geral 	


	LED1	EQU 	P2.0
	LED2	EQU	P2.1
	LED3	EQU	P2.2
	LED4	EQU	P2.3

	BTN1	EQU	P2.4
	BTN2	EQU	P2.5
	BTN3	EQU	P2.6
	BTN4	EQU	P2.7

	BTNG	EQU	P1.0
	
	ORG 	0000H
	JMP 	INICIO

INICIO:
	MOV	P2,#0FFH	;INICIA O NIBBLE EM 1 , DESTA FORMA OS LEDS FICAM DESLIGADOS  

LOOP:	
	JB	BTN1,AUX
	CPL	LED1
	jnb	BTN1,$
AUX:
	JB	BTN2,AUX1
	CPL	LED2
	jnb	BTN2,$
AUX1:
	JB	BTN3,AUX2
	CPL	LED3
	jnb	BTN3,$
AUX2:
	JB	BTN4,AUX3
	CPL	LED4
	jnb	BTN4,$
AUX3:
	JB	BTNG,LOOP		; TROCA DE TURNOS POR EXEMPLO
	CPL	LED1
	CPL	LED2
	CPL	LED3
	CPL	LED4
	jnb	BTNG,$
	JMP	LOOP

	
	END