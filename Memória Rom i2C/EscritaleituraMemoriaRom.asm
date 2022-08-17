;--------Escrica e leitura memoria Rom-------
	
	scl 	equ	p2.0
	sda	equ	p2.1


;---------------vetor reset------------------
	org 	000h
	jmp	inicio
;--------------------------------------------

;--------inicio rotina principal-------------
inicio:
	mov 	a,#00h
	mov	b,#10101010b
	call	armazenaeeprom
	mov	a,#00h
	call	leituradememoria
	mov	p3,r7
	
	jmp 	$
;--------------------------------------------

;---------inicio SubRotinas------------------
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
LeituraDeMemoria:
	call	starteeprom
	mov	r7,#0A0h
	call	writeeeprom
	call	getack

	mov	r7,a 		;endereço
	call	writeeeprom
	call	getack

	call	starteeprom	
	mov	r7,#10100001b
	call	writeeeprom
	call	getack

	call	geteeprom
	setb	sda		;envio no ack
	call	serialclock
	call	stopeeprom
	ret

ArmazenaEEprom:
	call	starteeprom
	mov	r7,#0A0h
	call	writeeeprom
	call	getack

	mov	r7,a 		;endereço
	call	writeeeprom
	call	getack
	
	mov	r7,b		;dado
	call	writeeeprom
	call	getack
	call	stopeeprom
	call	certoEEprom_
	ret
;Mudança higth to low do sda com o scl em higth inicia a transmissão de dados
StartEEprom:
	Setb	scl		
	setb	sda
	nop
	clr	sda
	nop	
	nop
	nop
	nop
	nop
	clr	scl
	ret

;Mudança low to higth do sda com o scl em higth para a transmissão de dados
; O scl é deixado em low para validar o uso do setb scl na label startEEprom em usos futuros
StopEEprom:
	clr 	sda
	setb	scl
	nop
	nop
	nop
	nop
	setb	sda
	nop
	clr	scl
	ret

;O acknowledge é o envio de nivel "0" da EEprom no nono clock
;O envio do ACK é feito no low to higth do scl
getACK:
envioCLK:
	clr		scl
	setb	sda
	nop	
	nop
	setb	scl   ;recebe aqui o adk
	nop
	nop
	nop
	nop
esperaACK:
	mov	c,sda
	clr	scl
	nop	
	ret

;Proporciona o pulso para transação de dado
;É aguardado 6us entre as mudanças de estado 
SerialClock:
	nop
	nop
	nop
	nop
	setb	scl
	nop
	nop
	nop
	nop
	clr	scl
	ret
	
;envia 8bits de r7 com auxilio do serial clock
WriteEEprom:
	mov	r5,#08h		;conta 8 vezes
	clr	scl
	mov	a,r7		;byte de envio

tprox:
	rlc	a	;desloca td para esqueda e manda o msb para o C
	mov	sda,c
	call	serialclock
	djnz	r5,tprox
	ret  

;pega dado da eeprom e guarda em r7
getEEprom:
	mov	r5,#08h		;conta 8 vezes
	setb	sda
	clr	c
rprox:
	nop	
	nop
	nop
	nop
	setb	scl		;envio clock
	nop
	nop
	nop
	mov	c,sda
	rlc 	a		;vai trocando com o carry
	clr	scl
	djnz	r5,rprox
	mov	r7,a 
	ret

;poll performs ack to determine when a write cyclehas completed		
certoEEprom_:
	call	StartEEprom
	mov	r7,#0A0h
	call	writeeeprom
	call	getack
	jc	certoeeprom_	;espera o ACK
	call	stopeeprom 
	ret

	end	