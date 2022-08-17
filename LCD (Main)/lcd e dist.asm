;a cada 0.111MS tempo de pulso ativo a mais ou a menos variamos 10 graos 
;a cada 0.056Ms	tempo de pulso ativo a mais ou a menos variamos 5 graos 	

;------SERVO MOTOR(PWM) e LCD --------
	RS  EQU P1.3
	E   EQU P1.2
	DB7 EQU P1.7
	DB6 EQU P1.6
	DB5 EQU P1.5
	DB4 EQU P1.4
	
	Pulso 	equ	p2.0	;saida para o pulso 
	Echo 	equ 	p3.2
	Trig	equ	p2.7
;-----------Reset-----------
	org 	000h
	jmp 	inicio
inicio:
	call	lcd_init
	mov 	P2,#000h 	;define como saida de dados
	clr	echo
	setb	tr0		;
	mov	tmod,#09h   	; configura o contador pra contar enquanto o int  for a um 1 (timer 16 bit contado com a frequencia do uc)
	mov	r7,#1h
	mov	r6,#1h
	mov	r5,#1h
	mov	r4,#1h
	mov 	r3,#12h
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




;O reigistrador recebe (1+ a quantidade de vezes desejada)
encontraNovoNumero:
	call	StartPlay
	call 	MostraLCD
	call	shiftletf
	mov 	acc,R7
configPWM:
	mov	b,#05h				;Qual a variação de cm altera/90 graus/5?= 18/ 1ms ativo varia 90graus o grau zero
	div	ab									       ;começa em 0.5 ms ativo, div 1 por 18 

	cjne	a,#00h,f5			;65graus
	mov	r7,#01h
	mov	r6,#06h
	mov	r5,#13h
	mov	r4,#0eh
	jmp 	fim
f5: 
	cjne	a,#01h,f10 			;60graus
	mov	r7,#01h
	mov	r6,#7h
	mov	r5,#13h
	mov	r4,#0Dh
	jmp 	fim
f10: 
	cjne	a,#02h,f15 
	mov	r7,#01h
	mov	r6,#8h
	mov	r5,#13h
	mov	r4,#0Ch
	jmp 	fim
	
f15: 
	cjne	a,#03h,f20 
	mov	r7,#01h
	mov	r6,#09h
	mov	r5,#13h
	mov	r4,#0Bh
	jmp 	fim
f20: 
	cjne	a,#04h,f25
	mov	r7,#01h
	mov	r6,#0Ah
	mov	r5,#13h
	mov	r4,#0Ah
	jmp 	fim
f25: 
	cjne	a,#05h,f30
	mov	r7,#01h
	mov	r6,#0Bh
	mov	r5,#13h
	mov	r4,#09h
	jmp 	fim
f30: 
	cjne	a,#06h,f35 
	mov	r7,#01h
	mov	r6,#0Ch
	mov	r5,#13h
	mov	r4,#08h
	jmp 	fim
f35: 
	cjne	a,#07h,f40
	mov	r7,#01h
	mov	r6,#0Dh
	mov	r5,#13h
	mov	r4,#07h
	jmp 	fim 
f40: 
	cjne	a,#08h,f45
	mov	r7,#01h
	mov	r6,#0Eh
	mov	r5,#13h
	mov	r4,#06h
	jmp 	fim 
f45: 
	cjne	a,#09h,f50 
	mov	r7,#01h
	mov	r6,#0fh
	mov	r5,#13h
	mov	r4,#05h
	jmp 	fim
f50: 
	cjne	a,#0Ah,f55
	mov	r7,#01h
	mov	r6,#10h
	mov	r5,#13h
	mov	r4,#04h
	jmp 	fim 
f55: 
	cjne	a,#0Bh,f60 
	mov	r7,#01h
	mov	r6,#11h
	mov	r5,#13h
	mov	r4,#03h
	jmp 	fim
f60: 
	cjne	a,#0Ch,f65
	mov	r7,#01h
	mov	r6,#12h
	mov	r5,#13h
	mov	r4,#02h
	jmp 	fim 
f65: 					;meio
	cjne	a,#0Dh,f70
	mov	r7,#02h
	mov	r6,#01h
	mov	r5,#13h
	mov	r4,#01h
	jmp 	fim 
f70: 
	cjne	a,#0Eh,f75 
	mov	r7,#02h
	mov	r6,#02h
	mov	r5,#12h
	mov	r4,#12h
	jmp 	fim
f75: 
	cjne	a,#0fh,f80
	mov	r7,#02h
	mov	r6,#03h
	mov	r5,#12h
	mov	r4,#11h
	jmp 	fim 
f80: 
	cjne	a,#10h,f85 
	mov	r7,#02h
	mov	r6,#04h
	mov	r5,#12h
	mov	r4,#10h
	jmp 	fim
f85: 
	cjne	a,#11h,f90
	mov	r7,#02h
	mov	r6,#05h
	mov	r5,#12h
	mov	r4,#0fh
	jmp 	fim 
f90: 
	cjne	a,#12h,f95
	mov	r7,#02h
	mov	r6,#06h
	mov	r5,#12h
	mov	r4,#0eh
	jmp 	fim 
f95: 
	cjne	a,#13h,f100 
	mov	r7,#02h
	mov	r6,#07h
	mov	r5,#12h
	mov	r4,#0dh
	jmp 	fim
