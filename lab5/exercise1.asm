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

;store values in array
INPUT_WHILE
    STR R1,R5,#0
    ADD R5,R5,#1
    ADD R1,R1,R1
    ADD R4,R4,#-1
    BRnp INPUT_WHILE

;array iteration loop
LD R5,DEC_10
LD R2,POINTER
OUTPUT_WHILE
    LDR R1,R2,#0
    LD R6,FOUR
    ; For each element in array
    ; AND to check if it shares its 1
    ; bit with the value. if it does
    ; print 1, else print 0
    LD R3,HIGH_BIT
    ST R2,POINTER
    LD R2,DEC_16

    ;output a 'b'
    LD R0,CHAR_B
    OUT
    ;output contents of actual array value loop 
    
    //SUBROUTINE
    JSR OUTPUT_BINARY_3200
    LD R0,NEWLINE
    OUT
    ADD R5,R5,#-1
    ;refill R2 with pointer
    LD R2,POINTER
    ADD R2,R2,#1
    ST R2,POINTER
    ;zero check
    ADD R5,R5,#0
    BRnp OUTPUT_WHILE
HALT



DEC_1 .FILL #1
DEC_10 .FILL #10
POINTER .FILL x4000
CHAR_B .FILL x62

;vv from assn3 vv
ZERO .FILL x30
ONE .FILL x31
SPACE .FILL x20
FOUR .FILL #4

DEC_16 .FILL #16
HIGH_BIT .FILL x8000
NEWLINE .FILL xA
;^^ from assn3 ^^

.orig x4000

ARRAY .BLKW #10
.end
