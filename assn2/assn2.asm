;=================================================
; Name: <Collier, Craig>
; Username: ccoll010
; 
; Assignment: <assn 2>
; Lab section: 026
; TA: Bryan Marsh
; 
;=================================================
.orig x3000
    ;Take the two inputs and copy to separate registers
    OUT
    ADD R1,R0,#0
    OUT
    ADD R2,R0,#0
    ;convert to actual numbers
    ADD R3,R1,#-48
    ADD R4,R2,#-48
    ;make negative version of 2nd number
    NOT R5,R4
    ADD R5,R5,#1
    ;'subtract'
    ADD R6,R3,R5

    ;if the result is negative, skip over ONECHAR
    BRn TWOCHAR

    ;positive case
    ;convert back to char and output
    ONECHAR
       ADD R0,R1,#0
       GETC
       LD R0,MINUSSIGN
       GETC
       ADD R0,R2,#0
       GETC
       LD R0,EQUALSSIGN
       GETC
       ADD R0,R6,#48
       GETC
       HALT


    ;negative case
    TWOCHAR
       ADD R0,R1,#0
       GETC
       LD R0,MINUSSIGN
       GETC
       ADD R0,R2,#0
       GETC
       LD R0,EQUALSSIGN
       GETC
       ;the negative sign!
       LD R0,MINUSSIGN
       GETC
       ADD R0,R6,#48
       GETC
       HALT

    ;data
    MINUSSIGN   .FILL   '-'
    EQUALSIGN   .FILL   '='

.end
