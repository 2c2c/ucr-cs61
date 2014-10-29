;=================================================
; Name: <Collier, Craig>
; Username: ccoll010
; 
; Lab: <lab 4>
; Lab section: 23
; TA: Bryan Marsh
; 
;=================================================
.orig x3000
LD R1,DEC_1
LD R5,POINTER
LD R4,DEC_10

FOR_EACH
    STR R1,R5,#0
    ADD R5,R5,#1
    ADD R1,R1,R1
    ADD R4,R4,#-1
    BRnp FOR_EACH

LD R5,POINTER
LDR R2,R5,#6

HALT

DEC_1 .FILL #1
DEC_10 .FILL #10
POINTER .FILL x4000
.orig x4000

ARRAY .BLKW #10
.end
