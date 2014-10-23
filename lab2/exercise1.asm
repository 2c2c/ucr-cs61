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
	LD R3, DEC_65
	LD R4, HEX_41
    HALT

; Data

	DEC_65 .FILL #65
	HEX_41 .FILL x41
.end
