;TESTE SERVO

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

	JMP 	ZERO

delay1Ms:						;1MS= 1000uc
	
	Mov 	R0,#0fDh			;1017uc totais de ciclos de maquina 
	Mov 	R1,#0fDh
	djnz	R0,$	
	djnz	R1,$

	ret
	