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
LEA R0,PROMPT
PUTS
JSR SUB_GETINPUT

HALT

;data
PROMPT        .STRINGZ "Insert binary formatted number\n"
SUB_GETINPUT  .FILL x3200


;=================================================
; SUB_GETINPUT
; input: none
; output: none
;=================================================
.orig x3200
SUB_GETINPUT

;save
ST R7,R7_BACKUP_3200

INVALID_B
;the b
GETC
OUT
LD R1,CHAR_B
NOT R0,R0
ADD R0,R0,#1
ADD R0,R0,R1
BRz CONTINUE
;if it's a b skip over error check
LEA R0,ERROR_3200
PUTS
BR INVALID_B

CONTINUE
;the number
AND R4,R4,#0
LD R5,DEC_16_3200

WHILE_3200
  AND R2,R2,#0
  GETC
  OUT
  LD R3,ASCIICONVERT
  ADD R0,R0,R3

  ;zero
  ADD R2,R2,R0
  BRz ZERO_3200
  ;one
  ADD R6,R2,#-1
  BRz ONE_3200
  ;space
  LD R2,SPACE_3200
  NOT R0,R0
  ADD R0,R0,#1
  ADD R0,R0,R2
  BRz SPACECASE_3200
  
  BR INVALID_3200

  ZERO_3200
    ADD R4,R4,R4
    ADD R4,R4,R2
    BR DONE_3200
  ONE_3200
    ADD R4,R4,R4
    ADD R4,R4,R2
    BR DONE_3200
  SPACECASE_3200
    BR WHILE_3200
  INVALID_3200
    LEA R0, ERROR_3200
    PUTS
    BR WHILE_3200
  DONE_3200
  ADD R5,R5,#-1
  BRnp WHILE_3200
ENDWHILE_3200

ADD R2,R4,#0
;
;PUT EX1 HERE
;
;restore
LD R7,R7_BACKUP_3200
;return
RET


R7_BACKUP_3200 .FILL #1
ASCIICONVERT .FILL -x30
DEC_0 .FILL #0
DEC_1 .FILL #1
DEC_16_3200  .FILL #16
SPACE_3200 .FILL ' '
ERROR_3200 .STRINGZ "Input valid char pls \n"

CHAR_B .FILL 'b'

.end
