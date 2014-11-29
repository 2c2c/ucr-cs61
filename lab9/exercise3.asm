;=================================================
; Name: <Collier, Craig>
; Username: ccoll010
; 
; lab: lab9
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

LEA R0,MSG_PROMPT
PUTS
;push first num
LD R5,ASCII_OFFSET_MAIN
GETC
OUT
ADD R0,R0,R5
LD R4,PTR_STACK_PUSH
JSRR R4
;ignore a space
GETC
OUT
;push second num

GETC
OUT
ADD R0,R0,R5
LD R4,PTR_STACK_PUSH
JSRR R4

;ignore a space
GETC
OUT

;push *
GETC
OUT
LD R4,PTR_STACK_PUSH
JSRR R4

;newline for output
LD R0,ENTER_MAIN
OUT

LD R4,PTR_MULT
JSRR R4

LD R4,PTR_STACK_POP
JSRR R4
ADD R6,R0,#0

LD R4,PTR_PRINT
JSRR R4
HALT

TEST_VAL .FILL #8
TEST_VAL2 .FILL #9
TEST_VAL3 .FILL '*'
PTR_BEGIN .FILL x4000
PTR_TOP .FILL x4000
CAPACITY .FILL #10
PTR_STACK_PUSH .FILL x3200
PTR_STACK_POP .FILL x3400
PTR_MULT .FILL x3600
PTR_PRINT .FILL x4800

ENTER_MAIN .FILL '\n'
ASCII_OFFSET_MAIN .FILL -x30
MSG_PROMPT .STRINGZ "Insert 1digit mult e.g. '3 4 *'\n"
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
MSG_OVERFLOW .STRINGZ "Overflow!\n"


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

;Flip Top and subtract with beginning address
;if zero, top is at first position and we're trying to pop
NOT R0,R2
ADD R0,R0,#1
ADD R0,R1,R0
BRz CAPACITYEMPTY_3400
BR NORMAL_3400


CAPACITYEMPTY_3400
    LEA R0,MSG_UNDERFLOW
    PUTS
    BR END_3400
    
NORMAL_3400

;decrement top
ADD R2,R2,#-1

;load value from top into target return register
LDR R0,R2,#0


;increment capacity
ADD R3,R3,#1


END_3400
LD R7,R7_BACKUP_3400
RET

R7_BACKUP_3400 .BLKW #1
MSG_UNDERFLOW .STRINGZ "Underflow!\n"

;------------------------------------------------------------------------------------------------
; Subroutine: SUB_RPN_MULTIPLY 
; Parameter (R1): stack_addr 
; Parameter (R2): top 
; Parameter (R3): capacity 
; Postcondition: The subroutine has popped off the top two values of the stack, 
;                multiplied them together, and pushed the resulting value back 
;                onto the stack. 
; Return Value: R2 ← updated top value 
;               R3 ← updated capacity value 
;------------------------------------------------------------------------------------------------
.orig x3600
SUB_RPN_MULTIPLY


ST R0,R0_BACKUP_3600
ST R1,R1_BACKUP_3600
ST R7,R7_BACKUP_3600


LD R4,PTR_POP_3600
;pop the *
JSRR R4
;pop the 2 numbers into proper registers
JSRR R4
ADD R5,R0,#0
JSRR R4
ADD R6,R0,#0

;mult
LD R4,PTR_MULT_3600
JSRR R4

;push result back into stack
ADD R0,R6,#0
LD R4,PTR_PUSH_3600
JSRR R4

LD R0,R0_BACKUP_3600
LD R1,R1_BACKUP_3600
LD R7,R7_BACKUP_3600

RET

R0_BACKUP_3600 .BLKW #1
R1_BACKUP_3600 .BLKW #1
R2_BACKUP_3600 .BLKW #1
R3_BACKUP_3600 .BLKW #1
R7_BACKUP_3600 .BLKW #1

PTR_PUSH_3600 .FILL x3200
PTR_POP_3600 .FILL x3400
PTR_MULT_3600 .FILL x4400
PTR_PRINT_3600 .FILL x4800



