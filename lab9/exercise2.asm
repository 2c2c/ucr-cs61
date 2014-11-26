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

LD R1,PTR_BEGIN
LD R2,PTR_TOP
LD R3,CAPACITY

LD R0,TEST_VAL
LD R4,PTR_STACK_PUSH
JSRR R4

LD R0,TEST_VAL2
LD R4,PTR_STACK_PUSH
JSRR R4

LD R0,TEST_VAL3
LD R4,PTR_STACK_PUSH
JSRR R4

LD R4,PTR_STACK_POP
JSRR R4
OUT

LD R4,PTR_STACK_POP
JSRR R4
OUT

LD R4,PTR_STACK_POP
JSRR R4
OUT

HALT

TEST_VAL .FILL 'a'
TEST_VAL2 .FILL 'b'
TEST_VAL3 .FILL 'c'
PTR_BEGIN .FILL x4000
PTR_TOP .FILL x4000
CAPACITY .FILL #10
PTR_STACK_PUSH .FILL x3200
PTR_STACK_POP  .FILL x3400
.orig x4000
ARRAY .BLKW #10

;-------------------------------------------------------------------------------
; Subroutine: SUB_STACK_PUSH 
; Parameter (R0): The value to push onto the stack 
; Parameter (R1): stack_addr: A pointer to the beginning of the stack 
; Parameter (R2): top: A pointer to the next place to PUSH an item 
; Parameter (R3): capacity: The number of additional items the stack can hold 
; Postcondition: The subroutine has pushed (R0) onto the stack. If an overflow 
;                 occurred, the subroutine has printed an overflow error message 
;                 and terminated. 
; Return Value: R2 ← updated top value 
;               R3 ← updated capacity value 
;-------------------------------------------------------------------------------
.orig x3200
SUB_STACK_PUSH

ST R7,R7_BACKUP_3200

ADD R3,R3,#0
BRz CAPACITYFULL_3200
BR PROCEED_3200
;output error message and jump to the end
CAPACITYFULL_3200
  LEA R0,MSG_OVERFLOW
  PUTS
BR END_3200

;normal case 
PROCEED_3200
;store contents to stack
STR R0,R2,#0

;increment top
ADD R2,R2,#1

;decrement capacity
ADD R3,R3,#-1

END_3200


LD R7,R7_BACKUP_3200
RET

R7_BACKUP_3200 .BLKW #1


;------------------------------------------------------------------------------------------------
; Subroutine: SUB_STACK_POP 
; Parameter (R1): stack_addr: A pointer to the beginning of the stack 
; Parameter (R2): top: A pointer to the item to POP 
; Parameter (R3): capacity: The # of additional items the stack can hold 
; Postcondition: The subroutine has popped MEM[top] off of the stack. 
;                If an underflow occurred, the subroutine has printed an 
;                underflow error message and terminated. 
; Return Value: R0 ← value popped off of the stack 
;               R2 ← updated top value 
;               R3 ← updated capacity value 
;------------------------------------------------------------------------------------------------
.orig x3400
SUB_STACK_POP

ST R7,R7_BACKUP_3400

;load value from top into target return register
LDR R0,R2,#0

;decrement top
ADD R2,R2,#-1

;increment capacity
ADD R3,R3,#1


LD R7,R7_BACKUP_3400

R7_BACKUP_3200 .BLKW #1
.end
