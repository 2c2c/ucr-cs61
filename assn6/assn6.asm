;=================================================
; Name: <Collier, Craig>
; Username: ccoll010
; 
; Lab: <lab 1>
; Lab section: 221
; TA: Bryan Marsh
; 
;=================================================

;-----------------------------------------------------------------------------------------------------------------
; MAIN
;-----------------------------------------------------------------------------------------------------------------
.orig x3000

LD R0,PTR_MENU
JSRR R0

ADD R1,R1,#-1
BRz CHOOSE_OPTION1
ADD R1,R1,#-1
BRz CHOOSE_OPTION2
ADD R1,R1,#-1
BRz CHOOSE_OPTION3
ADD R1,R1,#-1
BRz CHOOSE_OPTION4
ADD R1,R1,#-1
BRz CHOOSE_OPTION5
ADD R1,R1,#-1
BRz CHOOSE_OPTION6
ADD R1,R1,#-1
BRz CHOOSE_OPTION7

CHOOSE_OPTION1
    LD R0,OPTION1
    JSRR R0
    BR END_MAIN
CHOOSE_OPTION2
    LD R0,OPTION2
    JSRR R0
    BR END_MAIN
CHOOSE_OPTION3
    LD R0,OPTION3
    JSRR R0
    BR END_MAIN
CHOOSE_OPTION4
    LD R0,OPTION4
    JSRR R0
    BR END_MAIN
CHOOSE_OPTION5
    LD R0,OPTION5
    JSRR R0
    BR END_MAIN
CHOOSE_OPTION6
    LD R0,OPTION6
    JSRR R0
    BR END_MAIN
CHOOSE_OPTION7
    LD R0,OPTION7
    JSRR R0
    BR END_MAIN


END_MAIN
HALT


PTR_MENU .FILL x3200
OPTION1 .FILL x3400
OPTION2 .FILL x3600
OPTION3 .FILL x3800
OPTION4 .FILL x4000
OPTION5 .FILL x4200
OPTION6 .FILL x4400
OPTION7 .FILL x4600

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: MENU
; Inputs: None
; Postcondition: The subroutine has printed out a menu with numerical options, allowed the
;                 user to select an option, and returned the selected option.
; Return Value (R1): The option selected: #1, #2, #3, #4, #5, #6 or #7
; no other return value is possible
;-----------------------------------------------------------------------------------------------------------------
.orig x3200
SUB_MENU

ST R0,R0_BACKUP_3200
ST R7,R7_BACKUP_3200

LD R1, PTR_MENUTEXT_3200
WHILE_3200
    LDR R0,R1,#0
    OUT
    ADD R1,R1,#1
    ADD R0,R0,#0
    BRnp WHILE_3200
FIN_3200

GETC
ADD R1,R0,#0
LD R0,ASCII_TONUM_3200
ADD R1,R1,R0

LD R0,R0_BACKUP_3200
LD R7,R7_BACKUP_3200

RET

ASCII_TONUM_3200 .FILL -x30
PTR_MENUTEXT_3200 .FILL x5200
R0_BACKUP_3200 .BLKW #1
R7_BACKUP_3200 .BLKW #1
;-----------------------------------------------------------------------------------------------------------------
; Subroutine: ALL_MACHINES_BUSY
; Inputs: None
; Postcondition: The subroutine has returned a value indicating whether all machines are busy
; Return value (R2): 1 if all machines are busy, 0 otherwise
;-----------------------------------------------------------------------------------------------------------------
;1 means free 0 means busy
.orig x3400
SUB_ALL_MACHINES_BUSY

ST R0,R0_BACKUP_3400

LD R0,PTR_BUSYNESS_VEC
LDR R0,R0,#0
ADD R0,R0,#1
BRz BUSY_3400
BR FREE_3400

AND R2,R2,#0
BUSY_3400
  ADD R2,R2,#1 
FREE_3400

RET

LD R0,R0_BACKUP_3400


