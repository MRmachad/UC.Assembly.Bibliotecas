;Sistemas Microprocessados 
;08/10/2020
;Autores: Leonardo Machado e Michelle Teles
;

L1	equ 	p2.0	
L2	equ 	p2.1
L3	equ 	p2.2
L4	equ 	p2.3
C1	equ	p2.4
C2	equ	p2.5
C3	equ	p2.6


org	0000h
jmp	config 

config:
Mov 	p2,#11111111B ; as coluna estarão em nivel alto definido como entrada de dados e as linhas como saída de dados

	
loop:
call 	varreduraTeclado
mov	p1,Acc
jmp 	loop

varreduraTeclado:
primeiralinha:
clr 	L1
JB	C1,AUX11
mov	A,#001h
JMP	fimVarredura

AUX11:
JB	C2,AUX12
mov	A,#002h
JMP	fimVarredura

AUX12:
JB	C3,Segundalinha
mov	A,#003h
JMP	fimVarredura


Segundalinha:
setb	L1
clr 	L2
JB	C1,AUX21
mov	A,#004h
JMP	fimVarredura

AUX21:
JB	C2,AUX22
mov	A,#005h
JMP	fimVarredura

AUX22:
JB	C3,Terceiralinha
mov	A,#006h
JMP	fimVarredura

Terceiralinha:
setb	L2
clr 	L3

JB	C1,AUX31
mov	A,#007h
JMP	fimVarredura

AUX31:
JB	C2,AUX32
mov	A,#008h
JMP	fimVarredura

AUX32:

JB	C3,Quartalinha
mov	A,#009h
JMP	fimVarredura

Quartalinha:

setb	L3
clr 	L4

JB	C1,AUX41
mov	A,#000h
JMP	fimVarredura

AUX41:
JB	C2,AUX42
mov	A,#000h
JMP	fimVarredura

AUX42:
JB	C3,NADA
mov	A,#000h

NADA:
SETB	L4

fimVarredura:
Mov 	p2,#1111111B	; Prevenção pra quando algum botão é precionado 
ret

end