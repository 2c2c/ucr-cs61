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
    LD R5, DATA_PTR
    LDR R3, R5, #0
    LDR R4, R5, #1
    ADD R3, R3, #1
    ADD R4, R4, #1
    STR R3, R5, #0
    STR R4, R5, #1
    HALT

    ;data
	DATA_PTR .FILL x4000

    ;remote data
	.orig x4000
	NEW_DEC_65 .FILL #65
	NEW_HEX_41 .FILL x41
.end
