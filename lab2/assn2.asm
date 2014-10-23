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
    ;Take two input. output 'inp1 - inp2 =' to screen
    GETC
    OUT
    ADD R1,R0,#0
    LD R0,MINUSSIGN
    OUT
    GETC
    OUT
    ADD R2,R0,#0
    LD R0,EQUALSSIGN
    OUT
    ;convert ascii to actual numbers
    ADD R3,R1,#-12
    ADD R4,R2,#-12
    ADD R3,R3,#-12
    ADD R4,R4,#-12
    ADD R3,R3,#-12
    ADD R3,R3,#-12
    ADD R4,R4,#-12
    ADD R4,R4,#-12
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
       ADD R0,R6,#12
       ADD R0,R0,#12
       ADD R0,R0,#12
       ADD R0,R0,#12
       OUT
       HALT

    ;negative case
    TWOCHAR
       ;the negative sign!
       LD R0,MINUSSIGN
       OUT
       ;make the number positive
       NOT R6,R6
       ADD R6,R6,#1

       ;back to ascii
       ADD R0,R6,#12
       ADD R0,R0,#12
       ADD R0,R0,#12
       ADD R0,R0,#12
       OUT
       HALT

    ;data
    MINUSSIGN   .FILL   x2D
    EQUALSSIGN   .FILL   x3D
    DEC_4       .FILL   #4

.end
