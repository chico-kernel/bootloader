BIN_DIR := bin
SRC_DIR := boot
TEST_DIR := test

AS := nasm
ASFLAGS := -f bin

LD := i686-elf-ld
LDFLAGS := -T linker.ld

QEMU := qemu-system-i386
QEMUFLAGS := -serial stdio -name "Chico Bootloader" -drive format=raw,file=$(BIN_DIR)/final.img

all: $(BIN_DIR)/final.img

$(BIN_DIR)/final.img: $(BIN_DIR)/boot.img $(BIN_DIR)/kernel.img
	cat $^ > $@

$(BIN_DIR)/boot.img: $(SRC_DIR)/boot.asm
	$(AS) $(ASFLAGS) -o $@ $<

run: $(BIN_DIR)/final.img
	$(QEMU) $(QEMUFLAGS)

$(BIN_DIR)/kernel.o: $(TEST_DIR)/kernel.c
	@printf "  CC\t$<\n"
	@i686-elf-gcc -std=gnu99 -ffreestanding -O2 -Wall -Wextra -nostdlib -lgcc -c $< -o $@

$(BIN_DIR)/kernel.img: $(BIN_DIR)/kernel.o
	@printf "  LD\t$<\n"
	@$(LD) $(LDFLAGS) -o $@ $<

.PHONY: clean
clean:
	rm -rf $(BIN_DIR)/*
