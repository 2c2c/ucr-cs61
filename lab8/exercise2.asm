;=================================================
; Name: <Collier, Craig>
; Username: ccoll010
; 
; lab: lab8
; Lab section: 23
; TA: Bryan Marsh
; 
;=================================================

;=================================================
; main
;=================================================
.orig x3000
  


HALT


;-----------------------------------------------------------------------------------------------
; Subroutine: SUB_PRINT_OPCODES
; Parameters: None
; Postcondition: The subroutine has printed out a list of every LC3 instruction
; and corresponding opcode in the following format:
; ADD = 0001
; AND = 0101
; BR = 0000
; ...
; Return Value: None
;-----------------------------------------------------------------------------------------------
.orig x3200
SUB_PRINT_OPCODES
ST R7,R7_BACKUP_3200




PTR_NUM x3600
PTR_OP x3800
LD R7,R7_BACKUP_3200
RET

.orig x3600
ADD1NUM .FILL #1
ADD2NUM .FILL #1
AND1NUM .FILL #5
AND2NUM .FILL #5
BRNUM .FILL #0
JMPNUM .FILL #12
JSRNUM .FILL #8
JSRRNUM .FILL #8
LDNUM .FILL #12
LDINUM .FILL #10
LDRNUM .FILL #6
LEANUM .FILL #14
NOTNUM .FILL #9
RETNUM .FILL #12
RTINUM .FILL #8
STNUM .FILL #3
STINUM .FILL #11
STRNUM .FILL #7
TRAPNUM .FILL #15

.orig x3800
ADD1OP .stringz "ADD"
ADD2OP .stringz "ADD"
AND1OP .stringz "AND"
AND2OP .stringz "AND"
BROP .stringz "BR"
JMPOP .stringz "JMP"
JSROP .stringz "JSR"
JSRROP .stringz "JSRR"
LDOP .stringz "LD"
LDIOP .stringz "LDI"
LDROP .stringz "LDR"
LEAOP .stringz "LEA"
NOTOP .stringz "NOT"
RETOP .stringz "RET"
RTIOP .stringz "RTI"
STOP .stringz "ST"
STIOP .stringz "STI"
STROP .stringz "STR"
TRAPOP .stringz "TRAP"
ENDSTRINGZ_3200 .FILL "-1"
R7_BACKUP_3200 .BLKW "#1"
;-----------------------------------------------------------------------------------------------
; Subroutine: SUB_AN_OP
; Parameters: R1
; Postcondition: Given a number print its binary representation
; Return Value: None
;-----------------------------------------------------------------------------------------------
.orig x3400
SUB_AN_OP

ST R0,R0_BACKUP_3400
ST R1,R1_BACKUP_3400
ST R2,R2_BACKUP_3400
ST R3,R3_BACKUP_3400
ST R7,R7_BACKUP_3400


LD R2,FRONTBIT_3400
LD R3,ASCII_OFFSET_3400
AND R0,R1,R2
ADD R0,R0,R3
OUT
AND R0,R1,R2
ADD R0,R0,R3
OUT
AND R0,R1,R2
ADD R0,R0,R3
OUT
AND R0,R1,R2
ADD R0,R0,R3
OUT

LD R0,R0_BACKUP_3400
LD R1,R1_BACKUP_3400
LD R2,R2_BACKUP_3400
LD R3,R3_BACKUP_3400
LD R7,R7_BACKUP_3400
RET

R7_BACKUP_3400 .BLKW "#1"

ASCII_OFFSET_3400 .FILL 'x30'
FRONTBIT_3400 .FILL #16
