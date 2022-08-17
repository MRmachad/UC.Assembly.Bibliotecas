;----------SENSOR ULTRASONICO---------

;Funcionado
;esta lendo o nivel mas nao desliga o led (p2.4 nao seta )

;--------------RESET-----------------
	org 	000h
	jmp 	inicio

inicio:
	mov 	P2,#0f0h			; define nible superior como entrada e o nible inferior como saida 
	mov		P2,#11111000B		;Inicia led desligado
	jmp 	loop

loop:
	
	Setb 	P2.0		;Seta o tiguer
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	clr		P2.0		;Desliga tiguer


	JB		p2.7,$

aux:
	JNB		P2.7,fazer

	call	ligaLed

	Setb 	P2.3		;desliga led

	call	delay05s
	call	delay05s
	call	delay05s
	call	delay05s
	
	jmp		loop


fazer:

	inc 	b

	jmp		aux


ligaLed:
	clr 	p2.3		;Liga led 
aux2:
	call	delay05s
	djnz    b,aux2
	

	ret



delay05s:

	mov 	R3,#0FAh
	mov 	R2,#0FAh

	jmp		compDelay

delay1024uc:
	
	mov 	R0,#0FFh
	mov		R1,#0FFh
	djnz	R0,$
	djnz	R1,$

compDelay:
	djnz	R3,delay1024uc
	djnz	R2,delay1024uc

	ret




	end
