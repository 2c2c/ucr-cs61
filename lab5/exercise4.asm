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
; output: R2 <- DEC value of two input digits
;=================================================
.orig x3200
SUB_BINOUT_3200

;backup
ST R7,R7_BACKUP

AND R2,R2,#0
GETC
OUT
;convert to dec
LD R1,ASCII
ADD R0,R0,R1
;straightline mult by 10
ADD R2,R2,#0
ADD R2,R0,#0
ADD R0,R0,R0
ADD R2,R2,R2
ADD R2,R2,R2
ADD R2,R2,R2
ADD R2,R0,R2

GETC
OUT
;convert to dec
ADD R0,R0,R1
ADD R2,R2,R0


;restore
LD R7,R7_BACKUP
;return
RET

R7_BACKUP .FILL #1
ASCII .FILL -x30
.end
