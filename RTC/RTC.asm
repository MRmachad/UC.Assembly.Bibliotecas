;-----------RTC-------------
	rst 	equ 	p2.0
	clk	equ	p2.1
	io	equ	p2.2
	tOD	equ	p2.3
;---------------------------
;ENDEREÇOS CALENDARIO
;segundo : (leitura) 1000 0001B / 129D /81H - (escrita) 1000 0000B / 128D / 80h
;minuto  : (leitura) 1000 0011B / 131D /83H - (escrita) 1000 0010B / 130D / 82h
;Horas   : (leitura) 1000 0101B / 133D /85H - (escrita) 1000 0100B / 132D / 84h
;DATE(dia do mês): (leitura) 1000 0111B / 135D /87H - (escrita) 1000 0110B / 134D / 86h
;
;

;a  = endereço				(geralmente hexa)
;b  = dado caso escrita 		(valor em bcd)
;r7 = dado de leitura			(valor em bcd)
;------Vetor de reset-------
	org 	000h
	jmp	inicio
;---------------------------

;-------inicio rotinas------
inicio:
	call 	config
	
	mov 	a,#80h
	mov	b,#00h		
	call 	preescreve

	mov 	a,#82h
	mov	b,#00h		
	call 	preescreve

	mov 	a,#84h
	mov	b,#00h		
	call 	preescreve

	mov 	a,#86h
	mov	b,#00h		
	call 	preescreve
aux:
	mov	a,#85h
	call	preleitura
	CJNE	R7,#00H,aux
	call	ligadesliga
aux1:
	mov	a,#85h
	call	preleitura
	cjne	r7,#60H,aux1
	call	ligadesliga
	
	jmp 	aux
;---------------------------

;------inicio subrotinas----
config:
	clr 	rst
	clr	clk
	mov 	a,#8eh				;
	mov	b,#00h				;
	call	preescreve			;habilita para escrita deixando o wp em 0

	mov 	a,#90h				;
	mov	b,#0a4h				;
	call	preescreve			;define os diodos de uso

	mov 	a,#80h
	mov	b,#00h
	call 	preescreve			;inicia contagem
	
	clr 	tod
	ret

ligaDesliga:
	cpl	tod				;LIGA OU DESLIGA 
	ret
preEscreve:
	setb	rst
	mov	r7,a			;endereço a ser enviado
	call	enviadado	
	mov	r7,b			;dado a ser enviado
	call	enviadado
	clr	rst
	ret

preLeitura:				;Dado fica em r7
	setb 	rst
	mov	r7,a			;endereço a ser enviado
	call	lerdado
	clr 	rst
	ret
	
enviaDado:
	mov	a,r7			; move o byte de comando/endereço  para o acumulador 

	mov 	c,acc.0			;
	mov	io,c			;coloca o bit W ou R no duto serial - ou dado 0
	setb	clk			;
	clr	clk			;valida dado

	mov 	c,acc.1			;
	mov	io,c			;Endereço ou dado 1
	setb	clk			;
	clr	clk

	mov 	c,acc.2			;
	mov	io,c			;Endereço ou dado 2
	setb	clk			;
	clr	clk

	mov 	c,acc.3			;
	mov	io,c			;Endereço ou dado 3
	setb	clk			;
	clr	clk

	mov 	c,acc.4			;
	mov	io,c			;Endereço ou dado 4 
	setb	clk			;
	clr	clk

	mov 	c,acc.5			;
	mov	io,c			;Endereço ou dado 5
	setb	clk			;
	clr	clk

	mov 	c,acc.6			;
	mov	io,c			; Calendario/CLOCK(0) OU RAM(1)- ou dado 6 
	setb	clk			;
	clr	clk

	mov 	c,acc.7			;
	mov	io,c			;Bit de parada(1) - ou dado 7
	setb	clk			;
	clr	clk
	
	ret

lerDado:
	call	enviadado
	

	mov	c,io
	mov	acc.0,c
	setb	clk
	nop			
	clr	clk
	nop

	mov	c,io
	mov	acc.1,c
	setb	clk
	nop			;
	clr	clk
	nop

	mov	c,io
	mov	acc.2,c
	setb	clk
	nop			;
	clr	clk
	nop

	mov	c,io
	mov	acc.3,c
	setb	clk
	nop			;
	clr	clk
	nop

	mov	c,io
	mov	acc.4,c
	setb	clk
	nop			;
	clr	clk
	nop

	mov	c,io
	mov	acc.5,c
	setb	clk
	nop			;
	clr	clk
	nop

	mov	c,io
	mov	acc.6,c
	setb	clk
	nop			;
	clr	clk
	nop

	mov	c,io
	mov	acc.7,c
	setb	clk
	nop			;
	clr	clk
	nop

	mov	r7,a

	ret

;------------delays---------
delay:
	mov     r4,#0ffh
aux2:
	mov	r0,#0ffh
	mov	r1,#0ffh
	mov	r2,#0ffh
	mov	r3,#0ffh
	djnz	r0,$
	djnz	r1,$
	djnz	r2,$
	djnz	r3,$
	djnz	r4,aux2
	
	end