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
OPTION6 .FILL x4600
OPTION7 .FILL x4800

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

LD R0,PTR_BUSYNESS_VEC_3400
LDR R0,R0,#0
BRz BUSY_3400
BR NOTBUSY_3400

AND R2,R2,#0
BUSY_3400
  ADD R2,R2,#1 
NOTBUSY_3400

RET

LD R0,R0_BACKUP_3400


PTR_BUSYNESS_VEC_3400 .FILL  x5000
R0_BACKUP_3400 .BLKW #1

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: ALL_MACHINES_FREE
; Inputs: None
; Postcondition: The subroutine has returned a value indicating whether all machines are free
; Return value (R2): 1 if all machines are free, 0 otherwise
;-----------------------------------------------------------------------------------------------------------------
;1 means free 0 means busy
.orig x3600
SUB_ALL_MACHINES_FREE

ST R0,R0_BACKUP_3600

LD R0,PTR_BUSYNESS_VEC_3600
LDR R0,R0,#0
ADD R0,R0,#1
BRz BUSY_3600
BR FREE_3600

AND R2,R2,#0
BUSY_3600
  ADD R2,R2,#1 
FREE_3600

RET

LD R0,R0_BACKUP_3600


PTR_BUSYNESS_VEC_3600 .FILL  x5000
R0_BACKUP_3600 .BLKW #1

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: NUM_BUSY_MACHINES
; Inputs: None
; Postcondition: The subroutine has returned the number of busy machines.
; Return Value (R2): The number of machines that are busy
;-----------------------------------------------------------------------------------------------------------------
.orig x3800
SUB_NUM_BUSY_MACHINES

ST R0,R0_BACKUP_3800
ST R7,R7_BACKUP_3800

LD R0,PTR_NUM_FREE_MACHINES
JSRR R0
;fill reg with 16
AND R0,R0,#0
ADD R0,R0,#12
ADD R0,R0,#4
;flip what's currently in R2
NOT R2,R2
ADD R2,R2,#1
;16 - what was in R2 = num busy
ADD R2,R2,R0

LD R0,R0_BACKUP_3800
LD R7,R7_BACKUP_3800

RET

PTR_NUM_FREE_MACHINES .FILL x4000
R0_BACKUP_3800 .BLKW  #1
R7_BACKUP_3800 .BLKW  #1

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
ST R3,R3_BACKUP_4000
ST R4,R4_BACKUP_4000
ST R7,R7_BACKUP_4000

LD R0,PTR_BUSYNESS_VEC_4000
LDR R0,R0,#0
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
  BRnp FOREACH_BIT_4000
END_4000
  


LD R1,R1_BACKUP_4000
LD R3,R3_BACKUP_4000
LD R4,R4_BACKUP_4000
LD R0,R0_BACKUP_4000
ST R7,R7_BACKUP_4000
RET

R0_BACKUP_4000 .BLKW #1
R1_BACKUP_4000 .BLKW #1
R3_BACKUP_4000 .BLKW #1
R4_BACKUP_4000 .BLKW #1
R7_BACKUP_4000 .BLKW #1

ONE_BIT_4000 .FILL #1
PTR_BUSYNESS_VEC_4000 .FILL x5000


;-----------------------------------------------------------------------------------------------------------------
; Subroutine: MACHINE_STATUS
; Input (R1): Which machine to check
; Postcondition: The subroutine has returned a value indicating whether the machine indicated
;                by (R1) is busy or not.
; Return Value (R2): 0 if machine (R1) is busy, 1 if it is free
;-----------------------------------------------------------------------------------------------------------------

.orig x4200
SUB_MACHINE_STATUS

ST R0,R0_BACKUP_4200
ST R1,R1_BACKUP_4200
ST R7,R7_BACKUP_4200

;prompt bus input fn
LD R0,PTR_BINOUT_4200
JSRR R0

;fill front bit in register
;right shift n times where n is the bus requested
LD R5,SINGLE_BIT_4200
RIGHTSHIFT_4200
    ADD R1,R1,#0
    BRnz ENDSHIFT_4200
    ;exec rightshift
    LD R0,PTR_RIGHTSHIFT_4200
    JSRR R0
    ADD R1,R1,#-1
    BR RIGHTSHIFT_4200
ENDSHIFT_4200

;mask the shifted bit over busyvec to see if the bit is busy or not

LD R1,PTR_BUSYNESS_VEC_4200
LDR R1,R1,#0
AND R1,R5,R1

;if nonzero the machine is free
;return 1
;else 0
BRnp FREECASE_4200
BR BUSYCASE_4200

FREECASE_4200
    AND R2,R2,#0
    ADD R2,R2,#1
    BR END_4200
BUSYCASE_4200
    AND R2,R2,#0
    BR END_4200


END_4200

