ORG 0000H
JMP INICIO

INICIO:
MOV A,#0FFH

MOV DPTR,#111110011111B
MOVC A, @A+DPTR

CJNE A,#0FFH,NAOf
MOV P1,#01H
JMP END
NAOf:
MOV P1,#0AAH
JMP END


END:
JMP $