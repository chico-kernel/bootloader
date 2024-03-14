section .text
    global enable_protected

enable_protected:
    mov eax, cr0
    or eax, 1
    mov cr0, eax