LD R0,R0_BACKUP_4200
LD R1,R1_BACKUP_4200
LD R7,R7_BACKUP_4200
RET



SINGLE_BIT_4200 .FILL x8000
PTR_BUSYNESS_VEC_4200 .FILL x5000
PTR_RIGHTSHIFT_4200 .FILL x4800
PTR_BINOUT_4200 .FILL x4400

R0_BACKUP_4200 .BLKW #1
R1_BACKUP_4200 .BLKW #1
R7_BACKUP_4200 .BLKW #1


;-------------------------------------------------
; SUB_BINOUT_4400
; input: none
; postconditions: asks for input in binary form, converts to dec, stores result in a register
; output: R1 <- DEC value of two input digits
;-------------------------------------------------

.orig x4400
SUB_BINOUT

;backup
ST R0,R0_BACKUP_4400
ST R2,R2_BACKUP_4400
ST R7,R7_BACKUP_4400

BR START_POINT

;jump to beginning at invalid input
INVALID_INPUT_4400
LEA R0,INVALID_4400
PUTS


;begin past the error input dialog
START_POINT
;prompt
LEA R0,PROMPT_4400
PUTS

;empty R1 and get input
AND R1,R1,#0
GETC
OUT
;convert to dec
LD R2,ASCII_4400
ADD R0,R0,R2

;copy first dig to separate place 
ADD R3,R0,#0


GETC
OUT

;check if second num is enter
LD R1,ASCII_ENTER_4400
NOT R1,R1
ADD R1,R1,#1
ADD R1,R1,R0
BRz ENTER_CASE_4400

;convert second num to dec
ADD R0,R0,R2

;straightline mult by 10
ADD R1,R1,#0
ADD R1,R3,#0
ADD R3,R3,R3
ADD R1,R1,R1
ADD R1,R1,R1
ADD R1,R1,R1
ADD R1,R3,R1

;convert to dec
ADD R1,R1,R0
BR FIN_4400
;entercase just skips multiplying to 10s place and places the first number entered back
;into position to be read
ENTER_CASE_4400
    ADD R1,R3,#0
FIN_4400



;validation
BRn INVALID_INPUT_4400
ADD R0,R1,#-10
ADD R0,R0,#-5
BRp INVALID_INPUT_4400

;restore
LD R0,R0_BACKUP_4400
LD R2,R2_BACKUP_4400
LD R7,R7_BACKUP_4400
;return
RET

R7_BACKUP_4400 .FILL #1
ASCII_4400 .FILL -x30
PROMPT_4400 .STRINGZ "\nWhich machine status to you want to see (0-15)\n"
INVALID_4400 .STRINGZ "\nInvalid input, try again (0-15)\n"
ASCII_ENTER_4400 .FILL '\n'

R0_BACKUP_4400 .BLKW #1
R2_BACKUP_4400 .BLKW #1
R7_BACKUP_4400 .BLKW #1

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: FIRST_FREE
; Inputs: None
; Postcondition:
; The subroutine has returned a value indicating the lowest numbered free machine
; Return Value (R2): the number of the free machine
;-----------------------------------------------------------------------------------------------------------------

;=================================================
; SUB_RIGHT_SHIFT
; input:         R5
; postcondition: applies right shift to input
; output:        R5
;=================================================
.orig x4800
SUB_RIGHT_SHIFT
    
    ;store
    ST R0,R0_BACKUP_4800
    ST R1,R1_BACKUP_4800
    ST R2,R2_BACKUP_4800
    ST R3,R3_BACKUP_4800
    ST R4,R4_BACKUP_4800
    ST R7,R7_BACKUP_4800
      
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




    LD R0,R0_BACKUP_4800
    LD R1,R1_BACKUP_4800
    LD R2,R2_BACKUP_4800
    LD R3,R3_BACKUP_4800
    LD R4,R4_BACKUP_4800
    LD R7,R7_BACKUP_4800

    RET

;DATA
DEC_15 .FILL #15
FRONT_BIT .FILL x8000
R0_BACKUP_4800 .BLKW #1
R1_BACKUP_4800 .BLKW #1
R2_BACKUP_4800 .BLKW #1
R3_BACKUP_4800 .BLKW #1
R4_BACKUP_4800 .BLKW #1
R5_BACKUP_4800 .BLKW #1
R6_BACKUP_4800 .BLKW #1
R7_BACKUP_4800 .BLKW #1

.orig x5000
BUSYNESS .FILL x0006



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
MENUSTR_1 .STRINGZ "**********************\n* The Busyness Server*\n**********************\n1. Check to see whether all machines are busy\n2. Check to see whether all machines are free\n3. Report the number of busy machines\n4. Report the number of free machines\n5. Report the status of machine #\n6. Report the number of of first available machine\n7. Quit\n"
;




.end
