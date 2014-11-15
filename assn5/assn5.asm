;=================================================
; Name: <Collier, Craig>
; Username: ccoll010
; 
; Assignment: lab 6
; Lab section: 23
; TA: Bryan Marsh
; 
;=================================================

;=================================================
; main
;=================================================
.orig x3000

LEA R0, PROMPT_MAIN
PUTS

LD R0, GET_MULT_TARGETS_PTR
JSRR R0

;input must be copied to R6 for output
;output first num
ADD R6,R2,#0
LD R0,PRINTNUM_PTR
JSRR R0
;output * sign
LEA R0,MULT_OUTPUT_MAIN
PUTS
;output second num
ADD R6,R1,#0
LD R0,PRINTNUM_PTR
JSRR R0

LD R0,SWAP_DESC_PTR
JSRR R0

;multiply
;if overflow skip the final number print
LD R0,MULT_PTR
JSRR R0
ADD R4,R4,#0
BRnp END_MAIN
;output = 
LEA R0,EQUALS_OUTPUT_MAIN
PUTS
;output result
LD R0,PRINTNUM_PTR
JSRR R0
;output newline
LD R0,ENTERCHAR_MAIN
OUT

END_MAIN
HALT

;data
TEST_VAL_MAIN .FILL #16
PROMPT_MAIN .STRINGZ "Multiplying 2 numbers \n"
ENTERCHAR_MAIN .FILL '\n'
MULT_OUTPUT_MAIN .STRINGZ " * "
EQUALS_OUTPUT_MAIN .STRINGZ " = "
SPACECHAR_MAIN .FILL ' '
MULTCHAR_MAIN .FILL '*'
ASCII_TOCHAR_MAIN .FILL x30
GET_MULT_TARGETS_PTR .FILL x3200
SWAP_DESC_PTR .FILL x3600
PRINTNUM_PTR .FILL x4200
MULT_PTR .FILL x3800

;=================================================
; SUB_GET_MULT_TARGETS
; input:         None
; postcondition: Uses SUB_NUM_TO_REGISTER twice to get two numbers for multiplying
; output:        R1 R2
;=================================================
.orig x3200
SUB_GET_MULT_TARGETS
;store
ST R0,R0_BACKUP_3200
ST R3,R3_BACKUP_3200
ST R4,R4_BACKUP_3200
ST R5,R5_BACKUP_3200
ST R6,R6_BACKUP_3200
ST R7,R7_BACKUP_3200

;get number 1
LD R0,NUM_TO_REG_PTR
JSRR R0

;store it elsewhere so funciton can be called again
ADD R2,R1,#0

;get number 2
JSRR R0



LD R0,R0_BACKUP_3200
LD R3,R3_BACKUP_3200
LD R4,R4_BACKUP_3200
LD R5,R5_BACKUP_3200
LD R6,R6_BACKUP_3200
LD R7,R7_BACKUP_3200

RET


R0_BACKUP_3200 .BLKW #1
R3_BACKUP_3200 .BLKW #1
R4_BACKUP_3200 .BLKW #1
R5_BACKUP_3200 .BLKW #1
R6_BACKUP_3200 .BLKW #1
R7_BACKUP_3200 .BLKW #1
NUM_TO_REG_PTR .FILL x3400

;=================================================
; SUB_NUM_TO_REGISTER
; input:         None
; postcondition: Takes character input and creates literal number value
;                in R1
; output:        R1
;=================================================
.orig x3400
SUB_NUM_TO_REGISTER
    
    ;store
    ST R0,R0_BACKUP_3400
    ST R2,R2_BACKUP_3400
    ST R3,R3_BACKUP_3400
    ST R4,R4_BACKUP_3400
    ST R5,R5_BACKUP_3400
    ST R6,R6_BACKUP_3400
    ST R7,R7_BACKUP_3400
    
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
    BRp MAKE_NEGATIVE_3400
    BR KEEP_3400
    MAKE_NEGATIVE_3400
        NOT R1,R1
        ADD R1,R1,#1
    KEEP_3400
    LD R0,ENTER
    OUT

    ;restore
    LD R0,R0_BACKUP_3400
    LD R2,R2_BACKUP_3400
    LD R3,R3_BACKUP_3400
    LD R4,R4_BACKUP_3400
    LD R5,R5_BACKUP_3400
    LD R6,R6_BACKUP_3400
    LD R7,R7_BACKUP_3400
    ;return
    RET

