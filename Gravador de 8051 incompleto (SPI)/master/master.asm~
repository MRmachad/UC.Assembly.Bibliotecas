;MASTER

Mosi	equ 	p1.0
Miso	equ	p1.1
SCK	equ	p1.2
RST	equ	p1.3
ledg	equ	p2.0
LEDE	EQU	P2.1

org 	0000h
jmp 	inicio

;vetor da interrupçao serial
org 	0023h
jb 	TI,enviou 
jb 	RI,recebeu

enviou:

recebeu:
clr 	ledg
MOV	A,#40H
call 	SEND
MOV	A,DPH
call 	SEND
MOV	A,DPL
call 	SEND
INC	DPTR
MOV	A,DPL
CJNE	A,#0FFH,NAOENCHEU
MOV	A,DPH
CJNE	A,#01H,NAOENCHEU
CLR 	LEDE			;
JMP 	$			;TRATAR OVERFLOW DE CAPACIDADE

NAOENCHEU:
mov 	A,SBUF
call 	SEND
; cofigurar SPI com manutenção do SCK a cada 104us(Baud rate 9600), Mosi envia dado e Miso recebe o dado do pino com o rst em 1 ,lógico 
;			1 byte		2 byte		3 byte		4 byte

;Read Program Memory	0010 0000	xxxA12---	-------A0	D7-----D0(recolhe)
;Write Program Memory	0100 0000	xxxA12---	-------A0	D7-----D0(envia)


; MOVIMENTO SCK 0 LOGICO PARA ESCREVER(MOSI) DEPOIS SOBE PARA 1 E ESPERA O DELAY, DEPOIS 0 PARA ESCREVER NOVAMENTE VAI 0;
; NO RECCEBIMENTO DE DADOS(MISO), O DADO VALIDO É NO HIGTH TO LOW DO SCK, OU SEJA O CONTRARIO.
SETB	ledg
clr 	RI
RETI

inicio:
clr	RST
call 	EraseChip
MOV	DPTR,#0000H
MOV 	PCON,#10000000B		;(smod)
MOV 	tmod,#00100000B		;(timer mode)
MOV 	TH1, #00FAh		;
MOV 	TL1, #00FAh		;
setb	TR1			;liga o timer de recarregamento automatico COM OVERFLOW DE A CADA 6US PARA BAUD RATE DE 9600
MOV 	SCON,#01010000B		;Determina modo 1 de serial(USART 8 bits) limpa os bits TI e RI, libera REN
MOV 	IE,#10010000B		;HABILITA INTERRUPÇÃO SERIAL




loop:

jmp loop


EraseChip:
;chip erase		1010 1100	100x xxxx	xxxx xxxx	xxxx xxxx
clr 	ledg
MOV	A,#0ACH
call	SEND
MOV	A,#080H
call	SEND
MOV	A,#00H
call	SEND
MOV	A,#00H
call	SEND
setb	ledg
ret



SEND:
mov	R1,#08h
auxsend:
clr	SCK  		;VOU ESCREVER

rlc	A		;
MOV	MOSI,C		;
NOP			;
NOP			;	
NOP			;
NOP			;
NOP			;	
NOP			;	
NOP			;TEMPO MINIMO DE PULSE LOW 8 PERIODOS DO OCILADOR = 8US


SETB	SCK		;ENVIAR 
CALL	SCKDELAY	;TEMPO MINIMO DE PULSE higth 8 PERIODOS DO OCILADOR = 8US

djnz	r1,auxsend
RET


SCKdelay:
	MOV R0,#031H
	DJNZ R0,$
	RET			;102 US + 2US DO CALL

END
	