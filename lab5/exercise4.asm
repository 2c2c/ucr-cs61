;=================================================
; Name: <Collier, Craig>
; Username: ccoll010
; 
; Lab: <lab 5>
; Lab section: 23
; TA: Bryan Marsh
; 
;=================================================


;=================================================
; MAIN
;=================================================
.orig x3000

;if SUB_BINOUT_3200 breaks go back to the beginning of program
LEA R0,PROMPT
PUTS
JSR SUB_BINOUT_3200

HALT

;data
PROMPT        .STRINGZ "ins num 0-20\n"
SUB_BINOUT_3200  .FILL x3200


;=================================================
; SUB_BINOUT_3200
; input: none
; postconditions: asks for input in binary form, converts to dec, reoutputs in bin
; output: none
;=================================================
.orig x3200
SUB_BINOUT_3200

ST R7,R7_BACKUP

LD R0,ZERO
OUT
OUT
OUT
OUT
OUT
OUT
OUT
OUT
OUT
OUT
OUT

GETC
OUT
ADD R1,R0,#0
GETC
OUT
ADD R2,R0,#0

ADD R3,R1,-#2
BRz TWENTY
AND R3,R3,#0
ADD R3,R1,#-1
BRz ONEX
BR ZEROX
ZEROX
    OUT
    AND R3,R3,#0
    ADD R3,R2,#-8
    BRz ZEROZERO
    AND R3,R3,#0
    ADD R3,R2,#-7
    BRz ZEROONE
    AND R3,R3,#0
    ADD R3,R2,#-6
    BRz ZEROTWO
    AND R3,R3,#0
    ADD R3,R2,#-5
    BRz ZEROTHREE
    AND R3,R3,#0
    ADD R3,R2,#-4
    BRz ZEROFOUR
    AND R3,R3,#0
    ADD R3,R2,#-3
    BRz ZEROFIVE
    AND R3,R3,#0
    ADD R3,R2,#-2
    BRz ZEROSIX
    AND R3,R3,#0
    ADD R3,R2,#-1
    BRz ZEROSEVEN
    AND R3,R3,#0
    ADD R3,R2,#0
    BRz ZEROEIGHT
ONEX
    AND R3,R3,#0
    ADD R3,R1,#-6
    BRnz LESS
    BRp MORE
LESS
    LD R0,ZERO
    ZEROX
MORE
    LD R0,ONE
    ZEROX

ZEROONE
LD R0,ZERO
OUT
OUT
OUT
OUT
OUT
OUT
OUT
LD R1,ONE
OUT

ZEROTWO
LD R0,ZERO
OUT
OUT
OUT
OUT
OUT
OUT
LD R0,ONE
OUT
LD R0,ZERO
OUT


ZEROTHREE
LD R0,ZERO
OUT
OUT
OUT
OUT
OUT
OUT
LD R0,ONE
OUT
OUT

ZEROFOUR
LD R0,ZERO
OUT
OUT
OUT
OUT
OUT
LD R0,ONE
OUT
LD R0,ZERO  
OUT
OUT
ZERFIVE
LD R0,ZERO
OUT
OUT
OUT
OUT
OUT
OUT
OUT
LD R1,ONE
OUT
ZEROONE
LD R0,ZERO
OUT
OUT
OUT
OUT
OUT
OUT
OUT
LD R1,ONE
OUT



























    
LD R7,R7_BACKUP
RET

R7_BACKUP .FILL #1
ZERO    .FILL   #'0'
ONE    .FILL   #'1'
.end
