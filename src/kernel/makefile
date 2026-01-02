
BUILD_DIR = ../../build
C_SOURCES := $(wildcard *.c)
OBJS := $(C_SOURCES:%.c=$(BUILD_DIR)/%.o)
CC := i686-elf-gcc
CFLAGS := -g -std=gnu99 -ffreestanding -O2 -Wall -Wextra -I../libc/include

SYSROOT := "build/sysroot"

all: $(OBJS)
	$(CC) -Xlinker -Map $(BUILD_DIR)/bonesOS.map -T linker.ld -o $(BUILD_DIR)/bonesOS.bin -ffreestanding -O2 -nostdlib $(OBJS) $(ASM_OBJS) -lgcc

	mkdir -p $(SYSROOT)



$(BUILD_DIR)/%.o: %.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)/isodir/boot/

clean:
	rm -rf $(BUILD_DIR) *.*


