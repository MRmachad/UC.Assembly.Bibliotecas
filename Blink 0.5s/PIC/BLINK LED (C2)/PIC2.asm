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
 #define		led			PORTB,RB1			;LED 1 ligado em RB1

                       
                             
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
				bank0								;seleciona o banco 0 de memória (padrão do RESET)
				movlw		H'FD'				;W = B'11111101'
				movwf		PORTB				;LEDs iniciam desligados
				
loop:											;Loop infinito

				bsf			led					;liga LED
				call		delay500ms			;chama sub rotina
				bcf			led					;desliga LED
				call		delay500ms			;chama sub rotina

				goto		loop				;volta para label loop
				
delay500ms:
				movlw		D'250'				;Move o valor para W
				movwf		H'0C'
auxGeral:
				
			
				
				movlw		D'250'				;	
				movwf		H'0D'				;2us
				
aux:			
				nop		
				decfsz		H'0D'
				GOTO		aux					;+1000us
			
				
				movlw		D'250'				
				movwf		H'0D'				
				
aux1:			
				nop
				decfsz		H'0D'
				GOTO		aux1				;+1002us
				
				decfsz		H'0C'
				GOTO		auxGeral			; 250 * (3 + 2004 )= 501,750 +2 do mov 0C
				
				return
				
				end