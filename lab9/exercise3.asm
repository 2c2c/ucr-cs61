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

R7_BACKUP_3400 .BLKW #1

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

ST R7,R7_BACKUP_3600



LD R7,R7_BACKUP_3600

R7_BACKUP_3600 .BLKW #1



;=================================================
; SUB_GET_MULT_TARGETS
; input:         None
; postcondition: Uses SUB_NUM_TO_REGISTER twice to get two numbers for multiplying
; output:        R1 R2
;=================================================
.orig x3800
SUB_GET_MULT_TARGETS
;store
ST R0,R0_BACKUP_3800
ST R3,R3_BACKUP_3800
ST R4,R4_BACKUP_3800
ST R5,R5_BACKUP_3800
ST R6,R6_BACKUP_3800
ST R7,R7_BACKUP_3800

;get number 1
LD R0,NUM_TO_REG_PTR
JSRR R0

;store it elsewhere so funciton can be called again
ADD R2,R1,#0

;get number 2
JSRR R0



LD R0,R0_BACKUP_3800
LD R3,R3_BACKUP_3800
LD R4,R4_BACKUP_3800
LD R5,R5_BACKUP_3800
LD R6,R6_BACKUP_3800
LD R7,R7_BACKUP_3800

RET


R0_BACKUP_3800 .BLKW #1
R3_BACKUP_3800 .BLKW #1
R4_BACKUP_3800 .BLKW #1
R5_BACKUP_3800 .BLKW #1
R6_BACKUP_3800 .BLKW #1
R7_BACKUP_3800 .BLKW #1
NUM_TO_REG_PTR .FILL x4000

;modify to an unused reg?
; REG <- NUM_TO_REG
; PUSH <- REG
; PUSH <- REG2
;=================================================
; SUB_NUM_TO_REGISTER
; input:         None
; postcondition: Takes character input and creates literal number value
;                in R1
; output:        R1
;=================================================
.orig x4000
SUB_NUM_TO_REGISTER
    
    ;store
    ST R0,R0_BACKUP_4000
    ST R2,R2_BACKUP_4000
    ST R3,R3_BACKUP_4000
    ST R4,R4_BACKUP_4000
    ST R5,R5_BACKUP_4000
    ST R6,R6_BACKUP_4000
    ST R7,R7_BACKUP_4000
    
    ;begin by skipping over error msg
    BR START
    ;invalid input jumps to back to the beginning
    ERROR
    LEA R0,ERROR_MSG
    PUTS
    ;prompt
    START
    LEA R0,PROMPT
    PUTS

    LD R2,POINTER
    LD R5, DEC_5
    LD R3,MINUSSIGN
    GETC
    OUT
    ;the input is either + - enter or a normal input
    ;each has to be handled specifically
    
    ;checking if R0 was -
    NOT R4,R0
    ADD R4,R4,#1
    ADD R1,R4,R3
    BRz MINUSCASE
    ;checking if R0 was +
    LD R3,PLUSSIGN
    ADD R1,R4,R3
    BRz PLUSCASE
    ;otherwise proceed
    BR PROCEED

    MINUSCASE
        LD R6,MINUS_FLAG
        GETC
        OUT
        BR BEGINLOOP
    PLUSCASE
        GETC
        OUT
        BR BEGINLOOP
    PROCEED
        BR BEGINLOOP
    IN_WHILE
        ;when entering the loop skip getting input
        ;since im handling + - outside of loop
        ;else it would cause errorenous handling
        ;were one to enter 23-344 or something
        GETC
        OUT
        ;starts here first iter
        BEGINLOOP
        ;enter
        LD R3,ENTER
        NOT R4,R0
        ADD R4,R4,#1
        ADD R1,R4,R3
        BRz ENTERCASE
        ;if it isnt + - or enter check if the value is >9 or <0
        LD R4,UPPER_LIM
        ADD R3,R0,R4
        BRp ERROR
        LD R4, LOWER_LIM
        ADD R3,R0,R4
        BRn ERROR

        ;store
        STR R0,R2,#0
        ADD R2,R2,#1
        ADD R5,R5,#-1
    BRp IN_WHILE
    ;the enter case skips to adding a null terminator
    ;all cases procedurally get here after 5 number max is hit
    ENTERCASE
        LD R0,DEC_0
        ;ISSUES HERE
        STR R0,R2,#0
            
    LD R5, DEC_5
    LD R2, POINTER
    LD R3, DEC_0
    ;calculation loop
    LDR R1,R2,#0
    ADD R2,R2,#1
    ;convert ascii to decimal 
    ADD R1,R1,#-12
    ADD R1,R1,#-12
    ADD R1,R1,#-12
    ADD R1,R1,#-12 
    CALC_WHILE
        ;LD into R4, if its a null terminator get out
        LDR R4,R2,#0
        ADD R4,R4,#0
        BRz CALC_DONE
        ADD R2,R2,#1
        ;convert ascii to decimal 
        ADD R4,R4,#-12
        ADD R4,R4,#-12
        ADD R4,R4,#-12
        ADD R4,R4,#-12 
        ;mult by 10
        ;store mult by 2 and add it to mult by 8
        ADD R1,R1,R1
        ADD R3,R1,#0
        ADD R3,R3,R3
        ADD R3,R3,R3
        ADD R1,R1,R3
        ADD R1,R4,R1
        ;add the loading at the end of loop so we
        ;can escape before multiplying 
        BR CALC_WHILE
    CALC_DONE
    ;if negative flag is on 2's compliment to make it negative
    ADD R6,R6,#0
    BRp MAKE_NEGATIVE_4000
    BR KEEP_4000
    MAKE_NEGATIVE_4000
        NOT R1,R1
        ADD R1,R1,#1
    KEEP_4000
    LD R0,ENTER
    OUT

    ;restore
    LD R0,R0_BACKUP_4000
    LD R2,R2_BACKUP_4000
    LD R3,R3_BACKUP_4000
    LD R4,R4_BACKUP_4000
    LD R5,R5_BACKUP_4000
    LD R6,R6_BACKUP_4000
    LD R7,R7_BACKUP_4000
    ;return
    RET

