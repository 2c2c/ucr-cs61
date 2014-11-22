;=================================================
; Name: <Collier, Craig>
; Username: ccoll010
; 
; assn: assn6
; Lab section: 221
; TA: Bryan Marsh
; 
;=================================================

;-----------------------------------------------------------------------------------------------------------------
; MAIN
;-----------------------------------------------------------------------------------------------------------------
.orig x3000

RESTART_MAIN

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
    BR RESTART_MAIN
CHOOSE_OPTION2
    LD R0,OPTION2
    JSRR R0
    BR RESTART_MAIN
CHOOSE_OPTION3
    LD R0,OPTION3
    JSRR R0
    BR RESTART_MAIN
CHOOSE_OPTION4
    LD R0,OPTION4
    JSRR R0
    BR RESTART_MAIN
CHOOSE_OPTION5
    LD R0,OPTION5
    JSRR R0
    BR RESTART_MAIN
CHOOSE_OPTION6
    LD R0,OPTION6
    JSRR R0
    BR RESTART_MAIN
CHOOSE_OPTION7
    LD R0,OPTION7
    JSRR R0
    LEA R0,MSG_GOODBYE
    PUTS
    BR END_MAIN
BR RESTART_MAIN

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
MSG_GOODBYE .STRINGZ "7-> Goodbye\n"

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
;returns number picked in R1
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
ST R7,R7_BACKUP_3400

LD R0,PTR_BUSYNESS_VEC_3400
LDR R0,R0,#0
BRz BUSY_3400
LEA R0,MSG_ALLNOT_BUSY_3400
PUTS
AND R2,R2,#0
BR NOTBUSY_3400

BUSY_3400
  AND R2,R2,#0
  ADD R2,R2,#1 
  LEA R0,MSG_ALLBUSY_3400
  PUTS
NOTBUSY_3400







LD R0,R0_BACKUP_3400
LD R7,R7_BACKUP_3400

RET

PTR_BUSYNESS_VEC_3400 .FILL  x5000
MSG_ALLBUSY_3400 .STRINGZ "1-> All of the machines are busy\n"
MSG_ALLNOT_BUSY_3400 .STRINGZ "1-> All of the machines are not busy\n"
R0_BACKUP_3400 .BLKW #1
R7_BACKUP_3400 .BLKW #1

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
ST R7,R7_BACKUP_3600

LD R0,PTR_BUSYNESS_VEC_3600
LDR R0,R0,#0
ADD R0,R0,#1
BRz FREE_3600
LEA R0,MSG_ALLNOTFREE_3600
PUTS
AND R2,R2,#0
BR NOTFREE_3600

FREE_3600
  AND R2,R2,#0
  ADD R2,R2,#1 
  LEA R0,MSG_ALLFREE_3600
  PUTS
NOTFREE_3600


LD R0,R0_BACKUP_3600
LD R7,R7_BACKUP_3600

RET

PTR_BUSYNESS_VEC_3600 .FILL  x5000
MSG_ALLFREE_3600 .STRINGZ "2-> All of the machines are free\n"
MSG_ALLNOTFREE_3600 .STRINGZ "2-> All of the machines are not free\n"
R0_BACKUP_3600 .BLKW #1
R7_BACKUP_3600 .BLKW #1

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: NUM_BUSY_MACHINES
; Inputs: None
; Postcondition: The subroutine has returned the number of busy machines.
; Return Value (R2): The number of machines that are busy
;-----------------------------------------------------------------------------------------------------------------
.orig x3800
SUB_NUM_BUSY_MACHINES

ST R0,R0_BACKUP_3800
ST R5,R5_BACKUP_3800
ST R7,R7_BACKUP_3800

AND R5,R5,#0
ADD R5,R5,#1
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

ADD R6,R2,#0
LEA R0,MSG_FIRSTPIECE_3800
PUTS

LD R0,PTR_PRINTNUM_3800
JSRR R0

LEA R0,MSG_SECONDPIECE_3800
PUTS
LD R0,R0_BACKUP_3800
LD R5,R5_BACKUP_3800
LD R7,R7_BACKUP_3800

RET

PTR_NUM_FREE_MACHINES .FILL x4000
MSG_FIRSTPIECE_3800 .STRINGZ "3-> There are "
MSG_SECONDPIECE_3800 .STRINGZ " busy machines currently\n"
PTR_PRINTNUM_3800 .FILL x5400
R0_BACKUP_3800 .BLKW  #1
R5_BACKUP_3800 .BLKW  #1
R7_BACKUP_3800 .BLKW  #1

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: NUM_FREE_MACHINES
; Inputs: R5
; Postcondition: The subroutine has returned the number of free machines. R5 tells not to print
; Return Value (R2): The number of machines that are free
;-----------------------------------------------------------------------------------------------------------------
.orig x4000
SUB_NUM_FREE_MACHINES

