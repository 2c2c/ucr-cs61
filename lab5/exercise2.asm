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

;if SUB_GETINPUT breaks go back to the beginning of program
LEA PROMPT
PUTS
JSR SUB_GETINPUT

PROMPT        .STRINGZ "Insert binary formatted number\n"
SUB_GETINPUT  .FILL x3200


.orig x4000
ARRAY .BLKW #16


;=================================================
; SUB_GETINPUT
; input: none
; postcondition: filled array at x4000 with 16 binary character and null
; output: none
;=================================================
.orig x3200
SUB_GETINPUT

;save
ST R7 R7_BACKUP_3200

;the b
GETC
OUT
LD R1,CHAR_B
NOT R0,R0
ADD R0,R0,#1
ADD R0,R0,R1
BRz INVALID_3200
;the number
AND R4,R4,#0
LD R5,DEC_16_3200
WHILE_3200
  AND R2,R2,#0
  GETC
  OUT
  LD R3,ASCIICONVERT
  ADD R0,R0,R3
  ADD R2,R2,R0
  BRz ZERO_3200
  ADD R2,R2,#1
  ADD R2,R2,R0
  BRz ONE_322
  LD R2,SPACE_3200
  NOT R0,R0
  ADD R0,R0,#1
  ADD R0,R0,R2
  BRz SPACECASE_3200
  
  BR INVALID_3200

  ZERO_3200
    ADD R4,R4,R4
    ADD R4,R4,R2
  ONE_3200
    ADD R4,R4,R4
    ADD R4,R4,R2
  SPACECASE_3200
    BR WHILE_3200
  INVALID_3200
    LEA R6, ERROR_3200
    PUTS
    BR WHILE_3200
  ADD R5,R5,#-1
  BRnp WHILE_3200
ENDWHILE_3200

ADD R2,R4,#0
;
;PUT EX1 HERE
;
RET
;restore
LD R7 R7_BACKUP_3200
;return


ASCIICONVERT .FILL x-30
DEC_0 .FILL #0
DEC_1 .FILL #1
DEC_16_3200  .FILL #16
POINTER_3200  .FILL x4000
SPACE_3200 .FILL ' '
ERROR_3200 .STRINGZ "Input valid char pls \n"
CHAR_B .FILL 'b'

