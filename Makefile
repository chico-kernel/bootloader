BIN_DIR := bin
BOOT_DIR := boot

AS := nasm
ASFLAGS := -f elf64

LD := ld
LDFLAGS := -T linker.ld

QEMU := qemu-system-x86_64
QEMUFLAGS := -name Chico -drive format=raw,file=$(BIN_DIR)/boot.img

all: $(BIN_DIR)/boot.img

$(BIN_DIR)/boot.img: $(patsubst $(BOOT_DIR)/%.asm, $(BIN_DIR)/%.bin, $(wildcard $(BOOT_DIR)/*.asm))
	@printf "  LD\t$@\n"
	@$(LD) $(LDFLAGS) -o $@ $^
	@truncate -s 1474560 $@
	@printf '\x55\xaa' | dd of=$@ bs=1 seek=510 conv=notrunc status=none

$(BIN_DIR)/%.bin: $(BOOT_DIR)/%.asm
	@printf "  AS\t$<\n"
	@$(AS) $(ASFLAGS) -o $@ $<

run: $(BIN_DIR)/boot.img
	@printf "  QEMU\t$<\n"
	@$(QEMU) $(QEMUFLAGS)

clean:
	@rm -f $(BIN_DIR)/*

.PHONY: all run clean
