; Copyright © 2024 Kevin Alavik. All rights reserved.

; Define the GDTR (Global Descriptor Table Register) structure
section .data
    ; GDTR structure to hold the base address and limit of the GDT
    gdt_ptr:
        dw 0       ; GDT limit (2 bytes)
        dd 0       ; GDT base address (4 bytes)

; Text section containing the code
section .text
    ; Declare global symbol for the entry point
    global enable_gdt
    ; Externally define set_gdt function
    extern set_gdt

    ; Entry point function
    enable_gdt:
        ; Call the set_gdt function to set up the GDT
        call set_gdt
        ; Return from the enable_gdt function
        ret

    ; Function to set up the GDT
    set_gdt:
        ; Clear EAX register
        xor   eax, eax
        ; Load DS segment into EAX
        mov   ax, ds
        ; Multiply DS by 16 to get linear address
        shl   eax, 4
        ; Add the offset of 'gdt' label to get linear address of GDT
        add   eax, gdt
        ; Store linear address of GDT in second DWORD of gdt_ptr
        mov   [gdt_ptr + 2], eax

        ; Load the offset of 'gdt_end' label into EAX
        mov   eax, gdt_end
        ; Calculate size of GDT by subtracting offset of 'gdt' label
        sub   eax, gdt
        ; Store size of GDT in first WORD of gdt_ptr
        mov   [gdt_ptr], ax

        ; Load GDTR with address stored in gdt_ptr
        lgdt  [gdt_ptr]
        ; Return from the set_gdt function
        ret

; Data section containing the GDT
section .data
    ; Define the Global Descriptor Table (GDT)
    gdt:
        ; Null Descriptor
        dw 0x0000, 0x0000, 0x0000, 0x0000
        ; Kernel Mode Code Segment
        dw 0xFFFF, 0x0000, 0x0000, 0x9A00
        ; Kernel Mode Data Segment
        dw 0xFFFF, 0x0000, 0x0000, 0x9200
        ; User Mode Code Segment
        dw 0xFFFF, 0x0000, 0x0000, 0xFA00
        ; User Mode Data Segment
        dw 0xFFFF, 0x0000, 0x0000, 0xF200

    ; Define the end of the GDT
    gdt_end:
