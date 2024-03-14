OUTPUT_FORMAT("binary")
ENTRY(_start)

SECTIONS {
    . = 0x7C00;

    .text ALIGN(4) :
    {
        *(.text)
    }

    .data ALIGN(4) :
    {
        *(.data)
    }

    .bss ALIGN(4) :
    {
        *(.bss)
    }

    /DISCARD/ :
    {
        *(.eh_frame)
        *(.comment)
    }
}
