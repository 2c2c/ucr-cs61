;=================================================
; Name: <Collier, Craig>
; Username: ccoll010
; 
; Lab: <lab 3>
; Lab section: 23
; TA: Bryan Marsh
; 
;=================================================
.orig x3000
    ; Instructions
    LEA R0, PROMPT
    PUTS
    LEA R6, ARRAY
    LD R5, DEC_10
    DO_WHILE
        GETC
        OUT
        STR R0, R6, #0
        ADD R6,R6,1
        ADD R5,R5,#-1
    BRp DO_WHILE
    HALT

    ;data
    DEC_10 .FILL #10
    ARRAY .BLKW #10
    PROMPT .STRINGZ "type 10 chars"
.end
