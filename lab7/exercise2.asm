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

  LD R1, PTR_IS_PALINDROME
  JSRR R1
  
  ADD R4,R4,#0
  BRz NOT_PALIN
  BR  IS_PALIN

  IS_PALIN
    LEA R0,PALINDROME_NOTICE
    PUTS
  BR END_MAIN
  NOT_PALIN
    LEA R0,NOT_PALINDROME_NOTICE
    PUTS
  BR END_MAIN 

END_MAIN
HALT

PTR_GET_STR .FILL x3200
PTR_IS_PALINDROME .FILL x3400
PALINDROME_NOTICE .STRINGZ " It's a palindrome!\n"
NOT_PALINDROME_NOTICE .STRINGZ " It's not a palindrome...\n"

PTR_REMOTE_STR .FILL x4000

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


;------------------------------------------------------------------------------------------------------------------
; Subroutine: SUB_IS_A_PALINDROME
; Parameter (R0): The address of a string
; Parameter (R5): The number of characters in the array.
; Postcondition: The subroutine has determined whether the string at (R0) is
;                 a palindrome or not returned a flag indicating such.
; Return Value: R4 {1 if the string is a palindrome, 0 otherwise}
;------------------------------------------------------------------------------------------------------------------
.orig x3400
SUB_IS_A_PALINDROME

ST R0,R0_BACKUP_3400
ST R1,R1_BACKUP_3400
ST R2,R2_BACKUP_3400
ST R3,R3_BACKUP_3400
ST R5,R5_BACKUP_3400
ST R7,R7_BACKUP_3400

;beginning
ADD R4,R0,#0
;end
ADD R5,R0,R5
ADD R5,R5,#-1

;check if n and END-n equal
;incr n
;stop at midpoint
MIRROR_LOOP_3400
  LDR R1,R4,#0
  LDR R2,R5,#0
  ;check if each end is the samee via 2s comp.
  NOT R3,R1
  ADD R3,R3,#1
  ADD R3,R3,R2
  BRnp NO_MATCH_3400
  ;incr beg decr end
  ADD R5,R5,#-1
  ADD R4,R4,#1
  ;flip beg and add to end
  ;subtract one at the end
  ;if zero or neg we reached the middle and can end
  NOT R3,R4
  ADD R3,R3,#1
  ADD R3,R3,R5
  ADD R3,R3,#-1
  BRnz PALINDROME_3400
  BR MIRROR_LOOP_3400
PALINDROME_3400
    AND R4,R4,#0
    ADD R4,R4,#1 
     BR DONE_3400
NO_MATCH_3400
    AND R4,R4,#0
    BR DONE_3400
DONE_3400
  

LD R0,R0_BACKUP_3400
LD R1,R1_BACKUP_3400
LD R2,R2_BACKUP_3400
LD R3,R3_BACKUP_3400
LD R5,R5_BACKUP_3400
LD R7,R7_BACKUP_3400

RET

R0_BACKUP_3400 .BLKW #1
R1_BACKUP_3400 .BLKW #1
R2_BACKUP_3400 .BLKW #1
R3_BACKUP_3400 .BLKW #1
R5_BACKUP_3400 .BLKW #1
R7_BACKUP_3400 .BLKW #1


.end
