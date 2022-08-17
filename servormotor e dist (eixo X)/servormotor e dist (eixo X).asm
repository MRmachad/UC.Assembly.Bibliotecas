;a cada 0.111MS tempo de pulso ativo a mais ou a menos variamos 10 graos 
;a cada 0.056Ms	tempo de pulso ativo a mais ou a menos variamos 5 graos 	

;------SERVO MOTOR(PWM) e LCD --------
	Pulso 	equ	p2.0	;saida para o pulso 
	Echo 	equ 	p3.2
	Trig	equ	p2.7
;-----------Reset-----------
	org 	000h
	jmp 	inicio
inicio:
	mov 	P2,#000h 	;define como saida de dados
	clr	echo
	;call	delay01s
	setb	tr0		;
	mov	tmod,#09h   	; configura o contador pra contar enquanto o int  for a um 1 (timer 16 bit contado com a frequencia do uc)
	mov	r7,#1h
	mov	r6,#1h
	mov	r5,#1h
	mov	r4,#1h
	mov 	r3,#11h
	jmp 	PulsoPWM

;--------rotinas pwm ----------- (pulso de 50Hz confome o controle do servo controle do servo)
;tempo de Ms (IMPORTANTE :O comando djnz decrementa e depois faz o teste, então se coloca o numero de vezes de ciclo mais 1) 
 
pulsoPWM:				
	setb	p2.0		;inicia pulso em "1"
	mov 	a,r7
	mov	b,r6
	mov	r0,#0f9h	;0.5MS natural ativo
 	djnz	r0,$		;
aux1:
	djnz	acc,chamaDelay1
	jmp	aux_1
chamadelay1: 	
	call	delay1Ms
	jmp	aux1	
aux_1:
	djnz	b,completa1
	jmp	zera
completa1:
	call	delay0_056Ms
	jmp	aux_1

zera:	
 	clr	p2.0		;inicia pulso em "0"
 	mov	r0,#0f9h	;0.5MS natural desligado
 	djnz	r0,$		;
 	mov 	a,r5
	mov	b,r4	
aux2:
	djnz	acc,chamadelay12
	jmp	aux_2
chamadelay12:
	call	delay1Ms
	jmp	aux2
aux_2:
	djnz	b,completa2
	inc 	r3			
	cjne	r3,#13h,auxPWM		;pré-set antes da proxima onda que vai ter o find
	call	encontraNovoNumero
	mov	r3,#00h
	jmp	pulsoPWM
auxPWM:					;compensa o tempo de find
	cjne	r3,#12h,pulsoPWM
	clr	c
	mov	a,r4			;	
	subb	a,#04h			;tira 2ms aproximadamente
	jc	auxPWM1			; tem tempos em que não vai poder fazer uma subtração
	cjne	a,#00h,soPassa	
	inc	acc
soPassa:	
	mov	r4,acc		;compensa o find
auxPWM1:
	jmp	pulsoPWM
	
completa2:
	call	delay0_056Ms
	jmp	aux_2


;O reigistrador recebe (1+ a quantidade de vezes desejada)
encontraNovoNumero:
	call	StartPlay
	
configPWM:
	mov	b,#05h				;Qual a variação de cm altera/90 graus/5?= 18/ 1ms ativo varia 90graus o grau zero
	div	ab									       ;começa em 0.5 ms ativo, div 1 por 18 

	cjne	a,#00d,f5			;65graus
	mov	r7,#01h
	mov	r6,#06h
	mov	r5,#13h
	mov	r4,#0eh
	jmp 	fim
f5: 
	cjne	a,#01d,f10 			;60graus
	mov	r7,#01h
	mov	r6,#7h
	mov	r5,#13h
	mov	r4,#0Dh
	jmp 	fim
f10: 
	cjne	a,#2d,f15 
	mov	r7,#01h
	mov	r6,#8h
	mov	r5,#13h
	mov	r4,#0Ch
	jmp 	fim
	
f15: 
	cjne	a,#3d,f20 
	mov	r7,#01h
	mov	r6,#09h
	mov	r5,#13h
	mov	r4,#0Bh
	jmp 	fim
f20: 
	cjne	a,#4d,f25
	mov	r7,#01h
	mov	r6,#0Ah
	mov	r5,#13h
	mov	r4,#0Ah
	jmp 	fim
f25: 
	cjne	a,#5d,f30
	mov	r7,#01h
	mov	r6,#0Bh
	mov	r5,#13h
	mov	r4,#09h
	jmp 	fim
f30: 
	cjne	a,#6d,f35 
	mov	r7,#01h
	mov	r6,#0Ch
	mov	r5,#13h
	mov	r4,#08h
	jmp 	fim
f35: 
	cjne	a,#7d,f40
	mov	r7,#01h
	mov	r6,#0Dh
	mov	r5,#13h
	mov	r4,#07h
	jmp 	fim 
f40: 
	cjne	a,#8d,f45
	mov	r7,#01h
	mov	r6,#0Eh
	mov	r5,#13h
	mov	r4,#06h
	jmp 	fim 
f45: 
	cjne	a,#9d,f50 
	mov	r7,#01h
	mov	r6,#0fh
	mov	r5,#13h
	mov	r4,#05h
	jmp 	fim
