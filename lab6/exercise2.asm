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
LEA R0,PROMPT
PUTS

GETC
OUT
ADD R5,R0,#0
LD R0,ENTERCHAR
OUT

LD R0,POINTER_BIT_COUNTER
JSRR R0

LEA R0,ANSWER
PUTS

LD R2,ASCII_TOCHAR
ADD R0,R6,R2
OUT


HALT

;data
PROMPT .STRINGZ "Input a single character\n"
ANSWER .STRINGZ "The number of 1 bits is: "
ENTERCHAR .FILL '\n'
ASCII_TOCHAR .FILL x30
POINTER_BIT_COUNTER .FILL x3200

;=================================================
; SUB_BIT_COUNTER
; input:         R5
; postcondition: Counts the number of 1 bits in a given input
; output:        R6
;=================================================
.orig x3200
SUB_BIT_COUNTER
    
    ;store
    ST R0,R0_BACKUP_3200
    ST R2,R2_BACKUP_3200
    ST R3,R3_BACKUP_3200
    ST R4,R4_BACKUP_3200
    ST R5,R5_BACKUP_3200
    ST R7,R7_BACKUP_3200

   LD R6,DEC_16
   AND R1,R1,#0
   ADD R1,R1,R6
   LD R2,FRONT_BIT
   AND R3,R3,#0
   AND R4,R4,#0

   FOREACH_3200
      
      ADD R1,R1,#0
      BRnz FIN_3200

      ;and input and 1000 ...
      AND R4,R5,R2
      BRz ZERO_BIT
      BR ONE_BIT

      ZERO_BIT
        ADD R1,R1,#-1
        ADD R5,R5,R5
        BR FOREACH_3200 
      ONE_BIT
        ADD R1,R1,#-1
        ADD R3,R3,#1
        ADD R5,R5,R5
        BR FOREACH_3200
  FIN_3200 
  ADD R6,R3,#0


    LD R0,R0_BACKUP_3200
    LD R2,R2_BACKUP_3200
    LD R3,R3_BACKUP_3200
    LD R4,R4_BACKUP_3200
    LD R5,R5_BACKUP_3200
    LD R7,R7_BACKUP_3200

    RET

;DATA
DEC_16 .FILL #16
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
