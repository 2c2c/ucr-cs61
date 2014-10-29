;=================================================
; Name: <Collier, Craig>
; Username: ccoll010
; 
; Assignment: assn4 
; Lab section: 23
; TA: Bryan Marsh
; 
;=================================================
.orig x3000
    ; Instructions

    LEA R0,PROMPT
    PUTS

    LD R2,POINTER
    LDR R1, R2, #0
    LD R5, DEC_5
    LD R3,MINUSSIGN
    LD R4,ENTER
    IN_WHILE
    ;handle minussign
        GETC
        OUT
        NOT R0,R0
        ADD R0,R0,#1
        ADD R6,R0,R3
        BRnp MINUSCASE
        ADD R6,R0,R4
        BRnp ENTERCASE
        BR NORMALCASE
        MINUSCASE
            LD R6,MINUS_FLAG
            ADD R5,R5,#-1    
            IN_WHILE

        NORMALCASE
        STR R0,R2, #0
        ADD R2,R2,#1
        ADD R5,R5,#-1
    BRp IN_WHILE

        ENTERCASE
            LD R0,DEC_0
            STR R0,R6,#0
    OUTLOOP
            

    LD R5, DEC_5
    LD R2, POINTER
    LD R3, DEC_0
    OUT_WHILE
        LDR R1,R2,#0
        ADD R2,R2,#1
        ADD R3,R1,#0


HALT

;DATA
POINTER .FILL x4000
DEC_5 .FILL #5
PROMPT .STRINGZ "Input 16bit int"
MINUSSIGN .FILL '-'
MINUS_FLAG .FILL #1
ENTER .FILL xA
DEC_0 .FILL #0
;REMOTE 
.orig x4000
ARRAY .BLKW #5
.end
