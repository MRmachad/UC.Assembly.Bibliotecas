;---------- sensor de distancia em leds---------

	Echo 	equ p3.2
	Trig	equ	p2.7
	
	led0	equ	p2.0
	led1	equ	p2.1
	led2	equ	p2.2
	led3	equ	p2.3
	led4	equ	p2.4
	led5	equ	p2.5

;dist = (tempo em us)/58 (cm)

;-----------vetor reset--------------
	org 	000h
	jmp 	inicio

;-----------------------------------
inicio:	
	clr	echo
	mov	P2,#00h
	call	delay01s
	setb	tr0				;
	mov	tmod,#09h   	; configura o contador pra contar enquanto o int  for a um 1 (timer 16 bit contado com a frequencia do uc)
	jmp 	iniciar

iniciar:
	call	StartPlay
	call	ligaLed

	jmp	iniciar


;----------Sub rotinas-------------

StartPlay:

	setb 	trig 
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
	clr	trig

	jnb	echo,$			;
	jb	echo,$			;espera todo o pulso do echo
	mov	r7,#00h			;fica com um total momentaneo 
	mov	r5,#00h			;fica com o resto momentaneo
operando:

	mov	B,#3Ah			;B = 58 decimal 
	
	mov	a,tl0			;pega o byte inferior do timer
	div	ab				;divide por 58, a recebe a parte inteira e b o resto
	add 	a,r7			;a = a + r7(parte inteira ja divida)
	mov	r7,a			;adiciona o valor de divisão a r7(acumula todo a parte inteira no r7)

	mov	a,b
	add	a,r5
	mov	r5,a			;acumula o resto em r5
	
	mov	r6,th0
	CJNE	r6,#00h,recarrega	;Se th nao for 0 ele vai para recarrega
	
	mov	b,#3Ah			;B = 58 decimal 
	mov	a,r5			;a pega o byte resto total
	div	ab				;divide por 58, a recebe a parte inteira e b o resto
	add 	a,r7			;a = a + r7(parte inteira ja divida)
	mov	r7,a			;acumula todo a parte inteira no r7
	
	ret
	

recarrega:
	mov	tl0,#0ffh		;recarrega
	djnz	TH0,operando	;decrementa th0 
	jmp	operando		; para o caso de o valor de th0 ter o valor 1 ira decrementar e passa do "djnz"


ligaLed:
	mov	a,r7				;valor da dist
	mov	c,acc.0
	mov	led0,c
	mov	c,acc.1
  	mov	led1,c
	mov	c,acc.2
	mov	led2,c
	mov	c,acc.3
	mov	led3,c
	mov	c,acc.4
	mov	led4,c
	mov	c,acc.5
	mov	led5,c
	call    delay01s

	ret

delay01S:
	mov	r2,#64h

aux1:
	call	aux
	djnz	r2,aux1
aux:
	mov 	r0,#0ffh
	mov		r1,#0ffh
	djnz	r0,$
	djnz	r1,$
	ret		


End