ST R0,R0_BACKUP_4000
ST R1,R1_BACKUP_4000
ST R3,R3_BACKUP_4000
ST R4,R4_BACKUP_4000
ST R5,R5_BACKUP_4000
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
  
  ADD R6,R2,#0

;flag R5 warns that busy is using this fn for information 
;and doesn't want the print section
ADD R5,R5,#-1
BRz SKIP_PRINT_4000

LEA R0,MSG_FIRSTPIECE_4000
PUTS

LD R0,PTR_PRINTNUM_4000
JSRR R0

LEA R0,MSG_SECONDPIECE_4000
PUTS
SKIP_PRINT_4000

LD R0,R0_BACKUP_4000
LD R1,R1_BACKUP_4000
LD R3,R3_BACKUP_4000
LD R4,R4_BACKUP_4000
LD R5,R5_BACKUP_4000
LD R7,R7_BACKUP_4000
RET

R0_BACKUP_4000 .BLKW #1
R1_BACKUP_4000 .BLKW #1
R3_BACKUP_4000 .BLKW #1
R4_BACKUP_4000 .BLKW #1
R5_BACKUP_4000 .BLKW #1
R7_BACKUP_4000 .BLKW #1

PTR_PRINTNUM_4000 .FILL x5400
ONE_BIT_4000 .FILL #1
MSG_FIRSTPIECE_4000 .STRINGZ "4-> There are "
MSG_SECONDPIECE_4000 .STRINGZ " free machines currently\n"
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
ST R5,R5_BACKUP_4200
ST R7,R7_BACKUP_4200

;prompt bus input fn
LD R0,PTR_BINOUT_4200
JSRR R0

ADD R6,R1,#0
;print beginnings
LEA R0,MSG_FIRSTPIECE_4200
PUTS
LD R0,PTR_PRINTNUM_4200
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
    LEA R0,MSG_FREE
    PUTS
    BR END_4200
BUSYCASE_4200
    AND R2,R2,#0
    LEA R0,MSG_BUSY
    PUTS
    BR END_4200


END_4200

LD R0,R0_BACKUP_4200
LD R1,R1_BACKUP_4200
LD R5,R5_BACKUP_4200
LD R7,R7_BACKUP_4200
RET



SINGLE_BIT_4200 .FILL x8000
PTR_BUSYNESS_VEC_4200 .FILL x5000
PTR_RIGHTSHIFT_4200 .FILL x4800
PTR_BINOUT_4200 .FILL x4400
MSG_FIRSTPIECE_4200 .STRINGZ "\n5-> The state of machine "
MSG_FREE .STRINGZ " is FREE\n"
MSG_BUSY .STRINGZ " is BUSY\n"
PTR_PRINTNUM_4200 .FILL x5400
R0_BACKUP_4200 .BLKW #1
R1_BACKUP_4200 .BLKW #1
R5_BACKUP_4200 .BLKW #1
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
ST R3,R3_BACKUP_4400
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
LD R3,R3_BACKUP_4400
LD R7,R7_BACKUP_4400
;return
RET

R7_BACKUP_4400 .FILL #1
ASCII_4400 .FILL -x30
PROMPT_4400 .STRINGZ "\nWhich machine status to you want to see (0-15)\n"
INVALID_4400 .STRINGZ "\nInvalid input, try again (0-15)\n"
ASCII_ENTER_4400 .FILL '\n'

R0_BACKUP_4400 .BLKW #1
R3_BACKUP_4400 .BLKW #1
R2_BACKUP_4400 .BLKW #1
R7_BACKUP_4400 .BLKW #1

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: FIRST_FREE
; Inputs: None
; Postcondition:
; The subroutine has returned a value indicating the lowest numbered free machine
; Return Value (R2): the number of the free machine
;-----------------------------------------------------------------------------------------------------------------
.orig x4600
SUB_FIRST_FREE

ST R0,R0_BACKUP_4600
ST R1,R1_BACKUP_4600
ST R3,R3_BACKUP_4600
ST R4,R4_BACKUP_4600
ST R5,R5_BACKUP_4600
ST R7,R7_BACKUP_4600

;position counter
AND R2,R2,#0
;16 iterations limitor
AND R1,R1,#0
ADD R1,R1,#12
ADD R1,R1,#4

