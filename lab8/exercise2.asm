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

LD R0,PTR_PRINTOPS_MAIN
JSRR R0

HALT

PTR_PRINTOPS_MAIN .FILL x3200

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

ST R0,R0_BACKUP_3200
ST R1,R1_BACKUP_3200
ST R2,R2_BACKUP_3200
ST R3,R3_BACKUP_3200
ST R4,R4_BACKUP_3200
ST R7,R7_BACKUP_3200

LD R2,PTR_NUM
LD R3,PTR_OP

FOREACHOP_3200
  ;output name of OP
  FOREACHCHAR_3200
    LDR R0,R3,#0
    BRz END_3200
    BRn ENDFULL_3200
    OUT
    ADD R3,R3,#1
    BR FOREACHCHAR_3200
  END_3200
  ADD R3,R3,#1

  ;output ' = '
  LEA R0,EQUALS
  PUTS


  ;output the opcode in binary
  LD R4,PTR_NUM_FN
  LDR R1,R2,#0
  JSRR R4
  ADD R2,R2,#1

  ;newline
  LD R0,NEWLINE
  OUT
  BR FOREACHOP_3200
ENDFULL_3200



LD R0,R0_BACKUP_3200
LD R1,R1_BACKUP_3200
LD R2,R2_BACKUP_3200
LD R3,R3_BACKUP_3200
LD R4,R4_BACKUP_3200
LD R7,R7_BACKUP_3200
RET

NEWLINE .FILL '\n'
EQUALS .stringz " = "
PTR_NUM_FN .FILL x3400
PTR_NUM .FILL x3600
PTR_OP .FILL x3800

R0_BACKUP_3200 .BLKW #1
R1_BACKUP_3200 .BLKW #1
R2_BACKUP_3200 .BLKW #1
R3_BACKUP_3200 .BLKW #1
R4_BACKUP_3200 .BLKW #1
R7_BACKUP_3200 .BLKW #1

.orig x3600
ADDNUM .FILL #1
ANDNUM .FILL #5
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
ADDOP .stringz "ADD"
ANDOP .stringz "AND"
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
ENDSTRINGZ_3200 .FILL #-1

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

;and input with ...1000
;output the result converted to ascii
AND R0,R1,R2
BRnp FOUNDBIT_1
LD R0,ZERO_3400
OUT
BR ZEROBIT_1
FOUNDBIT_1
LD R0,ONE_3400
OUT
ZEROBIT_1
;double each itr and repeat
ADD R1,R1,R1
AND R0,R1,R2
BRnp FOUNDBIT_2
LD R0,ZERO_3400
OUT
BR ZEROBIT_2
FOUNDBIT_2
LD R0,ONE_3400
OUT
ZEROBIT_2

ADD R1,R1,R1
AND R0,R1,R2
BRnp FOUNDBIT_3
LD R0,ZERO_3400
OUT
BR ZEROBIT_3
FOUNDBIT_3
LD R0,ONE_3400
OUT
ZEROBIT_3

ADD R1,R1,R1
AND R0,R1,R2
BRnp FOUNDBIT_4
LD R0,ZERO_3400
OUT
BR ZEROBIT_4
FOUNDBIT_4
LD R0,ONE_3400
OUT
ZEROBIT_4


LD R0,R0_BACKUP_3400
LD R1,R1_BACKUP_3400
LD R2,R2_BACKUP_3400
LD R3,R3_BACKUP_3400
LD R7,R7_BACKUP_3400
RET


ASCII_OFFSET_3400 .FILL x30
ZERO_3400 .FILL '0'
ONE_3400 .FILL '1'
FRONTBIT_3400 .FILL #8

R0_BACKUP_3400 .BLKW #1
R1_BACKUP_3400 .BLKW #1
R2_BACKUP_3400 .BLKW #1
R3_BACKUP_3400 .BLKW #1
R4_BACKUP_3400 .BLKW #1
R7_BACKUP_3400 .BLKW #1



.end
