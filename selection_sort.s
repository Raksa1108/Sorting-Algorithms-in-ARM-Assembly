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
ROMARRAY1 DCD 0x0A, 0xFA, 0xDC, 0xA3, 0x08, 0x04, 0x09, 0x02

        AREA |.data|, DATA, READWRITE, ALIGN=4
LEN      EQU 0x08
ARRAY1   SPACE 32

        AREA |.text|, CODE, READONLY, ALIGN=4
        ENTRY
        EXPORT Reset_Handler

Reset_Handler
        MOV     R0, #LEN
        LDR     R1, =ROMARRAY1 + (LEN-1)*4
        LDR     R2, =ARRAY1   + (LEN-1)*4

COPY_LOOP
        LDR     R3, [R1], #-4     
        STR     R3, [R2], #-4     
        SUBS    R0, R0, #1
        BNE     COPY_LOOP
        MOV     R5, #0            

SEL_OUTER
        CMP     R5, #LEN-1
        BGE     SORT_DONE        

        MOV     R6, R5            
        ADD     R7, R5, #1        

SEL_INNER
        CMP     R7, #LEN
        BGE     SEL_SWAP          

        LDR     R1, =ARRAY1
        ADD     R2, R1, R7, LSL #2
        LDR     R3, [R2]          
        ADD     R4, R1, R6, LSL #2
        LDR     R8, [R4]          

        CMP     R3, R8
        BGE     NO_UPDATE
        MOV     R6, R7            

NO_UPDATE
        ADD     R7, R7, #1
        B       SEL_INNER

SEL_SWAP
        CMP     R6, R5
        BEQ     NO_SWAP          

        LDR     R1, =ARRAY1
        ADD     R2, R1, R5, LSL #2
        LDR     R3, [R2]

        ADD     R4, R1, R6, LSL #2
        LDR     R8, [R4]

        ; Do swap
        STR     R8, [R2]
        STR     R3, [R4]

NO_SWAP
        ADD     R5, R5, #1        
        B       SEL_OUTER

SORT_DONE
STOP
        B       STOP

        END