LD R5,FIRST_BIT_4600
LD R4,PTR_BUSYNESS_VECTOR_4600
LDR R4,R4,#0

;iterate right shifts till free machine is found
RIGHTSHIFT_4600
     AND R3,R4,R5
     BRnp FINSHIFT_4600   
     LD R0,PTR_RIGHTSHIFT_4600
     JSRR R0
     ADD R2,R2,#1
     ADD R1,R1,#-1
     BRz FINSHIFT_4600
     BR RIGHTSHIFT_4600
FINSHIFT_4600


;print
LEA R0,MSG_FIRSTPIECE_4600
PUTS

ADD R6,R2,#0
LD R0,PTR_PRINTNUM_4600
JSRR R0

LEA R0,MSG_SECONDPIECE_4600
PUTS

LD R0,R0_BACKUP_4600
LD R1,R1_BACKUP_4600
LD R3,R3_BACKUP_4600
LD R4,R4_BACKUP_4600
LD R5,R5_BACKUP_4600
LD R7,R7_BACKUP_4600

RET


FIRST_BIT_4600 .FILL x8000
PTR_BUSYNESS_VECTOR_4600 .FILL x5000
PTR_RIGHTSHIFT_4600 .FILL x4800
MSG_FIRSTPIECE_4600 .STRINGZ "6-> The first free machine is "
MSG_SECONDPIECE_4600 .STRINGZ "\n"
PTR_PRINTNUM_4600 .FILL x5400

R0_BACKUP_4600 .BLKW #1
R1_BACKUP_4600 .BLKW #1
R3_BACKUP_4600 .BLKW #1
R4_BACKUP_4600 .BLKW #1
R5_BACKUP_4600 .BLKW #1
R7_BACKUP_4600 .BLKW #1



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
      
      LD R1,FRONT_BIT_4800
      LD R2, DEC_15_4800
    FOREACH_4800
      ADD R2,R2,#0
      BRnz FIN_4800
      ;check testval vs frotnt bit
      AND R3,R5,R1
      BRz ZERO_CASE_4800
      BR ONE_CASE_4800

      ;on each left shift we account for the truncated 0/1
      ;by adding to the right end of the number the trunacted 0/1
      ZERO_CASE_4800
        ADD R5,R5,R5
        ADD R2,R2,#-1
        BR FOREACH_4800

      ONE_CASE_4800
        ADD R5,R5,R5
        ADD R5,R5,#1
        ADD R2,R2,#-1
        BR FOREACH_4800
      FIN_4800




    LD R0,R0_BACKUP_4800
    LD R1,R1_BACKUP_4800
    LD R2,R2_BACKUP_4800
    LD R3,R3_BACKUP_4800
    LD R4,R4_BACKUP_4800
    LD R7,R7_BACKUP_4800

    RET

;DATA
DEC_15_4800 .FILL #15
FRONT_BIT_4800 .FILL x8000
R0_BACKUP_4800 .BLKW #1
R1_BACKUP_4800 .BLKW #1
R2_BACKUP_4800 .BLKW #1
R3_BACKUP_4800 .BLKW #1
R4_BACKUP_4800 .BLKW #1
R5_BACKUP_4800 .BLKW #1
R6_BACKUP_4800 .BLKW #1
R7_BACKUP_4800 .BLKW #1





;=================================================
; SUB_PRINT_NUM
; input:         R6
; postcondition: Given literal number input, outputs character form
; output:        
;=================================================
.orig x5400
SUB_PRINT_NUM

ST R0,R0_BACKUP_5400
ST R1,R1_BACKUP_5400
ST R6,R6_BACKUP_5400
ST R2,R2_BACKUP_5400
ST R3,R3_BACKUP_5400
ST R4,R4_BACKUP_5400
ST R7,R7_BACKUP_5400

;flip input if it is negative, apply flag to output minus sign if necessary
ADD R6,R6,#0
BRz ZERO_CASE_5400
BRn NEG_CASE_5400
BR NORM_CASE_5400

ZERO_CASE_5400
    LD R4, ASCII_TOCHAR_5400
    ADD R0,R6,R4
    OUT
    BR SKIP_5400_5
NEG_CASE_5400
    LD R0,MINUSCHAR_5400
    OUT
    NOT R6,R6
    ADD R6,R6,#1
NORM_CASE_5400

;store in R0, convert to ascii and output front digit
LD R0,DEC_10000_5400
AND R3,R3,#0


;this could very clearly have been rolled into a loop
;the use for it started much simpler and simply pasting it 5 times for
;output was actually faster than constructing a loop
;complexity has built up and adding to it made more sense than fixing it

