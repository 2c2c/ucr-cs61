;=================================================
; Name: <Collier, Craig>
; Username: ccoll010
; 
; Lab: <lab 1>
; Lab section: 221
; TA: Bryan Marsh
; 
;=================================================
.orig x3000
; Instructions

    LD R1, VALID_NUM    
    LD R6, ZERO
    ;R6 stores the original val
    ADD R6, R1,#0
SHIFTLEFT
    LD R2,#0
    ADD R1,R1,#0
    BRnz NEG_CASE
    POS_CASE
    POS_DIVIDELOOP
        ADD R2,R2,#1
        ADD R1,R1,#-2
        BRp POS_DIVIDELOOP
;    
    NEG_CASE
    NEG_DIVIDELOOP
        ADD R2,R2,#1
        ADD R1,R1,#2
        BRn NEG_DIVIDELOOP

;; remote data
.end

LEADINGONE  .FILL b1000000000000000
ZERO        .FILL   #0
VALID_NUM   .FILL   xF
