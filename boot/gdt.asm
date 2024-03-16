[bits 16]
section .data
    gdt:
        null:
            dd 0x00000000
            dw 0x00000
            db 0x00
            db 0x00
        kernel_code:
            dd 0x00000000
            dw 0xFFFF
            db 0x9A
            db 0xC0
        kernel_data:
            dd 0x0000000
            dw 0xFFFF
            db 0x92
            db 0xC0
        user_code:
            dd 0x0000000
            dw 0xFFFF
            db 0xFA
            db 0xC0
        user_data:
            dd 0x0000000
            dw 0xFFFF
            db 0xF2
            db 0xC0
        task_state:
            dd 0x00000000       ; Replace with pointer to TSS
            dw 0x0000           ; Replace with size of TSS
            db 0x89
            db 0x00
    
gdt_end equ gdt + 7 * 8 ;
section .data
    gdtr:
        dw 39
        dd gdt

section .text
    global enable_gdt

enable_gdt:
    jmp .set_gdt
    call enable_protected
    jmp 0x08:.reload_cs
    ret

[bits 32]
.reload_cs:
   mov   ax, 0x10
   mov   ds, ax
   mov   es, ax
   mov   fs, ax
   mov   gs, ax
   mov   ss, ax
   ret

[bits 16]
.set_gdt:
    xor   eax, eax
    mov   ax, ds
    shl   eax, 4
    add   eax, gdt
    mov   [gdtr + 2], eax
    mov   eax, gdt_end
    sub   eax, gdt
    mov   [gdtr], ax
    cli
    lgdt  [gdtr]
    ret