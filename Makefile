BIN_DIR := bin
BOOT_DIR := boot

AS := nasm
ASFLAGS := -f bin

QEMU := qemu-system-i386
QEMUFLAGS := -name "Chico Bootloader" -drive format=raw,file=$(BIN_DIR)/boot.img

all: $(BIN_DIR)/boot.img

$(BIN_DIR)/boot.img: $(BOOT_DIR)/boot.asm
	@printf "  AS\t$^\n"
	@$(AS) $(ASFLAGS) -o $@ $<
	@truncate -s 1474560 $@
	@printf '\x55\xaa' | dd of=$@ bs=1 seek=512 conv=notrunc status=none

run: $(BIN_DIR)/boot.img
	@printf "  QEMU\t$<\n"
	@$(QEMU) $(QEMUFLAGS)

clean:
	@rm -f $(BIN_DIR)/*

.PHONY: all run clean
