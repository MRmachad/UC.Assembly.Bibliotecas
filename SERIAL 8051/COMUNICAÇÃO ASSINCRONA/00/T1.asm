;uC  T1

org	0000h
jmp 	config 


config:
MOV  	P1,#0ffH
MOV	P2,#0ffH

MOV	SCON,#01010000B		; ATIVA A SERIAL NO MODO 00(SICRONO DE 8 BITS COM BAUD RATE 1/12 DO OCILADOR)
MOV 	TMOD,#00100000B
MOV	TH1,#0FAH
SETB	TR1 


LOOP:
CALL	ENVIA
AUX:
JNB	TI,AUX
CLR	TI

AUX1:
JNB	RI,AUX1
CLR	RI
MOV	A,SBUF
MOV	P2,A
JMP 	LOOP

ENVIA:
MOV	A,P1
MOV 	SBUF,A
RET
END
