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
; instr
	LD R0, HEX_61
	LD R1, HEX_1A
WHILE
	OUT
	ADD R0, R0, #1
	ADD R1, R1, #-1
	BRp WHILE
ENDWHILE

HALT

;data
	HEX_61	.FILL	x61
	HEX_1A	.FILL	x1A
.end
