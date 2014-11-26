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
  
  LEA R0,PROMPT
  PUTS
    
  LD R0,PTR_STRING
  LD R1,PTR_GETSTR
  JSRR R1

  LD R1,PTR_UPPER
  JSRR R1
  PUTS


HALT

PTR_STRING .FILL x4000
PTR_UPPER .FILL x3400
PTR_GETSTR .FILL x3200
PROMPT .STRINGZ "Input a string to uppercase\n"

;----------------------------------------------------------------------------------------------------------------
; Subroutine: SUB_GET_STRING
; Parameter (R0): The address of where to start storing the string
; Postcondition: The subroutine has allowed the user to input a string,
;                terminated by the [ENTER] key, and has stored it in an array
;                that starts at (R0) and is NULL-terminated.
; Return Value: R5 The number of non-sentinel characters read from the user
;-----------------------------------------------------------------------------------------------------------------
.orig x3200
SUB_GET_STRING

ST R0,R0_BACKUP_3200
ST R1,R1_BACKUP_3200
ST R2,R2_BACKUP_3200
ST R7,R7_BACKUP_3200


;R0 has the location
;copy it somewhere else for in/output reg freedom
ADD R6,R6,R0

;start counter at 0
AND R5,R5,#0

GETSTR_LOOP_3200
  LD R1, ENTERKEY_3200
  GETC
  OUT
  NOT R1,R1
  ADD R1,R1,#1
  ADD R1,R1,R0
  BRz ENTER_PRESSED_3200
  STR R0,R6,#0
  ADD R6,R6,#1
  ADD R5,R5,#1
  BR GETSTR_LOOP_3200
ENTER_PRESSED_3200
;fill the end with null terminator
AND R0,R0,#0
STR R0,R6,#0

    

 
LD R0,R0_BACKUP_3200
LD R1,R1_BACKUP_3200
LD R2,R2_BACKUP_3200
LD R7,R7_BACKUP_3200

RET 


R0_BACKUP_3200 .BLKW #1
R1_BACKUP_3200 .BLKW #1
R2_BACKUP_3200 .BLKW #1
R7_BACKUP_3200 .BLKW #1

ENTERKEY_3200 .FILL '\n'
PTR_REMOTE_STR_3200 .FILL #0

.end

;------------------------------------------------------------------------------------------------------------------
; Subroutine: SUB_TO_UPPER
; Parameter (R0): Address to store a string at
; Postcondition: The subroutine has allowed the user to input a string,
;           terminated by the [ENTER] key, has converted the string
;           to upper-case, and has stored it in a null-terminated array that
;           starts at (R0).
; Return Value: R0 ← The address of the now upper case string.
;------------------------------------------------------------------------------------------------------------------

.orig x3400
SUB_TO_UPPER

ST R0,R0_BACKUP_3400
ST R1,R1_BACKUP_3400
ST R2,R2_BACKUP_3400
ST R7,R7_BACKUP_3400

WHILE_3400
    LDR R2,R0,#0
    ;load number that can be subtracted from char to check if it is lowercase a-z range
    ;skip over store if it is out of range
    LD R3,LOWLIMIT_3400
    ADD R3,R2,R3
    BRnz OUTOFRANGE_3400
    LD R3,HIGHLIMIT_3400
    ADD R3,R2,R3
    BRzp OUTOFRANGE_3400
    LD R1,CONVERT_MASK_3400
    AND R2,R2,R1
    STR R2,R0,#0
    OUTOFRANGE_3400
    ADD R0,R0,#1
    ADD R2,R2,#0
    BRnp WHILE_3400
END_WHILE_3400





LD R0,R0_BACKUP_3400
LD R1,R1_BACKUP_3400
LD R2,R2_BACKUP_3400
LD R7,R7_BACKUP_3400

RET

R0_BACKUP_3400 .BLKW #1
R1_BACKUP_3400 .BLKW #1
R2_BACKUP_3400 .BLKW #1
R7_BACKUP_3400 .BLKW #1
CONVERT_MASK_3400 .FILL x5F  
LOWLIMIT_3400 .FILL -x60
HIGHLIMIT_3400 .FILL -x7B


.orig x4000
EXAMPLE_STR .STRINGZ "`g oa{yz~"


.end
