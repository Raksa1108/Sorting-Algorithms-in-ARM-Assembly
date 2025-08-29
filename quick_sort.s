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

QSSTACK  SPACE 128       

        AREA |.text|, CODE, READONLY, ALIGN=4
        ENTRY
        EXPORT Reset_Handler

Reset_Handler
        MOV     R0, #0
        LDR     R1, =ROMARRAY1
        LDR     R2, =ARRAY1
COPY_LOOP
        CMP     R0, #LEN
        BGE     COPY_DONE
        LDR     R3, [R1, R0, LSL #2]
        STR     R3, [R2, R0, LSL #2]
        ADD     R0, R0, #1
        B       COPY_LOOP
COPY_DONE

        LDR     R4, =QSSTACK
        MOV     R5, #0       
        MOV     R6, #LEN-1    
        STR     R5, [R4]
        STR     R6, [R4, #4]
        MOV     R7, #8        

QS_MAIN_LOOP
        CMP     R7, #0
        BEQ     QS_DONE     
        SUB     R7, R7, #8
        ADD     R0, R4, R7
        LDR     R5, [R0]     
        LDR     R6, [R0, #4] 

        CMP     R5, R6
        BGE     QS_MAIN_LOOP  ;
        MOV     R8, R5        
        SUB     R8, R8, #1
        MOV     R9, R5        
        LDR     R10, =ARRAY1
        LDR     R11, [R10, R6, LSL #2]

PART_LOOP
        CMP     R9, R6
        BGE     PART_DONE
        LDR     R0, [R10, R9, LSL #2]
        CMP     R0, R11
        BGT     NO_SWAP
        ADD     R8, R8, #1
        LDR     R1, [R10, R8, LSL #2]
        STR     R0, [R10, R8, LSL #2]
        STR     R1, [R10, R9, LSL #2]
NO_SWAP
        ADD     R9, R9, #1
        B       PART_LOOP

PART_DONE
        ADD     R8, R8, #1
        LDR     R0, [R10, R8, LSL #2]
        LDR     R1, [R10, R6, LSL #2]
        STR     R1, [R10, R8, LSL #2]
        STR     R0, [R10, R6, LSL #2]

        MOV     R12, R8    
        CMP     R12, R5
        BEQ     SKIP_LEFT
        ADD     R0, R4, R7
        STR     R5, [R0]
        SUB     R1, R12, #1
        CMP     R1, R5
        BLT     SKIP_LEFT
        STR     R1, [R0, #4]
        ADD     R7, R7, #8
SKIP_LEFT

        CMP     R12, R6
        BEQ     SKIP_RIGHT
        ADD     R0, R4, R7
        ADD     R1, R12, #1
        CMP     R1, R6
        BGT     SKIP_RIGHT
        STR     R1, [R0]
        STR     R6, [R0, #4]
        ADD     R7, R7, #8
SKIP_RIGHT

        B       QS_MAIN_LOOP

QS_DONE
STOP
        B       STOP

        END
