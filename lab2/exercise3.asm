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
    LD R5, DEC_65
    LD R6, HEX_41
    LDR R3, R5, #0
    LDR R4, R6, #1
    ADD R3, R3, #1
    ADD R4, R4, #1
    STR R3, R5, #0
    STR R3, R6, #0

;data
	DEC_65 .FILL x4000
	HEX_41 .FILL x4001
;; remote data
	.orig x4000
	NEW_DEC_65 .FILL #65
	NEW_HEX_41 .FILL x41
.end
