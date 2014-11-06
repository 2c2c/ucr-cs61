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
; postconditions: asks for input in binary form, converts to dec, reoutputs in bin
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
;newline for re-output
LD R0,RETURN

JSR SUB_OUTBIN_3400

OUT

;restore
LD R7,R7_BACKUP_3200
;return
RET



SUB_OUTBIN_3400 .FILL x3400
R7_BACKUP_3200 .FILL #1
ASCIICONVERT .FILL -x30
DEC_0 .FILL #0
DEC_1 .FILL #1
DEC_16_3200  .FILL #16
SPACE_3200 .FILL ' '
ERROR_3200 .STRINGZ "Input valid char pls \n"

RETURN .FILL '\n'
CHAR_B .FILL 'b'

;-------------------------
; Subroutine SUB_OUTBIN_3400
; PARAMS: R2
; Post Conditions: Output R2 value in binary format
; Returns: none
;
;store original state
.orig x3400
SUB_OUTBIN_3400

ST R0,BACKUP_R0_3400
ST R2,BACKUP_R2_3400
ST R1,BACKUP_R1_3400
ST R3,BACKUP_R3_3400
ST R4,BACKUP_R4_3400
ST R5,BACKUP_R5_3400
ST R6,BACKUP_R6_3400
ST R7,BACKUP_R7_3400

;algorithm
;reuse R1 as #16 for increment
LD R1,DEC_16_3400
LD R0,CHAR_B_3400
LD R6,FOUR_3400
OUT
;output contents of actual array value loop 
FOR_EACH
  ; and 6he value
  ; take the result of that and take its 2s compliment
  ; subtract the finished result against the array
  ; if that results in 0 it means that the two were equal
  LD R3,HIGH_BIT_3400
  AND R4,R2,R3
  NOT R4,R4
  ADD R4,R4,#1 
  ADD R4,R3,R4
  BRnp ZERO_3400BIT
  ONE_3400BIT
    LD R0,ONE_3400
    OUT
    BR DONE_3400
  ZERO_3400BIT
    LD R0,ZERO_3400
    OUT 
    BR DONE_3400
  DONE_3400
  ; check for 4 iterations and add space
  ADD R6,R6,#-1
  BRnp NOSPACE_3400
  LD R0,SPACE_3400
  OUT
  LD R6,FOUR_3400
  NOSPACE_3400 

  ADD R2,R2,R2
  ADD R1,R1,#-1
BRnp FOR_EACH

;reload original data
LD R0,BACKUP_R0_3400
LD R2,BACKUP_R2_3400
LD R1,BACKUP_R1_3400
LD R3,BACKUP_R3_3400
LD R4,BACKUP_R4_3400
LD R5,BACKUP_R5_3400
LD R6,BACKUP_R6_3400
LD R7,BACKUP_R7_3400

;RETURN
RET



;backup data
BACKUP_R0_3400 .FILL #1
BACKUP_R2_3400 .FILL #1
BACKUP_R1_3400 .FILL #1
BACKUP_R3_3400 .FILL #1
BACKUP_R4_3400 .FILL #1
BACKUP_R5_3400 .FILL #1
BACKUP_R6_3400 .FILL #1
BACKUP_R7_3400 .FILL #1
POINTER_3400 .FILL x4000
CHAR_B_3400 .FILL x62
HIGH_BIT_3400 .FILL x8000
DEC_16_3400 .FILL #16

;vv from assn3 vv
ZERO_3400 .FILL x30
ONE_3400 .FILL x31
SPACE_3400 .FILL x20
FOUR_3400 .FILL #4



.end
