ORG 0x7C00              ; offset for 'Legacy' bios mode
BITS 16                 ; compile for 16 bit cpu

%define ENDL 0x0D, 0x0A


start:
    JMP main

;
; Prints a string to the screen
; Params:
;   - ds:si points to string
;
puts:
    ; save registers we will modify
    PUSH si
    PUSH ax
    PUSH bx

.loop:
    LODSB               ; loads next character in al
    OR al, al           ; veify if next character is null?
    JZ .done

    MOV ah, 0x0E        ; call bios interrupt
    MOV bh, 0           ; set page number to 0
    INT 0x10

    JMP .loop

.done:
    POP bx
    POP ax
    POP si
    RET

main:
    ; setup data segments
    MOV ax, 0           ; cant write to ds/es directly
    MOV ds, ax
    MOV es, ax

    ; setup stack
    MOV ss, ax
    MOV sp, 0x7C00      ; stack grows downward from where we are loaded in memory

    ; print message
    MOV si, msg_hello
    CALL puts
    HLT

.halt:
    JMP .halt

msg_hello: DB 'Hello World!', ENDL, 0

TIMES 510-($-$$) DB 0   ; fill rest of sector with 0
DW 0AA55H               ; set the magic bytes for end of boot sector

