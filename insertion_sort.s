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

        MOV     R5, #1            

INS_OUTER
        CMP     R5, #LEN
        BGE     SORT_DONE     
        LDR     R1, =ARRAY1
        ADD     R2, R1, R5, LSL #2
        LDR     R6, [R2]   
        SUB     R7, R5, #1        

INS_INNER
        CMP     R7, #0
        BLT     PLACE_KEY        

        ; load ARRAY1[j]
        ADD     R3, R1, R7, LSL #2
        LDR     R8, [R3]

        CMP     R8, R6
        BLE     PLACE_KEY         
        STR     R8, [R3, #4]

        SUB     R7, R7, #1
        B       INS_INNER

PLACE_KEY
        ADD     R3, R1, R7, LSL #2
        ADD     R3, R3, #4        
        STR     R6, [R3]         

        ADD     R5, R5, #1        
        B       INS_OUTER

SORT_DONE
STOP
        B       STOP

        END
