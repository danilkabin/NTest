CC = nasm
GCC = clang
BUILD_DIR = build
BOOT_DIR = boot
KERNEL_DIR = kernel
MM_DIR = mm
SRC_DIR = src
INCLUDE_DIR = include
DRIVERS_DIR = drivers
NET_DIR = net

# Исходные файлы
BOOTLOADER_SRC = $(BOOT_DIR)/bootloader.asm

# Файлы ядра (C и ASM)
KERNEL_C_SRC = $(KERNEL_DIR)/kernel.c \
               $(KERNEL_DIR)/cpu/sir/gdt.c \
               $(KERNEL_DIR)/cpu/sir/idt.c \
               $(KERNEL_DIR)/cpu/sir/isr.c \
               $(KERNEL_DIR)/exit.c \
               $(KERNEL_DIR)/printk.c \
               $(KERNEL_DIR)/sys.c \
               $(KERNEL_DIR)/traps.c

KERNEL_ASM_SRC = $(KERNEL_DIR)/main.asm \
                 $(KERNEL_DIR)/keyboard.asm \
                 $(KERNEL_DIR)/cpu/asm/gdt.asm \
                 $(KERNEL_DIR)/cpu/asm/idt.asm

# Файлы управления памятью
MM_C_SRC = $(MM_DIR)/memory.c
MM_ASM_SRC = $(MM_DIR)/page.asm

# Файлы HAL и других компонентов
SRC_C_SRC = $(SRC_DIR)/hal/printf.c

# Нет драйверов и сетевых файлов в текущей структуре, но оставим для совместимости
DRIVERS_SRC = $(shell find $(DRIVERS_DIR) -type f -name '*.c' 2>/dev/null || true)
NET_SRC = $(shell find $(NET_DIR) -type f -name '*.c' 2>/dev/null || true)

# Объектные файлы
KERNEL_C_OBJ = $(patsubst $(KERNEL_DIR)/%.c, $(BUILD_DIR)/kernel/%.o, $(KERNEL_C_SRC))
KERNEL_ASM_OBJ = $(patsubst $(KERNEL_DIR)/%.asm, $(BUILD_DIR)/kernel/%.o, $(KERNEL_ASM_SRC))
KERNEL_OBJ = $(KERNEL_C_OBJ) $(KERNEL_ASM_OBJ)

MM_C_OBJ = $(patsubst $(MM_DIR)/%.c, $(BUILD_DIR)/mm/%.o, $(MM_C_SRC))
MM_ASM_OBJ = $(patsubst $(MM_DIR)/%.asm, $(BUILD_DIR)/mm/%.o, $(MM_ASM_SRC))
MM_OBJ = $(MM_C_OBJ) $(MM_ASM_OBJ)

SRC_C_OBJ = $(patsubst $(SRC_DIR)/hal/%.c, $(BUILD_DIR)/src/hal/%.o, $(SRC_SRC))

DRIVERS_OBJ = $(patsubst $(DRIVERS_DIR)/%.c, $(BUILD_DIR)/drivers/%.o, $(DRIVERS_SRC))
NET_OBJ = $(patsubst $(NET_DIR)/%.c, $(BUILD_DIR)/net/%.o, $(NET_SRC))

# Бинарные файлы
BOOTLOADER_BIN = $(BUILD_DIR)/bootloader.bin
KERNEL_BIN = $(BUILD_DIR)/kernel.bin
FINAL_BIN = $(BUILD_DIR)/basickernel.bin

NASMFLAGS = -f elf32 -I$(INCLUDE_DIR)
CFLAGS = -Wall -O2 -ffreestanding -m32 -nostdinc -I$(INCLUDE_DIR) -I. -fno-pic -fno-pie -no-pie
CPP = $(GCC) -E -nostdinc -I$(INCLUDE_DIR) -I.

all: directories $(FINAL_BIN)

directories:
	mkdir -p $(BUILD_DIR)/kernel/cpu/asm $(BUILD_DIR)/kernel/cpu/sir $(BUILD_DIR)/mm $(BUILD_DIR)/src/hal $(BUILD_DIR)/drivers $(BUILD_DIR)/net

$(FINAL_BIN): $(BOOTLOADER_BIN) $(KERNEL_BIN)
	cat $(BOOTLOADER_BIN) $(KERNEL_BIN) > $(FINAL_BIN)

$(BOOTLOADER_BIN): $(BOOTLOADER_SRC)
	$(CC) $(NASMFLAGS) -f bin -o $@ $<

# Правила для объектных файлов ядра (C)
$(KERNEL_C_OBJ): $(BUILD_DIR)/kernel/%.o: $(KERNEL_DIR)/%.c
	@mkdir -p $(dir $@)
	$(GCC) $(CFLAGS) -c $< -o $@

# Правила для объектных файлов ядра (ASM)
$(KERNEL_ASM_OBJ): $(BUILD_DIR)/kernel/%.o: $(KERNEL_DIR)/%.asm
	@mkdir -p $(dir $@)
	$(CC) $(NASMFLAGS) -o $@ $<

# Правила для файлов управления памятью (C)
$(MM_C_OBJ): $(BUILD_DIR)/mm/%.o: $(MM_DIR)/%.c
	@mkdir -p $(dir $@)
	$(GCC) $(CFLAGS) -c $< -o $@

# Правила для файлов управления памятью (ASM)
$(MM_ASM_OBJ): $(BUILD_DIR)/mm/%.o: $(MM_DIR)/%.asm
	@mkdir -p $(dir $@)
	$(CC) $(NASMFLAGS) -o $@ $<

# Правила для HAL (C)
$(SRC_C_OBJ): $(BUILD_DIR)/src/hal/%.o: $(SRC_DIR)/hal/%.c
	@mkdir -p $(dir $@)
	$(GCC) $(CFLAGS) -c $< -o $@

# Правила для драйверов и сети (если есть)
$(DRIVERS_OBJ): $(BUILD_DIR)/drivers/%.o: $(DRIVERS_DIR)/%.c
	@mkdir -p $(dir $@)
	$(GCC) $(CFLAGS) -c $< -o $@

$(NET_OBJ): $(BUILD_DIR)/net/%.o: $(NET_DIR)/%.c
	@mkdir -p $(dir $@)
	$(GCC) $(CFLAGS) -c $< -o $@

# Линковка ядра
$(KERNEL_BIN): $(KERNEL_OBJ) $(MM_OBJ) $(SRC_C_OBJ) $(DRIVERS_OBJ) $(NET_OBJ)
	@mkdir -p $(dir $@)
	ld -m elf_i386 -Ttext 0x1000 --oformat binary -o $@ $^

clean:
	rm -rf $(BUILD_DIR)

.PHONY: all clean directories
