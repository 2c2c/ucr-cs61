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
LD R5,TEST_VAL

LEA R0, PROMPT
PUTS

LD R0,POINTER_RIGHT_SHIFT
JSRR R0


HALT

;data
TEST_VAL .FILL #16
PROMPT .STRINGZ "Right shifts the value in TEST_VAL label\n"
ENTERCHAR .FILL '\n'
ASCII_TOCHAR .FILL x30
POINTER_RIGHT_SHIFT .FILL x3200

;=================================================
; SUB_RIGHT_SHIFT
; input:         R5
; postcondition: applies right shift to input
; output:        R5
;=================================================
.orig x3200
SUB_RIGHT_SHIFT
    
    ;store
    ST R0,R0_BACKUP_3200
    ST R2,R2_BACKUP_3200
    ST R3,R3_BACKUP_3200
    ST R4,R4_BACKUP_3200
    ST R7,R7_BACKUP_3200
      
      LD R1,FRONT_BIT
      LD R2, DEC_15
    FOREACH_2200
      ADD R2,R2,#0
      BRnz FIN_2200
      ;check testval vs frotnt bit
      AND R3,R5,R1
      BRz ZERO_CASE
      BR ONE_CASE

      ;on each left shift we account for the truncated 0/1
      ;by adding to the right end of the number the trunacted 0/1
      ZERO_CASE
        ADD R5,R5,R5
        ADD R2,R2,#-1
        BR FOREACH_2200

      ONE_CASE
        ADD R5,R5,R5
        ADD R5,R5,#1
        ADD R2,R2,#-1
        BR FOREACH_2200
      FIN_2200




    LD R0,R0_BACKUP_3200
    LD R2,R2_BACKUP_3200
    LD R3,R3_BACKUP_3200
    LD R4,R4_BACKUP_3200
    LD R7,R7_BACKUP_3200

    RET

;DATA
DEC_15 .FILL #15
FRONT_BIT .FILL x8000
R0_BACKUP_3200 .BLKW #1
R1_BACKUP_3200 .BLKW #1
R2_BACKUP_3200 .BLKW #1
R3_BACKUP_3200 .BLKW #1
R4_BACKUP_3200 .BLKW #1
R5_BACKUP_3200 .BLKW #1
R6_BACKUP_3200 .BLKW #1
R7_BACKUP_3200 .BLKW #1
.end
