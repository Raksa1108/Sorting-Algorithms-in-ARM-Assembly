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
ROMARRAY1 DCD 0x0A, 0x07, 0x0C, 0x03, 0x08, 0x04, 0x09, 0x02

        AREA |.data|, DATA, READWRITE, ALIGN=4
LEN     		EQU 0x08
ARRAY1  SPACE 32

        AREA |.text|, CODE, READONLY, ALIGN=4
        ENTRY
        EXPORT Reset_Handler
Reset_Handler
Reset_Handler_End
		
        MOV     R0, #LEN
        LDR     R1, =ROMARRAY1 + 28
        LDR     R2, =ARRAY1 + 28

COPY_LOOP
        LDR     R3, [R1], #-4
        STR     R3, [R2], #-4
        SUBS    R0, R0, #1
        BNE     COPY_LOOP
        MOV     R5, #0         
BUBBLE_OUTER
        MOV     R6, #0          
        MOV     R7, #LEN
        SUB     R7, R7, #1      

BUBBLE_INNER
        LDR     R1, =ARRAY1
        ADD     R2, R1, R6, LSL #2      
        LDR     R3, [R2]                
        LDR     R4, [R2, #4]           

        CMP     R3, R4
        BLE     NOSWAP
        STR     R4, [R2]
        STR     R3, [R2, #4]

NOSWAP
        ADD     R6, R6, #1
        SUBS    R7, R7, #1
        BNE     BUBBLE_INNER

        ADD     R5, R5, #1
        CMP     R5, #LEN
        BLT     BUBBLE_OUTER

STOP
        B       STOP

        END
