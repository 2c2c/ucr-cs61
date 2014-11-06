;=================================================
; Name: <Collier, Craig>
; Username: ccoll010
; 
; Lab: <lab 4>
; Lab section: 23
; TA: Bryan Marsh
; 
;=================================================

;=================================================
;Main
;=================================================
.orig x3000
LD R1,DEC_1
LD R5,POINTER
LD R4,DEC_10

;store values in array
INPUT_WHILE
    STR R1,R5,#0
    ADD R5,R5,#1
    ADD R1,R1,R1
    ADD R4,R4,#-1
    BRnp INPUT_WHILE

;array iteration loop
LD R5,DEC_10
LD R2,POINTER
OUTPUT_WHILE
    LDR R1,R2,#0
    LD R6,FOUR
    ; For each element in array
    ; AND to check if it shares its 1
    ; bit with the value. if it does
    ; print 1, else print 0
    LD R3,HIGH_BIT
    LD R2,POINTER

    
    JSR OUTPUT_BINARY_3200
    LD R0,NEWLINE
    OUT
    ADD R5,R5,#-1
    ;refill R2 with pointer
    LD R2,POINTER
    ADD R2,R2,#1
    ST R2,POINTER
    ;zero check
    ADD R5,R5,#0
    BRnp OUTPUT_WHILE
HALT



OUTPUT_BINARY_3200 .FILL x3200
DEC_1 .FILL #1
DEC_10 .FILL #10
POINTER .FILL x4000
CHAR_B .FILL x62

;vv from assn3 vv
ZERO .FILL x30
ONE .FILL x31
SPACE .FILL x20
FOUR .FILL #4

DEC_16 .FILL #16
HIGH_BIT .FILL x8000
NEWLINE .FILL xA
;^^ from assn3 ^^

.orig x4000

ARRAY .BLKW #10


.orig x3200
OUTPUT_BINARY_3200
;-------------------------
; Subroutine OUTPUT_BINARY_3200
; PARAMS: R2
; Post Conditions: Output single element of array in binary
; Returns: none
;
;store original state
ST R0,BACKUP_R0_3200
ST R1,BACKUP_R1_3200
ST R2,BACKUP_R2_3200
ST R3,BACKUP_R3_3200
ST R4,BACKUP_R4_3200
ST R5,BACKUP_R5_3200
ST R6,BACKUP_R6_3200
ST R7,BACKUP_R7_3200

;algorithm
;load from pointer R2 first
LDR R1,R2,#0
;reuse R2 as #16 for increment
LD R2,DEC_16_3200
LD R0,CHAR_B_3200
LD R6,FOUR_3200
OUT
;output contents of actual array value loop 
FOR_EACH
  ; and 6he value
  ; take the result of that and take its 2s compliment
  ; subtract the finished result against the array
  ; if that results in 0 it means that the two were equal
  LD R3,HIGH_BIT_3200
  AND R4,R1,R3
  NOT R4,R4
  ADD R4,R4,#1 
  ADD R4,R3,R4
  BRnp ZERO_3200BIT
  ONE_3200BIT
    LD R0,ONE_3200
    OUT
    BR DONE_3200
  ZERO_3200BIT
    LD R0,ZERO_3200
    OUT 
    BR DONE_3200
  DONE_3200
  ; check for 4 iterations and add space
  ADD R6,R6,#-1
  BRnp NOSPACE_3200
  LD R0,SPACE_3200
  OUT
  LD R6,FOUR_3200
  NOSPACE_3200 

  ADD R1,R1,R1
  ADD R2,R2,#-1
BRnp FOR_EACH

;reload original data
LD R0,BACKUP_R0_3200
LD R1,BACKUP_R1_3200
LD R2,BACKUP_R2_3200
LD R3,BACKUP_R3_3200
LD R4,BACKUP_R4_3200
LD R5,BACKUP_R5_3200
LD R6,BACKUP_R6_3200
LD R7,BACKUP_R7_3200

;RETURN
RET



;backup data
BACKUP_R0_3200 .FILL #1
BACKUP_R1_3200 .FILL #1
BACKUP_R2_3200 .FILL #1
BACKUP_R3_3200 .FILL #1
BACKUP_R4_3200 .FILL #1
BACKUP_R5_3200 .FILL #1
BACKUP_R6_3200 .FILL #1
BACKUP_R7_3200 .FILL #1
POINTER_3200 .FILL x4000
CHAR_B_3200 .FILL x62
HIGH_BIT_3200 .FILL x8000
DEC_16_3200 .FILL #16

;vv from assn3 vv
ZERO_3200 .FILL x30
ONE_3200 .FILL x31
SPACE_3200 .FILL x20
FOUR_3200 .FILL #4



.end
