
; LEDs ligados no modo current sourcing:
;
; '0' - apaga
; '1' - acende
;
; Cálculo do Ciclo de Máquina:
;
; Ciclo de máquina = 1/(Freq Cristal / 4) = 1us
;
;  
;  
;


 list		p=16f84A							; microcontrolador utilizado PIC16F84A
  
  
; --- Arquivos incluídos no projeto ---
 #include <p16f84a.inc>							; inclui o arquivo do PIC16F84A  
  
  
; --- FUSE Bits ---
; Cristal oscilador externo 4MHz, sem watchdog timer, com power up timer, sem proteção do código
 __config _XT_OSC & _WDT_OFF & _PWRTE_ON & _CP_OFF
	

; --- Paginação de Memória ---
 #define		bank0		bcf	STATUS,RP0		;Cria um mnemônico para o banco 0 de memória
 #define		bank1		bsf STATUS,RP0		;Cria um mnemônico para o banco 1 de memória
 #define		led			PORTB,RB1			;LED 1 ligado em RB0

                       
                             
; --- Vetor de RESET ---
				org			H'0000'				;Origem no endereço 0000h de memória
				goto		inicio				;Desvia do vetor de interrupção
				
; --- Vetor de Interrupção ---
				org			H'0004'				;Todas as interrupções apontam para este endereço
				retfie							;Retorna de interrupção
				

; --- Programa Principal ---				
inicio:
				bank1
				movlw		H'FD'				;W = B'11111101'
				movwf		TRISB				;TRISB = H'F5' configura RB1 e RB3 como saída
				bank0							;seleciona o banco 0 de memória (padrão do RESET)
				movlw		H'FC'				;W = B'11111101'
				movwf		PORTB				;LEDs iniciam desligados
				
loop:											;Loop infinito

				bsf			led					;liga LED1
				call		delay500ms			;chama sub rotina
				bcf			led					;desliga LED1
				call		delay500ms			;chama sub rotina

				goto		loop				;volta para label loop
				
				
				
; --- Desenvolvimento das Sub-Rotinas ---
 				
				
delay500ms:

				movlw		D'200'				;Move o valor para W
				movwf		H'0C'				;Inicializa a variável tempo0 

												; 4 ciclos de máquina

aux1:
				movlw		D'250'				;Move o valor para W
				movwf		H'0D'				;Inicializa a variável tempo1
	
												; 2 ciclos de máquina

aux2:
				nop								;Gastar 1 ciclo de máquina
				nop
				nop
				nop
				nop
				nop
				nop

				decfsz		H'0D'				;Decrementa tempo1 até que seja igual a zero		
				goto		aux2				;Vai para a label aux2 								

												; 250 x 10 ciclos de máquina = 2500 ciclos

				decfsz		H'0C'				;Decrementa tempo0 até que seja igual a zero
				goto		aux1				;Vai para a label aux1

												; 2 (aux1) + 2500 (aux2) + 3 (dec 0C e goto aux1) = 2505 ciclos de máquina

												; 2505 x 200 = 501000 us

				return							;Retorna após a chamada da sub rotina
				
				
				end								;Final do programa