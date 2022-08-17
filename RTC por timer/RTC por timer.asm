; se a interrupção é vetorizada, o proprio hardware limpa a flag interna e reinicia a contagem
	ORG	000H
	JMP	INICIO

	ORG 	01Bh
	mov 	TH1,#0BH			;2^16 - 62.500 = 65.536 - 62.500 = 3.036( valor inicial T1) / 62.500*16 = 1.000.000
	mov	TL1,#0DCH	
	inc	066h				;registrador para completar os segundos 	
	mov	acc,066h		
	cjne	a,#10h,contaDNV			;10 = 16  -> 16 *62500 =1 000 000 us
	mov	066h,#00h			;zera segundos 
	inc	067h				;segundos
	mov	acc,067h
	cjne	a,#3Ch,contadnv			;segundo = 60	
	mov	067h,#00h			;zera minutos
	inc	068h				;minutos
	mov	acc,068h
	cjne	a,#3Ch,contadnv			;minutos = 60 ?
	mov	068h,#00h			;zera minutos
	inc	069h				;horas
	mov	acc,069h
	cjne	a,#06h,contadnv			;horas = 6?
	jmp 	$
	
	
contaDNV:
	reti

INICIO:
	mov 	tmod,#00010000B
	mov	ie,#10001000B
	mov 	TH1,#0BH			;2^16 - 62.500 = 65.536 - 62.500 = 3.036( valor inicial T1) / 62.500*16 = 1.000.000
	mov	TL1,#0DCH			; no over flow o bit TF1 é setado e quando vetorizado ele é limpo por hardware
	mov	066h,#00h		
	SETB	TR1
	JMP	$

END 