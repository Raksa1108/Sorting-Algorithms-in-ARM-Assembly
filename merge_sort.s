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
TEMP     SPACE 32

        AREA |.text|, CODE, READONLY, ALIGN=4
        ENTRY
        EXPORT Reset_Handler

Reset_Handler
        MOV     R0, #0
        LDR     R1, =ROMARRAY1
        LDR     R2, =ARRAY1

COPY_FORWARD
        CMP     R0, #LEN
        BGE     COPY_DONE
        LDR     R3, [R1, R0, LSL #2]
        STR     R3, [R2, R0, LSL #2]
        ADD     R0, R0, #1
        B       COPY_FORWARD

COPY_DONE
        MOV     R9, #1          

MS_OUTER
        CMP     R9, #LEN
        BGE     MS_DONE

        MOV     R5, #0        

MS_PASS_LOOP
        CMP     R5, #LEN
        BGE     MS_PASS_DONE

        ADD     R6, R5, R9
        CMP     R6, #LEN
        BLT     MS_USE_MID
        MOV     R6, #LEN
MS_USE_MID

        ADD     R7, R5, R9, LSL #1
        CMP     R7, #LEN
        BLT     MS_USE_END
        MOV     R7, #LEN
MS_USE_END

        MOV     R10, R5         
        MOV     R11, R6         
        MOV     R12, R5         

        LDR     R13, =ARRAY1
        LDR     R14, =TEMP

MS_MERGE_LOOP
        CMP     R10, R6         
        BGE     MS_COPY_RIGHT_REMAIN
        CMP     R11, R7         
        BGE     MS_COPY_LEFT_REMAIN

        LDR     R0, [R13, R10, LSL #2]
        LDR     R1, [R13, R11, LSL #2]
        CMP     R0, R1
        BLE     MS_TAKE_LEFT2
        STR     R1, [R14, R12, LSL #2]
        ADD     R11, R11, #1
        ADD     R12, R12, #1
        B       MS_MERGE_LOOP

MS_TAKE_LEFT2
        STR     R0, [R14, R12, LSL #2]
        ADD     R10, R10, #1
        ADD     R12, R12, #1
        B       MS_MERGE_LOOP

MS_COPY_LEFT_REMAIN
        CMP     R10, R6
        BGE     MS_COPY_RIGHT_REMAIN
MS_COPY_LEFT_LOOP
        CMP     R10, R6
        BGE     MS_COPY_RIGHT_REMAIN
        LDR     R0, [R13, R10, LSL #2]
        STR     R0, [R14, R12, LSL #2]
        ADD     R10, R10, #1
        ADD     R12, R12, #1
        B       MS_COPY_LEFT_LOOP

MS_COPY_RIGHT_REMAIN
        CMP     R11, R7
        BGE     MS_COPYBACK
MS_COPY_RIGHT_LOOP
        CMP     R11, R7
        BGE     MS_COPYBACK
        LDR     R0, [R13, R11, LSL #2]
        STR     R0, [R14, R12, LSL #2]
        ADD     R11, R11, #1
        ADD     R12, R12, #1
        B       MS_COPY_RIGHT_LOOP

MS_COPYBACK
        MOV     R4, R5          
MS_COPYBACK_LOOP
        CMP     R4, R7
        BGE     MS_COPYBACK_DONE
        LDR     R0, [R14, R4, LSL #2]
        STR     R0, [R13, R4, LSL #2]
        ADD     R4, R4, #1
        B       MS_COPYBACK_LOOP

MS_COPYBACK_DONE
        ADD     R5, R5, R9, LSL #1
        B       MS_PASS_LOOP

MS_PASS_DONE
        ADD     R9, R9, R9       
        B       MS_OUTER

MS_DONE
STOP
        B       STOP

        END