;flag R1 signifies there's been a nonzero number output
;this manages leading zeroes
AND R1,R1,#0

DECR_10000_5400
    ADD R2,R6,#0
    ADD R2,R2,R0
    BRn DONE_10000_5400
    ADD R3,R3,#1
    ADD R6,R2,#0
    BR DECR_10000_5400
DONE_10000_5400
    LD R4, ASCII_TOCHAR_5400
    ADD R0,R3,R4
    LD R5,ASCII_TONUM_5400
    ADD R5,R5,R0
    ADD R5,R5,R1
    BRz SKIP_5400_1
    ADD R1,R1,#1
    OUT
SKIP_5400_1

LD R0,DEC_1000_5400
AND R3,R3,#0
DECR_1000_5400
    ADD R2,R6,#0
    ADD R2,R2,R0
    BRn DONE_1000_5400
    ADD R3,R3,#1
    ADD R6,R2,#0
    BR DECR_1000_5400
DONE_1000_5400
    LD R4, ASCII_TOCHAR_5400
    ADD R0,R3,R4
    LD R5,ASCII_TONUM_5400
    ADD R5,R5,R0
    ADD R5,R5,R1
    BRz SKIP_5400_2 
    ADD R1,R1,#1
    OUT

SKIP_5400_2
LD R0,DEC_100_5400
AND R3,R3,#0
DECR_100_5400
    ADD R2,R6,#0
    ADD R2,R2,R0
    BRn DONE_100_5400
    ADD R3,R3,#1
    ADD R6,R2,#0
    BR DECR_100_5400
DONE_100_5400
    LD R4, ASCII_TOCHAR_5400
    ADD R0,R3,R4
    LD R5,ASCII_TONUM_5400
    ADD R5,R5,R0
    ADD R5,R5,R1
    BRz SKIP_5400_3
    ADD R1,R1,#1
    OUT


SKIP_5400_3
LD R0,DEC_10_5400
AND R3,R3,#0
DECR_10_5400
    ADD R2,R6,#0
    ADD R2,R2,R0
    BRn DONE_10_5400
    ADD R3,R3,#1
    ADD R6,R2,#0
    BR DECR_10_5400
DONE_10_5400
    LD R4, ASCII_TOCHAR_5400
    ADD R0,R3,R4
    LD R5,ASCII_TONUM_5400
    ADD R5,R5,R0
    ADD R5,R5,R1
    BRz SKIP_5400_4
    ADD R1,R1,#1
    OUT

SKIP_5400_4
LD R0,DEC_1_5400
AND R3,R3,#0
DECR_1_5400
    ADD R2,R6,#0
    ADD R2,R2,R0
    BRn DONE_1_5400
    ADD R3,R3,#1
    ADD R6,R2,#0
    BR DECR_1_5400
DONE_1_5400
    LD R4, ASCII_TOCHAR_5400
    ADD R0,R3,R4
    LD R5,ASCII_TONUM_5400
    ADD R5,R5,R0
    ADD R5,R5,R1
    BRz SKIP_5400_5
    ADD R1,R1,#1
    OUT
SKIP_5400_5

;restore
LD R0,R0_BACKUP_5400
LD R1,R1_BACKUP_5400
LD R6,R6_BACKUP_5400
LD R2,R2_BACKUP_5400
LD R3,R3_BACKUP_5400
LD R4,R4_BACKUP_5400
LD R7,R7_BACKUP_5400

RET


R0_BACKUP_5400 .BLKW #1
R1_BACKUP_5400 .BLKW #1
R6_BACKUP_5400 .BLKW #1
R2_BACKUP_5400 .BLKW #1
R3_BACKUP_5400 .BLKW #1
R4_BACKUP_5400 .BLKW #1
R7_BACKUP_5400 .BLKW #1

ASCII_TOCHAR_5400 .FILL x30
ASCII_TONUM_5400 .FILL -x30
MINUSCHAR_5400 .FILL '-'
DEC_10000_5400 .FILL #-10000
DEC_1000_5400 .FILL #-1000
DEC_100_5400 .FILL #-100
DEC_10_5400 .FILL #-10
DEC_1_5400 .FILL #-1



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
MENUSTR_1 .STRINGZ "\n\n**********************\n* The Busyness Server*\n**********************\n1. Check to see whether all machines are busy\n2. Check to see whether all machines are free\n3. Report the number of busy machines\n4. Report the number of free machines\n5. Report the status of machine #\n6. Report the number of of first available machine\n7. Quit\n\n"
;

.orig x5000
BUSYNESS .FILL x00FF

.end
