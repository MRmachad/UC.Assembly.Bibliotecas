;
;  Curso de Assembly para 8051 WR Kits
;
;  Aula 22 - Utilizando a Interrupção Externa INT0 
;
; Deseja-se programar o serviço de interrupção externa no INT0 para o microcontrolador AT89S51:
;
; - INT0 em baixa prioridade, sensível à borda 
; - Quando houver borda de descida complementar o PORT0 no serviço de interrupção
;
; www.wrkits.com.br | facebook.com/wrkits | youtube.com/user/canalwrkits
;
; Autor: Eng. Wagner Rambo   |   Data: Outubro de 2015
;

 ; --- Vetor da RESET ---
 
         org     0000h           ;origem no endereço 0000h de memória
         ajmp    inicio          ;desvia das interrupções
 
 ; --- Rotina de Interrupção INT0 ---
 
         org     0003h           ;endereço da interrupção do INT0
         cpl     a               ;complementa acc
         mov     P0,a            ;move conteúdo do acumulador para PORT P0
         
         reti                    ;retorna da interrupção

 
 ; --- Final das Rotinas de Interrupção ---
 
 
 ; --- Configurações Iniciais ---
 inicio:
         mov     a, #00h         ;move constante 00h para acc
         mov     P0,a            ;configura PORT P0 como saída
         mov     a,#0FFh         ;move constante FFh para acc
         mov     P0,a            ;inicializa PORT P0
         mov     a,#10000001b    ;move a constante 10000001b para acc
         mov     ie,a            ;Habilita interrupção INT0
         mov     a,#00000000b    ;move a constante 00000000b para acc
         mov     ip,a            ;INT0 como baixa prioridade
         mov     a,#00000001b    ;move a constante 00000001b para acc
         mov     tcon,a          ;INT0 como sensível à borda
         mov     a,#3Ch          ;move constante 3Ch (0011 1100 b) para acc

         ajmp    $               ;Loop


         end                     ;Final do programa 











