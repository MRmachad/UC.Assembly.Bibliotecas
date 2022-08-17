;------tempo em led por interrupção------- 
	led	equ	p2.0
	btn	equ	p3.2

;--------------vetor de reset--------------
	org	000h
	jmp	config
;------------------------------------------

;-------vetor de interrupçao int 0---------
	org	003h
aux:	
	inc	r7
	call	delay01s
	jnb	btn,aux		;se o botão ainda estiver apertado soma 1 segundo ao tempo
	call	ligaLed
	mov	r7,#00h
	reti
;-----------------------------------------

config:	
	setb	p2.0		;led desligado
	setb	p3.2		;desvio de interrupção no hight-to-low	
	mov	ie,#81H		;permite a interrupções gerai e a interrupção externa0
	mov	ip,#01h		;configura int0 como alta prioridade	
	mov 	tcon,#01h	;configura a interrupção como sensivel a borda	
	mov	r7,#00h	
	jmp	loop
;-----------------------------------------

loop:
	jmp 	$		;espera acionamento da interrupção
;-----------------------------------------

;-------------inicio subRotinas-----------
ligaLed:
	clr 	led
aux1:
	call	delay01s
	djnz	r7,aux1
	setb	led	
	
	ret
	
delay01S:
	mov		r2,#64h

aux2:
	call	aux3
	djnz	r2,aux2
aux3:
	mov 	r0,#0ffh
	mov	r1,#0ffh
	djnz	r0,$
	djnz	r1,$
	ret	