f50: 
	cjne	a,#10d,f55
	mov	r7,#01h
	mov	r6,#10h
	mov	r5,#13h
	mov	r4,#04h
	jmp 	fim 
f55: 
	cjne	a,#11d,f60 
	mov	r7,#01h
	mov	r6,#11h
	mov	r5,#13h
	mov	r4,#03h
	jmp 	fim
f60: 
	cjne	a,#12d,f65
	mov	r7,#01h
	mov	r6,#12h
	mov	r5,#13h
	mov	r4,#02h
	jmp 	fim 
f65: 					;meio
	cjne	a,#13d,f70
	mov	r7,#02h
	mov	r6,#01h
	mov	r5,#13h
	mov	r4,#01h
	jmp 	fim 
f70: 
	cjne	a,#14d,f75 
	mov	r7,#02h
	mov	r6,#02h
	mov	r5,#12h
	mov	r4,#12h
	jmp 	fim
f75: 
	cjne	a,#15d,f80
	mov	r7,#02h
	mov	r6,#03h
	mov	r5,#12h
	mov	r4,#11h
	jmp 	fim 
f80: 
	cjne	a,#16d,f85 
	mov	r7,#02h
	mov	r6,#04h
	mov	r5,#12h
	mov	r4,#10h
	jmp 	fim
f85: 
	cjne	a,#17d,f90
	mov	r7,#02h
	mov	r6,#05h
	mov	r5,#12h
	mov	r4,#0fh
	jmp 	fim 
f90: 
	cjne	a,#18d,f95
	mov	r7,#02h
	mov	r6,#06h
	mov	r5,#12h
	mov	r4,#0eh
	jmp 	fim 
f95: 
	cjne	a,#19d,f100 
	mov	r7,#02h
	mov	r6,#07h
	mov	r5,#12h
	mov	r4,#0dh
	jmp 	fim
f100: 
	cjne	a,#20d,f105 
	mov	r7,#02h
	mov	r6,#08h
	mov	r5,#12h
	mov	r4,#0ch
	jmp 	fim
f105: 
	cjne	a,#21d,f110
	mov	r7,#02h
	mov	r6,#09h
	mov	r5,#12h
	mov	r4,#0bh
	jmp 	fim 
f110: 
	cjne	a,#22d,f115 
	mov	r7,#02h
	mov	r6,#0Ah
	mov	r5,#12h
	mov	r4,#0Ah
	jmp 	fim
f115: 
	cjne	a,#23d,f120
	mov	r7,#02h
	mov	r6,#0Bh
	mov	r5,#12h
	mov	r4,#09h
	jmp 	fim 
f120: 
	cjne	a,#24d,f125
	mov	r7,#02h
	mov	r6,#0Ch
	mov	r5,#12h
	mov	r4,#08h
	jmp 	fim 
f125: 					;-60 graus 
	cjne	a,#25d,f130
	mov	r7,#02h
	mov	r6,#0Dh
	mov	r5,#12h
	mov	r4,#07h
	jmp 	fim
f130: 					;-65 graus 
	mov	r7,#02h
	mov	r6,#0eh
	mov	r5,#12h
	mov	r4,#06h
fim:		
	ret

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
	div	ab			;divide por 58, a recebe a parte inteira e b o resto
	add 	a,r7			;a = a + r7(parte inteira ja divida)
	mov	r7,a			;adiciona o valor de divisão a r7(acumula todo a parte inteira no r7)
	mov	a,b
	add	a,r5
	mov	r5,a			;acumula o resto em r5
	mov	r6,th0
	CJNE	r6,#00h,recarrega	;Se th nao for 0 ele vai para recarrega
	mov	b,#3Ah			;B = 58 decimal 
	mov	a,r5			;a pega o byte resto total
	div	ab			;divide por 58, a recebe a parte inteira e b o resto
	add 	a,r7			;a = a + r7(parte inteira ja divida)
	CJNE	a,#00h,verifica_dois
	jmp	retoma
verifica_dois:
	CJNE	a,#01h,reforma
	jmp	retoma
reforma:
	subb	a,#02h			;ajusta ao erro do sensor de 2 cm 
retoma:
	mov	c,acc.2
	mov	p3.7,c
	mov	c,acc.1
	mov	p3.6,c
	mov	c,acc.0
	mov	p3.5,c
	ret
recarrega:
	mov	tl0,#0ffh		;recarrega
	djnz	TH0,operando		;decrementa th0 
	jmp	operando		; para o caso de o valor de th0 ter o valor 1 ira decrementar e passa do "djnz"




;rotinas de ferramentas
delay01S:
	mov	r2,#64h

auxD:
	call	auxD1
	djnz	r2,auxD
auxD1:
	mov 	r0,#0ffh
	mov	r1,#0ffh
	djnz	r0,$
	djnz	r1,$
	ret		
	
delay1Ms:						;1MS= 1000uc
	
	Mov 	R0,#0f7h			;1000uc totais de ciclos de maquina 
	Mov 	R1,#0f8h
	djnz	R0,$	
	djnz	R1,$
	ret
	
delay0_056Ms:					;subtrai dois alem do total por causa do jmp no complemente
	mov	r0,#18h
	djnz	r0,$
	ret
	
delay:
	MOV R0, #50
	DJNZ R0, $
	RET
;rotina com arrendodamento  porem pode dar erro 
;mudar inicialização do r3
;
	end