;=================================================
; SUB_MULT
; input:         R1 R2 R3
; postcondition: Mult R1 R2 and apply negative condition R3. If an overflow occurs
;                change R4 flag which will notify main to exit
; output:        R6 R4
;=================================================

.orig x4400
SUB_MULT
ST R0,R0_BACKUP_4400
ST R1,R1_BACKUP_4400
ST R2,R2_BACKUP_4400
ST R3,R3_BACKUP_4400
ST R5,R5_BACKUP_4400
ST R7,R7_BACKUP_4400

;ghetto R1,R2 <- R5,R6
ADD R1,R5,#0
ADD R2,R6,#0
;ghetto force neg flag to 0 since im stealing this fn from somewhere else
; no need for neg flag
AND R3,R3,#0
AND R6,R6,#0

LD R5,FRONT_BIT_4400
;if there's a zero skip over the loop
ADD R2,R2,#0
BRz END_WHILE_4400
BR WHILE_4400

WHILE_4400
  ;repeatedly add
  ADD R6,R6,R1
  ADD R2,R2,#-1
  ;if the front bit changes to a 1 overflow has occured
  AND R4,R6,R5
  BRnp OVERFLOW_4400
  ADD R2,R2,#0
  BRp WHILE_4400
END_WHILE_4400


;if neg flag is set flip the result
ADD R3,R3,#0
BRz NORMALCASE_4400
BR NEGCASE_4400

NEGCASE_4400
    NOT R6,R6
    ADD R6,R6,#1
NORMALCASE_4400
BR NORMAL_EXIT_4400


OVERFLOW_4400
LEA R0,OVERFLOW_NOTICE
PUTS

NORMAL_EXIT_4400

;fin  
;store
LD R0,R0_BACKUP_4400
LD R1,R1_BACKUP_4400
LD R2,R2_BACKUP_4400
LD R3,R3_BACKUP_4400
LD R5,R5_BACKUP_4400
LD R7,R7_BACKUP_4400

RET




R0_BACKUP_4400 .BLKW #1
R1_BACKUP_4400 .BLKW #1
R2_BACKUP_4400 .BLKW #1
R3_BACKUP_4400 .BLKW #1
R5_BACKUP_4400 .BLKW #1
R7_BACKUP_4400 .BLKW #1
FRONT_BIT_4400 .FILL x8000
OVERFLOW_NOTICE .STRINGZ " = Overflow!\n"

;=================================================
; SUB_PRINT_NUM
; input:         R6
; postcondition: Given literal number input, outputs character form
; output:        
;=================================================
.orig x4800
SUB_PRINT_NUM

ST R0,R0_BACKUP_4800
ST R1,R1_BACKUP_4800
ST R6,R6_BACKUP_4800
ST R2,R2_BACKUP_4800
ST R3,R3_BACKUP_4800
ST R4,R4_BACKUP_4800
ST R7,R7_BACKUP_4800

;flip input if it is negative, apply flag to output minus sign if necessary
ADD R6,R6,#0
BRz ZERO_CASE_4800
BRn NEG_CASE_4800
BR NORM_CASE_4800

ZERO_CASE_4800
    LD R4, ASCII_TOCHAR_4800
    ADD R0,R6,R4
    OUT
    BR SKIP_4800_5
NEG_CASE_4800
    LD R0,MINUSCHAR_4800
    OUT
    NOT R6,R6
    ADD R6,R6,#1
NORM_CASE_4800

;store in R0, convert to ascii and output front digit
LD R0,DEC_10000_4800
AND R3,R3,#0


;this could very clearly have been rolled into a loop
;the use for it started much simpler and simply pasting it 5 times for
;output was actually faster than constructing a loop
;complexity has built up and adding to it made more sense than fixing it

;flag R1 signifies there's been a nonzero number output
;this manages leading zeroes
AND R1,R1,#0

