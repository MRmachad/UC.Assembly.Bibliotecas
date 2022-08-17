
; LEDs ligados no modo current sourcing:
;
; '0' - apaga
; '1' - acende
;
; C�lculo do Ciclo de M�quina:
;
; Ciclo de m�quina = 1/(Freq Cristal / 4) = 1us
;
;  
;  
;


 list		p=16f84A							; microcontrolador utilizado PIC16F84A
  
  
; --- Arquivos inclu�dos no projeto ---
 #include <p16f84a.inc>							; inclui o arquivo do PIC16F84A  
  
  
; --- FUSE Bits ---
; Cristal oscilador externo 4MHz, sem watchdog timer, com power up timer, sem prote��o do c�digo
 __config _XT_OSC & _WDT_OFF & _PWRTE_ON & _CP_OFF
	

; --- Pagina��o de Mem�ria ---
 #define		bank0		bcf	STATUS,RP0		;Cria um mnem�nico para o banco 0 de mem�ria
 #define		bank1		bsf STATUS,RP0		;Cria um mnem�nico para o banco 1 de mem�ria
 #define		led			PORTB,RB1			;LED 1 ligado em RB0

                       
                             
; --- Vetor de RESET ---
				org			H'0000'				;Origem no endere�o 0000h de mem�ria
				goto		inicio				;Desvia do vetor de interrup��o
				
; --- Vetor de Interrup��o ---
				org			H'0004'				;Todas as interrup��es apontam para este endere�o
				retfie							;Retorna de interrup��o
				

; --- Programa Principal ---				
inicio:
				bank1
				movlw		H'FD'				;W = B'11111101'
				movwf		TRISB				;TRISB = H'F5' configura RB1 e RB3 como sa�da
				bank0							;seleciona o banco 0 de mem�ria (padr�o do RESET)
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
				movwf		H'0C'				;Inicializa a vari�vel tempo0 

												; 4 ciclos de m�quina

aux1:
				movlw		D'250'				;Move o valor para W
				movwf		H'0D'				;Inicializa a vari�vel tempo1
	
												; 2 ciclos de m�quina

aux2:
				nop								;Gastar 1 ciclo de m�quina
				nop
				nop
				nop
				nop
				nop
				nop

				decfsz		H'0D'				;Decrementa tempo1 at� que seja igual a zero		
				goto		aux2				;Vai para a label aux2 								

												; 250 x 10 ciclos de m�quina = 2500 ciclos

				decfsz		H'0C'				;Decrementa tempo0 at� que seja igual a zero
				goto		aux1				;Vai para a label aux1

												; 2 (aux1) + 2500 (aux2) + 3 (dec 0C e goto aux1) = 2505 ciclos de m�quina

												; 2505 x 200 = 501000 us

				return							;Retorna ap�s a chamada da sub rotina
				
				
				end								;Final do programa