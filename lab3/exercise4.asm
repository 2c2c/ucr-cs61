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
    LD R5, DEC_0
    LD R6, PTR
    DOWHILE
        GETC
        ADD R4,R0,-x0A
        OUT
        BRz FINISHED 
        STR R0, R6, #0
        ADD R6,R6,1
        ADD R5,R5,#-1
        BR DOWHILE
    FINISHED
   ; after enter pressed,
   ; give it null terminator
    LD R0,DEC_0
    STR R0, R6, #0
    LD R6, PTR
    WHILENONULL
        LDR R0,R6,#0
        OUT
        ADD R6,R6,#1
        ADD R0,R0,#0
        BRnp WHILENONULL
    HALT

    ;data
    DEC_0    .FILL #0
    PROMPT .STRINGZ "type a lot of chars \n"
    PTR     .FILL   x4000
    .end