;DATA
R0_BACKUP_3400 .BLKW #1
R1_BACKUP_3400 .BLKW #1
R2_BACKUP_3400 .BLKW #1
R3_BACKUP_3400 .BLKW #1
R4_BACKUP_3400 .BLKW #1
R5_BACKUP_3400 .BLKW #1
R6_BACKUP_3400 .BLKW #1
R7_BACKUP_3400 .BLKW #1
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
;REMOTE 
.orig x4000
ARRAY .BLKW #6
;=================================================
; SUB_SWAP_DESCENDING
; input:         R2 <- input 1
;                R1 <- input 2   (I'm serious)
; postcondition: places values of R1 and R2 such that R1 > R2
;                strips signs and adds sign flag
;
; output:        R1 R2 R3
;=================================================
.orig x3600
SUB_SWAP_DESCENDING

ST R0,R0_BACKUP_3600
ST R4,R4_BACKUP_3600
ST R5,R5_BACKUP_3600
ST R6,R6_BACKUP_3600
ST R7,R7_BACKUP_3600

;initialize R3 neg flag to 0
AND R3,R3,#0
;check if either are initially negs
;flip them pos and adjust R3 sign appropriately
ADD R1,R1,#0
BRn R1_NEG_3600
BR R1_POS_3600
R1_NEG_3600
  NOT R1,R1
  ADD R1,R1,#1
  ADD R3,R3,#1
R1_POS_3600

ADD R2,R2,#0
BRn R2_NEG_3600
BR R2_POS_3600
R2_NEG_3600
  NOT R2,R2
  ADD R2,R2,#1
  ADD R3,R3,#-1
R2_POS_3600

;flip R2 to be negative
ADD R5,R2,#0
NOT R5,R5
ADD R5,R5,#1
;R1 + -R2
ADD R4,R5,R1

BRn SWAP_3600
BR KEEP_3600

SWAP_3600
  ADD R5,R2,#0
  ADD R2,R1,#0
  ADD R1,R5,#0
KEEP_3600

LD R0,R0_BACKUP_3600
LD R4,R4_BACKUP_3600
LD R5,R5_BACKUP_3600
LD R6,R6_BACKUP_3600
LD R7,R7_BACKUP_3600

RET

R0_BACKUP_3600 .BLKW #1
R3_BACKUP_3600 .BLKW #1
R4_BACKUP_3600 .BLKW #1
R5_BACKUP_3600 .BLKW #1
R6_BACKUP_3600 .BLKW #1
R7_BACKUP_3600 .BLKW #1
;=================================================
; SUB_MULT
; input:         R1 R2 R3
; postcondition: Mult R1 R2 and apply negative condition R3. If an overflow occurs
;                change R4 flag which will notify main to exit
; output:        R6 R4
;=================================================

.orig x3800
SUB_MULT
ST R0,R0_BACKUP_3800
ST R1,R1_BACKUP_3800
ST R2,R2_BACKUP_3800
ST R3,R3_BACKUP_3800
ST R5,R5_BACKUP_3800
ST R7,R7_BACKUP_3800

AND R6,R6,#0

LD R5,FRONT_BIT_3800
;if there's a zero skip over the loop
ADD R2,R2,#0
BRz END_WHILE_3800
BR WHILE_3800

WHILE_3800
  ;repeatedly add
  ADD R6,R6,R1
  ADD R2,R2,#-1
  ;if the front bit changes to a 1 overflow has occured
  AND R4,R6,R5
  BRnp OVERFLOW_3800
  ADD R2,R2,#0
  BRp WHILE_3800
END_WHILE_3800


;if neg flag is set flip the result
ADD R3,R3,#0
BRz NORMALCASE_3800
BR NEGCASE_3800

NEGCASE_3800
    NOT R6,R6
    ADD R6,R6,#1
NORMALCASE_3800
BR NORMAL_EXIT_3800


OVERFLOW_3800
LEA R0,OVERFLOW_NOTICE
PUTS

NORMAL_EXIT_3800

;fin  
;store
LD R0,R0_BACKUP_3800
LD R1,R1_BACKUP_3800
LD R2,R2_BACKUP_3800
LD R3,R3_BACKUP_3800
LD R5,R5_BACKUP_3800
LD R7,R7_BACKUP_3800

RET




R0_BACKUP_3800 .BLKW #1
R1_BACKUP_3800 .BLKW #1
R2_BACKUP_3800 .BLKW #1
R3_BACKUP_3800 .BLKW #1
R5_BACKUP_3800 .BLKW #1
R7_BACKUP_3800 .BLKW #1
FRONT_BIT_3800 .FILL x8000
OVERFLOW_NOTICE .STRINGZ " = Overflow!\n"

;=================================================
; SUB_PRINT_NUM
; input:         R6
; postcondition: Given literal number input, outputs character form
; output:        
;=================================================
.orig x4200
SUB_PRINT_NUM

ST R0,R0_BACKUP_4200
ST R1,R1_BACKUP_4200
ST R6,R6_BACKUP_4200
ST R2,R2_BACKUP_4200
ST R3,R3_BACKUP_4200
ST R4,R4_BACKUP_4200
ST R7,R7_BACKUP_4200

;flip input if it is negative, apply flag to output minus sign if necessary
ADD R6,R6,#0
BRz ZERO_CASE_4200
BRn NEG_CASE_4200
BR NORM_CASE_4200

ZERO_CASE_4200
    LD R4, ASCII_TOCHAR_4200
    ADD R0,R6,R4
    OUT
    BR SKIP_4200_5
NEG_CASE_4200
    LD R0,MINUSCHAR_4200
    OUT
    NOT R6,R6
    ADD R6,R6,#1
NORM_CASE_4200

;store in R0, convert to ascii and output front digit
LD R0,DEC_10000_4200
AND R3,R3,#0


;this could very clearly have been rolled into a loop
;the use for it started much simpler and simply pasting it 5 times for
;output was actually faster than constructing a loop
;complexity has built up and adding to it made more sense than fixing it

;flag R1 signifies there's been a nonzero number output
;this manages leading zeroes
AND R1,R1,#0

DECR_10000_4200
    ADD R2,R6,#0
    ADD R2,R2,R0
    BRn DONE_10000_4200
    ADD R3,R3,#1
    ADD R6,R2,#0
    BR DECR_10000_4200
DONE_10000_4200
    LD R4, ASCII_TOCHAR_4200
    ADD R0,R3,R4
    LD R5,ASCII_TONUM_4200
    ADD R5,R5,R0
    ADD R5,R5,R1
    BRz SKIP_4200_1
    ADD R1,R1,#1
    OUT
SKIP_4200_1

LD R0,DEC_1000_4200
AND R3,R3,#0
DECR_1000_4200
    ADD R2,R6,#0
    ADD R2,R2,R0
    BRn DONE_1000_4200
    ADD R3,R3,#1
    ADD R6,R2,#0
    BR DECR_1000_4200
DONE_1000_4200
    LD R4, ASCII_TOCHAR_4200
    ADD R0,R3,R4
    LD R5,ASCII_TONUM_4200
    ADD R5,R5,R0
    ADD R5,R5,R1
    BRz SKIP_4200_2 
    ADD R1,R1,#1
    OUT

SKIP_4200_2
LD R0,DEC_100_4200
AND R3,R3,#0
DECR_100_4200
    ADD R2,R6,#0
    ADD R2,R2,R0
    BRn DONE_100_4200
    ADD R3,R3,#1
    ADD R6,R2,#0
    BR DECR_100_4200
DONE_100_4200
    LD R4, ASCII_TOCHAR_4200
    ADD R0,R3,R4
    LD R5,ASCII_TONUM_4200
    ADD R5,R5,R0
    ADD R5,R5,R1
    BRz SKIP_4200_3
    ADD R1,R1,#1
    OUT


SKIP_4200_3
LD R0,DEC_10_4200
AND R3,R3,#0
DECR_10_4200
    ADD R2,R6,#0
    ADD R2,R2,R0
    BRn DONE_10_4200
    ADD R3,R3,#1
    ADD R6,R2,#0
    BR DECR_10_4200
DONE_10_4200
    LD R4, ASCII_TOCHAR_4200
    ADD R0,R3,R4
    LD R5,ASCII_TONUM_4200
    ADD R5,R5,R0
    ADD R5,R5,R1
    BRz SKIP_4200_4
    ADD R1,R1,#1
    OUT

SKIP_4200_4
LD R0,DEC_1_4200
AND R3,R3,#0
DECR_1_4200
    ADD R2,R6,#0
    ADD R2,R2,R0
    BRn DONE_1_4200
    ADD R3,R3,#1
    ADD R6,R2,#0
    BR DECR_1_4200
DONE_1_4200
    LD R4, ASCII_TOCHAR_4200
    ADD R0,R3,R4
    LD R5,ASCII_TONUM_4200
    ADD R5,R5,R0
    ADD R5,R5,R1
    BRz SKIP_4200_5
    ADD R1,R1,#1
    OUT
SKIP_4200_5

;restore
LD R0,R0_BACKUP_4200
LD R1,R1_BACKUP_4200
LD R6,R6_BACKUP_4200
LD R2,R2_BACKUP_4200
LD R3,R3_BACKUP_4200
LD R4,R4_BACKUP_4200
LD R7,R7_BACKUP_4200

RET


R0_BACKUP_4200 .BLKW #1
R1_BACKUP_4200 .BLKW #1
R6_BACKUP_4200 .BLKW #1
R2_BACKUP_4200 .BLKW #1
R3_BACKUP_4200 .BLKW #1
R4_BACKUP_4200 .BLKW #1
R7_BACKUP_4200 .BLKW #1

ASCII_TOCHAR_4200 .FILL x30
ASCII_TONUM_4200 .FILL -x30
MINUSCHAR_4200 .FILL '-'
DEC_10000_4200 .FILL #-10000
DEC_1000_4200 .FILL #-1000
DEC_100_4200 .FILL #-100
DEC_10_4200 .FILL #-10
DEC_1_4200 .FILL #-1

.end