;DATA
R0_BACKUP_4000 .BLKW #1
R1_BACKUP_4000 .BLKW #1
R2_BACKUP_4000 .BLKW #1
R3_BACKUP_4000 .BLKW #1
R4_BACKUP_4000 .BLKW #1
R5_BACKUP_4000 .BLKW #1
R6_BACKUP_4000 .BLKW #1
R7_BACKUP_4000 .BLKW #1
POINTER .FILL x4000
DEC_5 .FILL #5
PROMPT .STRINGZ "Input 16bit int\n"
ERROR_MSG .STRINGZ "Invalid input\n"
MINUSSIGN .FILL '-'
PLUSSIGN .FILL '+'
MINUS_FLAG .FILL #1
ENTER .FILL '\n'
DEC_0 .FILL #0
UPPER_LIM .FILL -x39
LOWER_LIM .FILL -x30
;=================================================
; SUB_SWAP_DESCENDING
; input:         R2 <- input 1
;                R1 <- input 2   (I'm serious)
; postcondition: places values of R1 and R2 such that R1 > R2
;                strips signs and adds sign flag
;
; output:        R1 R2 R3
;=================================================
.orig x4200
SUB_SWAP_DESCENDING

ST R0,R0_BACKUP_4200
ST R4,R4_BACKUP_4200
ST R5,R5_BACKUP_4200
ST R6,R6_BACKUP_4200
ST R7,R7_BACKUP_4200

;initialize R3 neg flag to 0
AND R3,R3,#0
;check if either are initially negs
;flip them pos and adjust R3 sign appropriately
ADD R1,R1,#0
BRn R1_NEG_4200
BR R1_POS_4200
R1_NEG_4200
  NOT R1,R1
  ADD R1,R1,#1
  ADD R3,R3,#1
R1_POS_4200

ADD R2,R2,#0
BRn R2_NEG_4200
BR R2_POS_4200
R2_NEG_4200
  NOT R2,R2
  ADD R2,R2,#1
  ADD R3,R3,#-1
R2_POS_4200

;flip R2 to be negative
ADD R5,R2,#0
NOT R5,R5
ADD R5,R5,#1
;R1 + -R2
ADD R4,R5,R1

BRn SWAP_4200
BR KEEP_4200

SWAP_4200
  ADD R5,R2,#0
  ADD R2,R1,#0
  ADD R1,R5,#0
KEEP_4200

LD R0,R0_BACKUP_4200
LD R4,R4_BACKUP_4200
LD R5,R5_BACKUP_4200
LD R6,R6_BACKUP_4200
LD R7,R7_BACKUP_4200

RET

R0_BACKUP_4200 .BLKW #1
R3_BACKUP_4200 .BLKW #1
R4_BACKUP_4200 .BLKW #1
R5_BACKUP_4200 .BLKW #1
R6_BACKUP_4200 .BLKW #1
R7_BACKUP_4200 .BLKW #1
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
