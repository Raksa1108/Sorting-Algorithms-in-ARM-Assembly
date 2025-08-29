        PRESERVE8
Stack   EQU 0x00000100

        AREA STACK, NOINIT, READWRITE, ALIGN=4
StackMem SPACE Stack

        AREA RESET, DATA, READONLY
        EXPORT __Vectors

__Vectors
        DCD StackMem
        DCD Reset_Handler

        AREA tempData, DATA, READONLY, ALIGN=4
ROMARRAY1 DCD 0x0A, 0x07, 0x0C, 0xF3, 0xD8, 0x4A, 0x09, 0x02

        AREA |.data|, DATA, READWRITE, ALIGN=4
LEN      EQU 8
ARRAY1   SPACE (4*LEN)     
TEMPBUF  SPACE (4*LEN)     
COUNT    SPACE (16*4)      
        AREA |.text|, CODE, READONLY, ALIGN=4
        ENTRY
        EXPORT Reset_Handler

Reset_Handler
        MOV     R0, #0
        LDR     R1, =ROMARRAY1
        LDR     R2, =ARRAY1
COPY_LOOP
        CMP     R0, #LEN
        BGE     SORT_START
        LDR     R3, [R1, R0, LSL #2]
        STR     R3, [R2, R0, LSL #2]
        ADD     R0, R0, #1
        B       COPY_LOOP

SORT_START
        MOV     R8, #0              

PASS_LOOP
        CMP     R8, #8
        BGE     SORT_DONE           

        
        LDR     R4, =COUNT
        MOV     R5, #0
        MOV     R0, #0             
CLR_LOOP
        CMP     R5, #16
        BGE     COUNT_CLEARED
        STR     R0, [R4, R5, LSL #2]
        ADD     R5, R5, #1
        B       CLR_LOOP
COUNT_CLEARED

        LDR     R6, =ARRAY1        
        MOV     R5, #0             
COUNT_LOOP
        CMP     R5, #LEN
        BGE     PREFIX_SUM

        LDR     R0, [R6, R5, LSL #2]   
        MOV     R1, R0               
        MOV     R11, R8               

SHIF_LOOP
        CMP     R11, #0
        BEQ     SHIF_DONE
        LSR     R1, R1, #4           
        SUB     R11, R11, #1
        B       SHIF_LOOP
SHIF_DONE
        AND     R1, R1, #0xF          

        LDR     R2, =COUNT
        LDR     R3, [R2, R1, LSL #2]  
        ADD     R3, R3, #1
        STR     R3, [R2, R1, LSL #2]

        ADD     R5, R5, #1
        B       COUNT_LOOP
PREFIX_SUM
        LDR     R4, =COUNT
        MOV     R5, #1
PREFIX_LOOP
        CMP     R5, #16
        BGE     DISTRIBUTE
        LDR     R0, [R4, R5, LSL #2]      
        SUB     R10, R5, #1               
        LDR     R1, [R4, R10, LSL #2]     
        ADD     R0, R0, R1
        STR     R0, [R4, R5, LSL #2]
        ADD     R5, R5, #1
        B       PREFIX_LOOP

DISTRIBUTE
        LDR     R6, =ARRAY1
        LDR     R7, =TEMPBUF
        MOV     R9, #LEN
        SUB     R9, R9, #1         

DIST_LOOP
        CMP     R9, #0
        BLT     COPY_BACK          

        LDR     R0, [R6, R9, LSL #2]  
        MOV     R1, R0                 
        MOV     R11, R8                
DIST_SHIFT_LOOP
        CMP     R11, #0
        BEQ     DIST_SHIFT_DONE
        LSR     R1, R1, #4
        SUB     R11, R11, #1
        B       DIST_SHIFT_LOOP
DIST_SHIFT_DONE
        AND     R1, R1, #0xF           

        LDR     R2, =COUNT
        LDR     R3, [R2, R1, LSL #2]   
        SUB     R3, R3, #1
        STR     R3, [R2, R1, LSL #2]  
        STR     R0, [R7, R3, LSL #2]  

        SUB     R9, R9, #1
        B       DIST_LOOP

COPY_BACK
        MOV     R5, #0
        LDR     R6, =ARRAY1
        LDR     R7, =TEMPBUF
COPYBACK_LOOP
        CMP     R5, #LEN
        BGE     NEXT_PASS
        LDR     R0, [R7, R5, LSL #2]
        STR     R0, [R6, R5, LSL #2]
        ADD     R5, R5, #1
        B       COPYBACK_LOOP

NEXT_PASS
        ADD     R8, R8, #1        
        B       PASS_LOOP

SORT_DONE
STOP
        B       STOP

        END
