;
;  Curso de Assembly para 8051 WR Kits
;
;  Aula 22 - Utilizando a Interrup��o Externa INT0 
;
; Deseja-se programar o servi�o de interrup��o externa no INT0 para o microcontrolador AT89S51:
;
; - INT0 em baixa prioridade, sens�vel � borda 
; - Quando houver borda de descida complementar o PORT0 no servi�o de interrup��o
;
; www.wrkits.com.br | facebook.com/wrkits | youtube.com/user/canalwrkits
;
; Autor: Eng. Wagner Rambo   |   Data: Outubro de 2015
;

 ; --- Vetor da RESET ---
 
         org     0000h           ;origem no endere�o 0000h de mem�ria
         ajmp    inicio          ;desvia das interrup��es
 
 ; --- Rotina de Interrup��o INT0 ---
 
         org     0003h           ;endere�o da interrup��o do INT0
         cpl     a               ;complementa acc
         mov     P0,a            ;move conte�do do acumulador para PORT P0
         
         reti                    ;retorna da interrup��o

 
 ; --- Final das Rotinas de Interrup��o ---
 
 
 ; --- Configura��es Iniciais ---
 inicio:
         mov     a, #00h         ;move constante 00h para acc
         mov     P0,a            ;configura PORT P0 como sa�da
         mov     a,#0FFh         ;move constante FFh para acc
         mov     P0,a            ;inicializa PORT P0
         mov     a,#10000001b    ;move a constante 10000001b para acc
         mov     ie,a            ;Habilita interrup��o INT0
         mov     a,#00000000b    ;move a constante 00000000b para acc
         mov     ip,a            ;INT0 como baixa prioridade
         mov     a,#00000001b    ;move a constante 00000001b para acc
         mov     tcon,a          ;INT0 como sens�vel � borda
         mov     a,#3Ch          ;move constante 3Ch (0011 1100 b) para acc

         ajmp    $               ;Loop


         end                     ;Final do programa 











