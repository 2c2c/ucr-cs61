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
	LDI R3, DEC_65
	LDI R4, HEX_41
	ADD R3, R3, #1 
	ADD R4, R4, #1
	STI R3, DEC_65
	STI R4, HEX_41
    HALT
; Data

	DEC_65 .FILL x4000
	HEX_41 .FILL x4001
;; remote data
	.orig x4000
	NEW_DEC_65 .FILL #65
	NEW_HEX_41 .FILL x41
.end
