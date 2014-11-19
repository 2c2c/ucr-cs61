
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

  LD R0, PTR_REMOTE_STR
  LD R1, PTR_GET_STR
  JSRR R1
  PUTS
  
HALT

PTR_GET_STR .FILL x3200

.orig x4200
PTR_REMOTE_STR .FILL x4200


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
  ADD R5,R5,#1
  BR GETSTR_LOOP_3200
ENTER_PRESSED_3200
;fill the end with null terminator
AND R0,R0,#0
STR R0,R6,#0

    

LD R0,R0_BACKUP_3200
LD R1,R1_BACKUP_3200
LD R2,R2_BACKUP_3200
 
RET 


R0_BACKUP_3200 .BLKW #1
R1_BACKUP_3200 .BLKW #1
R2_BACKUP_3200 .BLKW #1
ENTERKEY_3200 .FILL '\n'
PTR_REMOTE_STR_3200 .FILL #0

.end
