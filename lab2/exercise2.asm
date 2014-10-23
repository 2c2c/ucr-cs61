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
	LDI R3, DEC_65
	LDI R4, HEX_41
	ADD R3, #1, R3
	ADD R4, #1, R3
	STI R3, DEC_65
	STI R4, HEX_41
; Data

	DEC_65 .FILL x4000
	HEX_41 .FILL x4001
;; remote data
	.orig x4000
	NEW_DEC_65 .FILL #65
	NEW_HEX_41 .FILL x41
.end
