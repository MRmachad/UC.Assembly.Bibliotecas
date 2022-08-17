; Firmware para escreve nome na primeira linha
; e sobrenome na segunda linha

; Declarações de constantes
E		EQU P1.2	; Habilita o LCD
RS		EQU P1.3	; RS=0 p/ instrução
					; RS=1 p/ dados

	ORG 0H
RESET:
	JMP		INICIO

	ORG 30H
LINHA1: DB 'L','e','o','n','a','r','d','o',00H
LINHA2: DB 'C','o','s','t','a',' ','d','e',' ','P','a','u','l','a',00H

INICIO:
	CLR		E

	; Espera LCD iniciar
	CALL 	DELAY_15MS

	; Function Set (4 bits)
	CLR		RS			; Instrução
	ANL		P1, #2FH	; Commando!
	SETB	E			; Pelo menos 1 us!
	CLR		E			; Pulso E do LCD
	CALL	DELAY_50uS	; Espera BF (>37 us)

	CALL 	DELAY_4MS	; PRIMEIRA VEZ!

	; Function Set (4 bits novamente!)
	SETB	E			; Pelo menos 1 us!
	CLR		E			; Pulso E do LCD
	ANL		P1, #0FH	; Zera nibble superior
	SETB	P1.7		; N=1 (2 linhas)
	SETB	E			; Pelo menos 1 us!
	CLR		E			; Pulso E do LCD
	CALL	DELAY_50uS	; Espera BF (>37 us)
	CALL	DELAY_50uS	; Espera BF (>37 us)

	; Entry mode
	ANL		P1, #0FH	; Zera nibble superior
	SETB	E			; Pelo menos 1 us!
	CLR		E			; Pulso E do LCD
	ORL		P1, #60H	; Seta DB6 e DB5 (I/D)
	SETB	E			; Pelo menos 1 us!
	CLR		E			; Pulso E do LCD
	CALL	DELAY_50uS	; Espera BF (>37 us)

	; Display On/Off control
	ANL		P1, #0FH	; Zera nibble superior
	SETB	E			; Pelo menos 1 us!
	CLR		E			; Pulso E do LCD
	ORL		P1, #0F0H	; Seta D, C e B
	SETB	E			; Pelo menos 1 us!
	CLR		E			; Pulso E do LCD
	CALL	DELAY_50uS	; Espera BF (>37 us)

	SETB	RS			; Muda para dados
	CALL	SET_LINE1
	MOV		DPTR, #LINHA1
	CALL	WRITE_LINE
	CALL	SET_LINE2
	MOV		DPTR, #LINHA2
	CALL	WRITE_LINE
MAIN:
	JMP 	MAIN

; Coloca o cursor na primeira coluna da primeira linha
SET_LINE1:
	CLR		RS
	ANL		P1, #0FH
	ORL		P1, #10000000B
	SETB	E			; Pelo menos 1 us!
	CLR		E			; Pulso E do LCD
	ANL		P1, #0FH
	SETB	E			; Pelo menos 1 us!
	CLR		E			; Pulso E do LCD
	CALL	DELAY_50uS	; Espera BF (>37 us)
	SETB	RS
	RET

; Coloca o cursor na primeira coluna da segunda linha
SET_LINE2:
	CLR		RS
	ANL		P1, #0FH
	ORL		P1, #11000000B
	SETB	E			; Pelo menos 1 us!
	CLR		E			; Pulso E do LCD
	ANL		P1, #0FH
	SETB	E			; Pelo menos 1 us!
	CLR		E			; Pulso E do LCD
	CALL	DELAY_50uS	; Espera BF (>37 us)
	SETB	RS
	RET


; Rotina que envia caracteres ao LCD
; até encontrar um caracter ZERO
; Destroy DPTR (end. do início dos caracteres)
WRITE_LINE:
	PUSH	ACC
	PUSH	B

WRITE_LINE_LOOP:
	CLR		A
	MOVC	A, @A+DPTR	; Lê byte!
	JZ		WRITE_LINE_FIM
	INC		DPTR
	MOV 	B, #0FH
	ANL		B, A		; Nibble inf.
	ANL		A, #0F0H	; Nibble sup.
	ANL		P1, #0FH	; ZERA nibble sup. de P1
	ORL		P1, A		; Escreve nibble em P1.H
	SETB	E			; Pelo menos 1 us!
	CLR		E			; Pulso E do LCD

	MOV		A, B		; Recupera nibble inf.
	SWAP	A
	ANL		P1, #0FH	; ZERA nibble sup. de P1
	ORL		P1, A		; Escreve nibble em P1.H
	SETB	E			; Pelo menos 1 us!
	CLR		E			; Pulso E do LCD

	CALL	DELAY_50uS	; Espera BF (>37 us)
	JMP		WRITE_LINE_LOOP

WRITE_LINE_FIM:
	POP		B
	POP		ACC
	RET

; Rotina que espera 10 us
DELAY_10uS:
	PUSH	B
	NOP
	NOP
	POP		B
	RET

; Rotina que espera 50 us
DELAY_50uS:
	PUSH	B
	MOV		B, #20
	DJNZ 	B, $
	POP 	B
	RET

; Rotina que espera 100 us
DELAY_100uS:
	PUSH	B
	MOV		B, #45
	DJNZ 	B, $
	POP 	B
	RET

; Rotina que espera 4.1 ms
DELAY_4MS:
	PUSH	B
	MOV		B, #40
DELAY_4MS_LOOP1:
	CALL DELAY_100uS
	DJNZ 	B, DELAY_4MS_LOOP1
	MOV		B, #4
DELAY_4MS_LOOP2:
	DJNZ 	B, DELAY_4MS_LOOP2
	POP		B
	RET

; Rotina que espera 15 ms
DELAY_15MS:
	PUSH	B
	MOV		B, #147
DELAY_15MS_LOOP:
	CALL 	DELAY_100uS
	DJNZ 	B, DELAY_15MS_LOOP
	POP		B
	RET

END