f100: 
	cjne	a,#14h,f105 
	mov	r7,#02h
	mov	r6,#08h
	mov	r5,#12h
	mov	r4,#0ch
	jmp 	fim
f105: 
	cjne	a,#15h,f110
	mov	r7,#02h
	mov	r6,#09h
	mov	r5,#12h
	mov	r4,#0bh
	jmp 	fim 
f110: 
	cjne	a,#16h,f115 
	mov	r7,#02h
	mov	r6,#0Ah
	mov	r5,#12h
	mov	r4,#0Ah
	jmp 	fim
f115: 
	cjne	a,#17h,f120
	mov	r7,#02h
	mov	r6,#0Bh
	mov	r5,#12h
	mov	r4,#09h
	jmp 	fim 
f120: 
	cjne	a,#18h,f125
	mov	r7,#02h
	mov	r6,#0Ch
	mov	r5,#12h
	mov	r4,#08h
	jmp 	fim 
f125: 					;-60 graus 
	cjne	a,#19h,f130
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
	ret				;|880uc fixos mais valor variavel(1858ucStart play max + espera de 400uc) de 2258uc
					;| valor ser a descontado = fixo mais a media do variavel 2ms

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

lcd_init:
	MOV 30H, #'D'
	MOV 31H, #'I'
	MOV 32H, #'S'
	MOV 33H, #'T'
	MOV 34H, #'A'
	MOV 35H, #'N'
	MOV 36H, #'C'
	MOV 37H, #'I'
	MOV 38H, #'A'
	MOV 39H, #00111010B		;DOIS PONTOS ":"
	MOV 3AH, #'4'
	MOV 3BH, #'0'
	MOV 3CH, #'0'	
	MOV 3DH, #0

	mov   R2,#0Ah
delay15_MS:
	call  delay1ms
	djnz	R2,delay15_ms


	ACALL functionset
	ACALL entrymodeset
	ACALL displayonoffcontrol	

	SETB RS	
	MOV R1, #30H
loop:
	MOV A, @R1		
	JZ  retu
	CALL sendCharacter	
	INC R1			
	JMP loop	
retu:
	call	shiftletf
	ret		

sendCharacter:

	MOV C, ACC.7		
	MOV DB7, C			
	MOV C, ACC.6		
	MOV DB6, C			
	MOV C, ACC.5		
	MOV DB5, C			
	MOV C, ACC.4		
	MOV DB4, C			

	SETB E			
	CLR E			

	MOV C, ACC.3		
	MOV DB7, C			
	MOV C, ACC.2		
	MOV DB6, C			
	MOV C, ACC.1	
	MOV DB5, C		
	MOV C, ACC.0	
	MOV DB4, C			

	SETB E		
	CLR E	
	CALL delay	

	RET


functionset:	

	clr RS

	CLR  DB7		; |
	CLR  DB6		; |
	SETB DB5		; | DL=0~ datalength 4bits, se com 4 ou 8 bits de dados
	clr  DB4		; | nible superio 

	SETB E		        ; |
	CLR E		    	; | borda negativa no E

	CALL delay			

	SETB E		    	; |
	CLR E		    	; |borda negativa no E
				; |confirma a operação

	SETB DB7		; | nibble inferior set N=1~2 linhas /  F=0~fonte 5 × 8 dots 

	SETB E			; |
	CLR E			; | borda negativa no E
				; |function set low nibble sent
				
	CALL delay		; wait for BF to clear
	
	ret

entrymodeset:

; set to increment with shift

	CLR DB7		   ; |
	CLR DB6	       	   ; |
	CLR DB5		   ; |
	CLR DB4		   ; | nible superior

	SETB E		   ; |
	CLR E		   ; | borda negativa no E

  	CLR  DB7	   ; |	
	SETB DB6	   ; |
	SETB DB5	   ; |I/D=1~Incremento (direção de movimento do cursor)
	clr  DB4	   ; |S=1~display  nao acompanha shift 
			   ; |nible inferior
			 
	SETB E		   ; |
	CLR E		   ; | negative edge on E

	CALL delay	   ; wait for BF to clear

	RET


displayonoffcontrol:

; the display is turned on, the cursor is turned on and blinking is turned on
	CLR DB7		   ; |
	CLR DB6		   ; |
	CLR DB5		   ; |
	CLR DB4		   ; | nible superior

	SETB E		   ; |
	CLR E		   ; | negative edge on E

	SETB DB7	   ; |
	SETB DB6	   ; |
	SETB DB5	   ; |
	SETB DB4	   ; | low nibble set

	SETB E		   ; |
	CLR E		   ; | negative edge on E

	CALL delay	   ; |wait for BF to clear

	RET

MostraLCD:
	mov     R7,acc
	
	mov	b,#64h		;100decimal
	div 	ab
	add 	a,#30h
	call 	sendcharacter	
	
	mov	a,b
	mov 	b,#0Ah		;10dec
	div	ab
	add 	a,#30h
	call    sendcharacter
	
	mov	a,b
	add 	a,#30h
	call  	sendcharacter

	ret

shiftletf:
	clr	rs
	mov 	a,#00010000B	 ;|move left 
	call	sendcharacter
	call	sendcharacter
	call	sendcharacter
	setb	rs
	ret

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
	
delay:
	MOV R0, #50
	DJNZ R0, $
	RET
;rotina com arrendodamento  porem pode dar erro 
;mudar inicialização do r3
;
	end