PTR_BUSYNESS_VEC .FILL  x5000
R0_BACKUP_3400 .BLKW #1

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: ALL_MACHINES_FREE
; Inputs: None
; Postcondition: The subroutine has returned a value indicating whether all machines are free
; Return value (R2): 1 if all machines are free, 0 otherwise
;-----------------------------------------------------------------------------------------------------------------
;1 means free 0 means busy
.orig x3600
SUB_ALL_MACHINES_BUSY

ST R0,R0_BACKUP_3600

LD R0,PTR_ALL_BUSY_3600
JSRR R0

NOT R2,R2
AND R2,R2,#1

LD R0,R0_BACKUP_3600
RET

PTR_ALL_BUSY_3600 .FILL x3400
R0_BACKUP_3600 .BLKW #1
;-----------------------------------------------------------------------------------------------------------------
; Subroutine: NUM_BUSY_MACHINES
; Inputs: None
; Postcondition: The subroutine has returned the number of busy machines.
; Return Value (R2): The number of machines that are busy
;-----------------------------------------------------------------------------------------------------------------
.orig x3800
SUB_NUM_BUSY_MACHINES
;-----------------------------------------------------------------------------------------------------------------
; Subroutine: NUM_FREE_MACHINES
; Inputs: None
; Postcondition: The subroutine has returned the number of free machines
; Return Value (R2): The number of machines that are free
;-----------------------------------------------------------------------------------------------------------------
.orig x4000
SUB_NUM_FREE_MACHINES

ST R0,R0_BACKUP_4000
ST R1,R1_BACKUP_4000
ST R2,R2_BACKUP_4000
ST R3,R3_BACKUP_4000
ST R4,R4_BACKUP_4000

LD R0,PTR_BUSYNESS_VEC_4000
;bit set to 1 and will iterate through each
AND R1,R1,#0
ADD R1,R1,#1

;bit counter
AND R2,R2,#0

;loop coounter
;adds 16 instead of label cause whatever
AND R3,R3,#0
ADD R3,R3,#12
ADD R3,R3,#4

FOREACH_BIT_4000
  AND R4,R0,R1
  BRz NO_COUNT_4000
  ADD R2,R2,#1
  NO_COUNT_4000
  ADD R1,R1,R1
  ADD R3,R3,#-1
END_4000
  


LD R1,R1_BACKUP_4000
LD R2,R2_BACKUP_4000
LD R3,R3_BACKUP_4000
LD R4,R4_BACKUP_4000
LD R0,R0_BACKUP_4000
RET

R0_BACKUP_4000 .BLKW #1
R1_BACKUP_4000 .BLKW #1
R2_BACKUP_4000 .BLKW #1
R3_BACKUP_4000 .BLKW #1
R4_BACKUP_4000 .BLKW #1
R0_BACKUP_4000 .BLKW #1

ONE_BIT_4000 .FILL #1
PTR_BUSYNESS_VEC_4000 .FILL x5000
;-----------------------------------------------------------------------------------------------------------------
; Subroutine: MACHINE_STATUS
; Input (R1): Which machine to check
; Postcondition: The subroutine has returned a value indicating whether the machine indicated
;                by (R1) is busy or not.
; Return Value (R2): 0 if machine (R1) is busy, 1 if it is free
;-----------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------
; Subroutine: FIRST_FREE
; Inputs: None
; Postcondition:
; The subroutine has returned a value indicating the lowest numbered free machine
; Return Value (R2): the number of the free machine
;-----------------------------------------------------------------------------------------------------------------


.orig x5000
BUSYNESS .FILL x4444



;menu output
;**********************
;* The Busyness Server *
;**********************
;1. Check to see whether all machines are busy
;2. Check to see whether all machines are free
;3. Report the number of busy machines
;4. Report the number of free machines
;5. Report the status of machine n
;6. Report the number of the first available machine
;7. Quit
.orig x5200
MENUSTR_1 .STRINGZ "**********************\n* The Busyness Server*\n**********************\n1. Check to see whether all machines are busy\n2. Check to see whether all machines are free\n3. Report the number of of machines\n4. Report the number of free machines\n5. Report the status of machine #\n6. Report the number of of first available machine\n7. Quit\n"
;
