;=================================================
; Name: <Collier, Craig>
; Username: ccoll010
; 
; Assignment: assn4 
; Lab section: 23
; TA: Bryan Marsh
; 
;=================================================

;=================================================
; main
;=================================================
.orig x3000
    LD R0, POINTER_NUM_TO_REGISTER
    JSRR R0
    
    ADD R1,R1,#1

    LD R0,ENTERCHAR
    OUT

    LD R0,POINTER_PRINT_NUM  
    JSRR R0

HALT

;data

ENTERCHAR .FILL '\n'
POINTER_NUM_TO_REGISTER .FILL x3200
POINTER_PRINT_NUM .FILL x3400

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
; SUB_PRINT_NUM
; input:         R1
; postcondition: Given literal number input, outputs character form
; output:        
;=================================================
.orig x3400
SUB_PRINT_NUM

    ST R0,R0_BACKUP_3400
    ST R1,R1_BACKUP_3400
    ST R2,R2_BACKUP_3400
    ST R3,R3_BACKUP_3400
    ST R4,R4_BACKUP_3400
    ST R7,R7_BACKUP_3400

;store in R0, convert to ascii and output front digit
LD R0,DEC_10000
AND R3,R3,#0


DECR_10000
    ADD R2,R1,#0
    ADD R2,R2,R0
    BRn DONE_10000
    ADD R3,R3,#1
    ADD R1,R2,#0
    BR DECR_10000
DONE_10000
    LD R4, ASCII_TOCHAR
    ADD R0,R3,R4
    OUT

LD R0,DEC_1000
AND R3,R3,#0
DECR_1000
    ADD R2,R1,#0
    ADD R2,R2,R0
    BRn DONE_1000
    ADD R3,R3,#1
    ADD R1,R2,#0
    BR DECR_1000
DONE_1000
    LD R4, ASCII_TOCHAR
    ADD R0,R3,R4
    OUT


LD R0,DEC_100
AND R3,R3,#0
DECR_100
    ADD R2,R1,#0
    ADD R2,R2,R0
    BRn DONE_100
    ADD R3,R3,#1
    ADD R1,R2,#0
    BR DECR_100
DONE_100
    LD R4, ASCII_TOCHAR
    ADD R0,R3,R4
    OUT


LD R0,DEC_10
AND R3,R3,#0
DECR_10
    ADD R2,R1,#0
    ADD R2,R2,R0
    BRn DONE_10
    ADD R3,R3,#1
    ADD R1,R2,#0
    BR DECR_10
DONE_10
    LD R4, ASCII_TOCHAR
    ADD R0,R3,R4
    OUT

LD R0,DEC_1
AND R3,R3,#0
DECR_1
    ADD R2,R1,#0
    ADD R2,R2,R0
    BRn DONE_1
    ADD R3,R3,#1
    ADD R1,R2,#0
    BR DECR_1
DONE_1
    LD R4, ASCII_TOCHAR
    ADD R0,R3,R4
    OUT

;restore
    LD R0,R0_BACKUP_3400
    LD R1,R1_BACKUP_3400
    LD R2,R2_BACKUP_3400
    LD R3,R3_BACKUP_3400
    LD R4,R4_BACKUP_3400
    LD R7,R7_BACKUP_3400
RET


R0_BACKUP_3400 .BLKW #1
R1_BACKUP_3400 .BLKW #1
R2_BACKUP_3400 .BLKW #1
R3_BACKUP_3400 .BLKW #1
R4_BACKUP_3400 .BLKW #1
R7_BACKUP_3400 .BLKW #1

ASCII_TOCHAR .FILL x30
DEC_10000 .FILL #-10000
DEC_1000 .FILL #-1000
DEC_100 .FILL #-100
DEC_10 .FILL #-10
DEC_1 .FILL #-1

.end
