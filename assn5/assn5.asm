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

LEA R0, PROMPT
PUTS

LD R0,SUB_GET_MULT_TARGETS
JSRR R0


HALT

;data
TEST_VAL .FILL #16
PROMPT .STRINGZ "Multiplying 2 numbers \n"
ENTERCHAR .FILL '\n'
ASCII_TOCHAR .FILL x30
SUB_GET_MULT_TARGETS .FILL x3400

;=================================================
; SUB_NUM_TO_REGISTER
; input:         None
; postcondition: Takes character input and creates literal number value
;                in R1
; output:        R1
;=================================================
.orig x3200
SUB_NUM_TO_REGISTER
    
    ;store
    ST R0,R0_BACKUP_3200
    ST R2,R2_BACKUP_3200
    ST R3,R3_BACKUP_3200
    ST R4,R4_BACKUP_3200
    ST R5,R5_BACKUP_3200
    ST R6,R6_BACKUP_3200
    ST R7,R7_BACKUP_3200
    
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
    BRp MAKE_NEGATIVE
    BR KEEP
    MAKE_NEGATIVE
        NOT R1,R1
        ADD R1,R1,#1
    KEEP

    ;restore
    LD R0,R0_BACKUP_3200
    LD R2,R2_BACKUP_3200
    LD R3,R3_BACKUP_3200
    LD R4,R4_BACKUP_3200
    LD R5,R5_BACKUP_3200
    LD R6,R6_BACKUP_3200
    LD R7,R7_BACKUP_3200
    ;return
    RET

;DATA
R0_BACKUP_3200 .BLKW #1
R1_BACKUP_3200 .BLKW #1
R2_BACKUP_3200 .BLKW #1
R3_BACKUP_3200 .BLKW #1
R4_BACKUP_3200 .BLKW #1
R5_BACKUP_3200 .BLKW #1
R6_BACKUP_3200 .BLKW #1
R7_BACKUP_3200 .BLKW #1
POINTER .FILL x4000
DEC_5 .FILL #5
PROMPT .STRINGZ "Input 16bit int\n"
ERROR_MSG .STRINGZ "Invalid input\n"
MINUSSIGN .FILL '-'
PLUSSIGN .FILL '+'
MINUS_FLAG .FILL #1
ENTER .FILL '\n'
DEC_0 .FILL #0
UPPER_LIM .FILL -x3A
LOWER_LIM .FILL -x2
;REMOTE 
.orig x4000
ARRAY .BLKW #6
;=================================================
; SUB_GET_MULT_TARGETS
; input:         None
; postcondition: Uses SUB_NUM_TO_REGISTER twice to get two numbers for multiplying
; output:        R1 R2
;=================================================
.orig x3400
SUB_GET_MULT_TARGETS
    ST R0,R0_BACKUP_3400
    ST R3,R3_BACKUP_3400
    ST R4,R4_BACKUP_3400
    ST R5,R5_BACKUP_3400
    ST R6,R6_BACKUP_3400
    ST R7,R7_BACKUP_3400

;get number 1
LD R0,POINTER_NUM_TO_REGISTER
JSRR R0

;store it elsewhere so funciton can be called again
ADD R2,R1,#0

;get number 2
JSRR R0



    LD R0,R0_BACKUP_3400
    LD R3,R3_BACKUP_3400
    LD R4,R4_BACKUP_3400
    LD R5,R5_BACKUP_3400
    LD R6,R6_BACKUP_3400
    LD R7,R7_BACKUP_3400

    RET


R0_BACKUP_3400 .BLKW #1
R3_BACKUP_3400 .BLKW #1
R4_BACKUP_3400 .BLKW #1
R5_BACKUP_3400 .BLKW #1
R6_BACKUP_3400 .BLKW #1
R7_BACKUP_3400 .BLKW #1
POINTER_NUM_TO_REGISTER .FILL x3200
;=================================================
; SUB_SWAP_DESCENDING
; input:         R1 R2
; postcondition: places values of R1 and R2 such that R1 > R2, strips signs and adds sign flag
; output:        R1 R2 R3
;=================================================
.orig x3600
SUB_SWAP_DESCENDING

ST R0,R0_BACKUP_3600
ST R3,R3_BACKUP_3600
ST R4,R4_BACKUP_3600
ST R5,R5_BACKUP_3600
ST R6,R6_BACKUP_3600
ST R7,R7_BACKUP_3600

AND R3,R3,#0
;check if either are initially negs
;flip them pos and adjust R3 sign appropriately
ADD R1,R1,#0
BRn R1_NEG

ADD R2,R2,#0
BRn R2_NEG
BR BOTH_POS
R1_NEG
  NOT R1,R1
  ADD R1,R1,#1
  ADD R3,R3,#1
R2_NEG
  NOT R2,R1
  ADD R2,R2,#1
  ADD R3,R3,#-1
BOTH_POS


;flip R2 to be negative
ADD R3,R2,#0
NOT R3,R3
ADD R3,R3,#1
;R1 + -R2
ADD R4,R3,R1

BRn SWAP
BR KEEP

SWAP
  ADD R3,R2,#0
  ADD R2,R1,#0
  ADD R1,R3,#0
KEEP

LD R0,R0_BACKUP_3600
LD R3,R3_BACKUP_3600
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
; postcondition: Mult R1 R2 and apply negative condition R3
; output:        R4
;=================================================

.orig x3800
SUB_MULT
ST R0,R0_BACKUP_3800
ST R1,R1_BACKUP_3800
ST R2,R2_BACKUP_3800
ST R3,R3_BACKUP_3800
ST R7,R7_BACKUP_3800

AND R4,R4,#0

WHILE_3800
  ADD R4,R4,R1
  ADD R2,R2,#-1
  BRp WHILE_3800
END_WHILE_3800

ADD R3,R3,#0
;pos/neg case flip R4 result
BRz

  
LD R0,R0_BACKUP_3800
LD R1,R1_BACKUP_3800
LD R2,R2_BACKUP_3800
LD R3,R3_BACKUP_3800
LD R7,R7_BACKUP_3800

RET
R0_BACKUP_3800 .BLKW #1
R1_BACKUP_3800 .BLKW #1
R2_BACKUP_3800 .BLKW #1
R3_BACKUP_3800 .BLKW #1
R7_BACKUP_3800 .BLKW #1
