;=================================================
; Name:<Collier, Craig>
; Username: ccoll010
; 
; Assignment: assn3
; Lab section: 221
; TA: Bryan Marsh
; 
;=================================================
.orig x3000

LD R1,TEST_VALUE
LD R2,PTR
LDR R3,R2,#0 
LD R6,FOUR
; For each element in array
; AND to check if it shares its 1
; bit with the value. if it does
; print 1, else print 0
FOR_EACH
    ADD R2,R2,#1
    ; and the testvalue against the array
    ; take the result of that and take its 2s compliment
    ; subtract the finished result against the array
    ; if that results in 0 it means that the two were equal
    AND R4,R1,R3
    NOT R4,R4
    ADD R4,R4,#1 
    ADD R5,R3,R4
    BRnp ZEROBIT
    ONEBIT
        LD R0,ONE
        OUT
        BR DONE
    ZEROBIT
        LD R0,ZERO
        OUT 
        BR DONE
    DONE
    ; check for 4 iterations and add space
    ADD R6,R6,#-1
    BRnp NOSPACE
    LD R0,SPACE
    OUT
    LD R6,FOUR
    NOSPACE 

    LDR R3,R2,#0
    ADD R3,R3,#0
    BRnp FOR_EACH
HALT

;data
TEST_VALUE .FILL x1248
ZERO .FILL x30
ONE .FILL x31
PTR .FILL x4000
SPACE .FILL x20
FOUR .FILL #4

;null terminated array of numbers each with only 1 bit active
.orig x4000
BIT1  .FILL  x8000
BIT2  .FILL  x4000
BIT3  .FILL  x2000
BIT4  .FILL  x1000
BIT5  .FILL  x0800
BIT6  .FILL  x0400
BIT7  .FILL  x0200
BIT8  .FILL  x0100
BIT9  .FILL  x0080
BIT10  .FILL x0040
BIT11  .FILL x0020
BIT12  .FILL x0010
BIT13  .FILL x0008
BIT14  .FILL x0004
BIT15  .FILL x0002
BIT16  .FILL x0001
NULL .FILL #0

.end
