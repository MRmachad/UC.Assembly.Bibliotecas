;Fazer a leitura de 2 dois botão e acionar o led correspondente caso algum deles estejam ativo e escreve no lcd ambos por um determinado tempo 
	AC1	EQU 	P2.0	
	AC2	EQU 	P2.1	
	LED1	EQU 	P2.2		;
	LED2	EQU 	P2.3		; LEDs em current sink
	ORG	000H
	JMP 	CONFIG

CONFIG:	SETB	AC1
	SETB	AC2
	SETB	LED1
	SETB	LED2

loop:	JB	AC1,AUXLOOP
	CLR	LED1
	;ESCREVE DISPLAY LED1 ATIVADO
	ACALL	DELAY4S
	SETB 	LED1
AUXLOOP:JB	AC2,ENDLOOP
	CLR	LED2
	;ESCREVE DISPLAY LED2 ATIVADO
	ACALL	DELAY8S
	SETB	LED2
ENDLOOP:
	jmp loop
;-------------------------------
delay8s:
	call	delay4s
	call	delay4s
	ret
;-------------------------------
delay4s:
	call	delay1s
	call	delay1s
	call	delay1s
	call	delay1s
	ret	
;-------------------------------
delay1s:                                            	; 2       | ciclos de máquina do mnemônico call
                mov             R7,#0fah                ; 1       | move o valor 250 decimal para o registrador R1
                mov             b,#78h                  ; 2
                nop                                     ; 1
                nop                                     ; 1
                nop                                     ; 1        
aux:
                djnz            b,aux                   ; 2*120
aux1:
                mov             R6,#0f9h                ; 1 x 250 | move o valor 249 decimal para o registrador R2
                nop                                     ; 1 x 250
                nop                                     ; 1 x 250
                nop                                     ; 1 x 250
                nop                                     ; 1 x 250
                nop                                     ; 1 x 250
                nop                                     ; 1 x 250
                nop                                     ; 1 x 250
                nop                                     ; 1 x 250
                nop                                     ; 1 x 250
                nop                                     ; 1 x 250
                nop                                     ; 1 x 250
                nop                                     ; 1 x 250
aux2:           nop                                     ; 1 x 250 x 249 = 62250
                nop                                     ; 1 x 250 x 249 = 62250
                nop                                     ; 1 x 250 x 249 = 62250
                nop                                     ; 1 x 250 x 249 = 62250
                nop                                     ; 1 x 250 x 249 = 62250
                nop                                     ; 1 x 250 x 249 = 62250
                nop                                     ; 1 x 250 x 249 = 62250
                nop                                     ; 1 x 250 x 249 = 62250
                nop                                     ; 1 x 250 x 249 = 62250
                nop                                     ; 1 x 250 x 249 = 62250
                nop                                     ; 1 x 250 x 249 = 62250
                nop                                     ; 1 x 250 x 249 = 62250
                nop                                     ; 1 x 250 x 249 = 62250
                nop                                     ; 1 x 250 x 249 = 62250
                djnz            R6,aux2                 ; 2 x 250 x 249 = 124500     | decrementa o R2 até chegar a zero
                djnz            R7,aux1                 ; 2 x 250                    | decrementa o R1 até chegar a zero
                ret                                     ; 2                          | retorna para a função main
                                                        ;------------------------------------
                                                        ; Total = 500005 us ~~ 500 ms = 0,5 seg
;-------------------------------
END