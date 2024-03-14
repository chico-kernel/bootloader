BOOT_DIR := boot
BOOT_ENTRY := $(BOOT_DIR)/boot.asm

BUILD_DIR := build
BIN_DIR := bin

AS := nasm
AS_FLAGS := -f bin

LD := ld
LD_FLAGS := -Ttext 0x7C00 --oformat binary

EMU := qemu-system-x86_64
EMU_FLAGS := -name Chico

.PHONY: all clean

all: $(BIN_DIR)/boot.img

$(BIN_DIR)/boot.img: $(BIN_DIR)/boot.bin
	@printf "  LD\t$@\n"
	@$(LD) $(LD_FLAGS) -o $@ $<

$(BIN_DIR)/boot.bin: $(BOOT_ENTRY)
	@mkdir -p $(BIN_DIR) $(BUILD_DIR)
	@printf "  AS\t$(BOOT_ENTRY)\n"
	@$(AS) $(AS_FLAGS) -o $@ $<

clean:
	@rm -rf $(BIN_DIR) $(BUILD_DIR)

run: $(BIN_DIR)/boot.img
	@$(EMU) $(EMU_FLAGS) -drive format=raw,file=$<
