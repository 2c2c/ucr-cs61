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
; instr
	LD R0, HEX_61
	LD R1, HEX_1A
WHILE
	PUT R0
	ADD R0, #1, R0
	ADD R1, #-1, R1
	BRp WHILE
ENDWHILE

;data
	HEX_61	.FILL	x61
	HEX_1A	.FILL	x1A
.end
