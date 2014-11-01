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
    ;prompt
    ;invalid input brings you back to the top
    ERROR
    
    LEA R0,PROMPT
    PUTS

    LD R2,POINTER
    LD R5, DEC_5
    LD R3,MINUSSIGN
    GETC
    OUT
    ;the input is either + - enter or a normal input
    ;each has to be handled specifically
    
    ;checking if R0 was -
    NOT R0,R0
    ADD R0,R0,#1
    ADD R6,R0,R3
    BRnp MINUSCASE
    ;checking if R0 was +
    LD R3 PLUSSIGN
    ADD R6,R0,R3
    BRnp PLUSCASE
    ;otherwise proceed
    BR PROCEED

    MINUSCASE
        LD R6,MINUS_FLAG
        IN_WHILE
    PLUSCASE
        IN_WHILE

    PROCEED
    IN_WHILE
        ;enter
        LD R3,ENTER
        ADD R6,R0,R3
        BRnp ENTERCASE
        ;if it isnt + - or enter check if the value is >9 or <0
        ADD R3,R0,UPPER_LIM
        BRp ERROR
        ADD R3,R0,LOWER_LIM
        BRn ERROR

        STR R0,R2, #0
        ADD R2,R2,#1
        ADD R5,R5,#-1
    BRp IN_WHILE
    ;the enter case skips to adding a null terminator
    ;all cases procedurally get here after 5 number max is hit
    ENTERCASE
        LD R0,DEC_0
        STR R0,R6,#0
            

    LD R5, DEC_5
    LD R2, POINTER
    LD R3, DEC_0
    ;calculation loop
    LDR R1,R2,#0
    ADD R2,R2,#1
    CALC_WHILE
        ;mult by 10
        ;store mult by 2 and add it to mult by 8
        ADD R1,R1,R1
        ADD R3,R1,#0
        ADD R3,R3,R3
        ADD R3,R3,R3
        ADD R1,R1,R3
        ;add the loading at the end of loop so we
        ;can escape before multiplying 
        LDR R1,R2,#0
        ADD R2,R2,#1
        ADD R1,R1,#0
        BRnp CALC_WHILE

HALT

;DATA
POINTER .FILL x4000
DEC_5 .FILL #5
PROMPT .STRINGZ "Input 16bit int"
MINUSSIGN .FILL '-'
PLUSSIGN .FILL x2B
MINUS_FLAG .FILL #1
ENTER .FILL xA
DEC_0 .FILL #0
UPPER_LIM .FILL x-3A
LOWER_LIM .FILL x-30
;REMOTE 
.orig x4000
ARRAY .BLKW #6
.end