DECR_10000_4800
    ADD R2,R6,#0
    ADD R2,R2,R0
    BRn DONE_10000_4800
    ADD R3,R3,#1
    ADD R6,R2,#0
    BR DECR_10000_4800
DONE_10000_4800
    LD R4, ASCII_TOCHAR_4800
    ADD R0,R3,R4
    LD R5,ASCII_TONUM_4800
    ADD R5,R5,R0
    ADD R5,R5,R1
    BRz SKIP_4800_1
    ADD R1,R1,#1
    OUT
SKIP_4800_1

LD R0,DEC_1000_4800
AND R3,R3,#0
DECR_1000_4800
    ADD R2,R6,#0
    ADD R2,R2,R0
    BRn DONE_1000_4800
    ADD R3,R3,#1
    ADD R6,R2,#0
    BR DECR_1000_4800
DONE_1000_4800
    LD R4, ASCII_TOCHAR_4800
    ADD R0,R3,R4
    LD R5,ASCII_TONUM_4800
    ADD R5,R5,R0
    ADD R5,R5,R1
    BRz SKIP_4800_2 
    ADD R1,R1,#1
    OUT

SKIP_4800_2
LD R0,DEC_100_4800
AND R3,R3,#0
DECR_100_4800
    ADD R2,R6,#0
    ADD R2,R2,R0
    BRn DONE_100_4800
    ADD R3,R3,#1
    ADD R6,R2,#0
    BR DECR_100_4800
DONE_100_4800
    LD R4, ASCII_TOCHAR_4800
    ADD R0,R3,R4
    LD R5,ASCII_TONUM_4800
    ADD R5,R5,R0
    ADD R5,R5,R1
    BRz SKIP_4800_3
    ADD R1,R1,#1
    OUT


SKIP_4800_3
LD R0,DEC_10_4800
AND R3,R3,#0
DECR_10_4800
    ADD R2,R6,#0
    ADD R2,R2,R0
    BRn DONE_10_4800
    ADD R3,R3,#1
    ADD R6,R2,#0
    BR DECR_10_4800
DONE_10_4800
    LD R4, ASCII_TOCHAR_4800
    ADD R0,R3,R4
    LD R5,ASCII_TONUM_4800
    ADD R5,R5,R0
    ADD R5,R5,R1
    BRz SKIP_4800_4
    ADD R1,R1,#1
    OUT

SKIP_4800_4
LD R0,DEC_1_4800
AND R3,R3,#0
DECR_1_4800
    ADD R2,R6,#0
    ADD R2,R2,R0
    BRn DONE_1_4800
    ADD R3,R3,#1
    ADD R6,R2,#0
    BR DECR_1_4800
DONE_1_4800
    LD R4, ASCII_TOCHAR_4800
    ADD R0,R3,R4
    LD R5,ASCII_TONUM_4800
    ADD R5,R5,R0
    ADD R5,R5,R1
    BRz SKIP_4800_5
    ADD R1,R1,#1
    OUT
SKIP_4800_5

;restore
LD R0,R0_BACKUP_4800
LD R1,R1_BACKUP_4800
LD R6,R6_BACKUP_4800
LD R2,R2_BACKUP_4800
LD R3,R3_BACKUP_4800
LD R4,R4_BACKUP_4800
LD R7,R7_BACKUP_4800

RET


R0_BACKUP_4800 .BLKW #1
R1_BACKUP_4800 .BLKW #1
R6_BACKUP_4800 .BLKW #1
R2_BACKUP_4800 .BLKW #1
R3_BACKUP_4800 .BLKW #1
R4_BACKUP_4800 .BLKW #1
R7_BACKUP_4800 .BLKW #1

ASCII_TOCHAR_4800 .FILL x30
ASCII_TONUM_4800 .FILL -x30
MINUSCHAR_4800 .FILL '-'
DEC_10000_4800 .FILL #-10000
DEC_1000_4800 .FILL #-1000
DEC_100_4800 .FILL #-100
DEC_10_4800 .FILL #-10
DEC_1_4800 .FILL #-1

.end
