;=================================================
; Name: <Collier, Craig>
; Username: ccoll010
; 
; Lab: <lab 2>
; Lab section: 23
; TA: Bryan Marsh
; 
;=================================================

.orig x3000
    ; Instructions
    
    ; point to string
    LEA R1, hello
    NONZERO
        ;load element R1 points at in R0
        LDR R0,R1,#0
        ADD R0,R0,#0
        BRz END
        OUT
        ; increment next string element
        ADD R1,R1,#1
        BR NONZERO
    END
    HALT
    ; Data
    hello .STRINGZ "Hello"
.end
