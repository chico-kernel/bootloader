BIN_DIR := bin
SRC_DIR := boot

AS := nasm
ASFLAGS := -f bin

QEMU := qemu-system-i386
QEMUFLAGS := -name "Chico Bootloader" -drive format=raw,file=$(BIN_DIR)/boot.img

all: $(BIN_DIR)/boot.img

$(BIN_DIR)/boot.img: $(SRC_DIR)/boot.asm
	$(AS) $(ASFLAGS) -o $@ $<

run: $(BIN_DIR)/boot.img
	$(QEMU) $(QEMUFLAGS)

.PHONY: clean
clean:
	rm -rf $(BIN_DIR)/*

