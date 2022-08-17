;
;TESTE DE FUNCIONAMENTO
;
;========================Definindo os pinos =============================

	led1	equ		p2.0	;

;============================Vetor de Reset===============================
	org			00h	;
	setb			led1
	ajmp			inicio	;

inicio:
	cpl			led1	;
	acall			delay500ms;
	jmp			inicio	;

delay500ms:
	mov		R1,#0FAH		;mando o valor para R1 em decimal 
aux1:
	mov		R2,#0FAH	;manda o valor  para R2 em decimal 2x250

aux2:
	nop				;1x250x250
	nop				;1x250x250
	nop				;1x250x250
	nop				;1x250x250
	nop				;1x250x250
	nop				;1x250x250 //ACHO QUE TAVA FALTANDO ESSE
					;375000
	djnz		R2,aux2		;enquanto aux2 não for 0, volta para lá 2x250x250=125000

	djnz		R1,aux1		;enquanto aux1 não for 0, volta para lá 2x250=500
	
	ret				;

	end				;