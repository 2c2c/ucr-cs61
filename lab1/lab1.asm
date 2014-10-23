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
    LD R1, DEC_0
    LD R2, DEC_12
    LD R3, DEC_6

    DO_WHILE
        ADD R1, R1, R2
        ADD R3, R3, #-1
        BRp DO_WHILE
    END_DO_WHILE

    HALT
; data
    DEC_0   .FILL   #0
    DEC_12  .FILL   #12
    DEC_6   .FILL   #6
.end
