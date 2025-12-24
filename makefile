
BUILD_DIR = build
C_SOURCES := $(wildcard *.c)
ASM_SOURCES := $(wildcard *.asm)
OBJS := $(C_SOURCES:%.c=$(BUILD_DIR)/%.o)
ASM_OBJS := $(ASM_SOURCES:%.asm=$(BUILD_DIR)/%.o)
CC := i686-elf-gcc
CFLAGS := -g -std=gnu99 -ffreestanding -O2 -Wall -Wextra

all: $(OBJS) $(ASM_OBJS)
	echo Build full system
	$(CC) -Xlinker -Map $(BUILD_DIR)/bonesOS.map -T linker.ld -o $(BUILD_DIR)/bonesOS.bin -ffreestanding -O2 -nostdlib $(OBJS) $(ASM_OBJS) -lgcc


	# Create Disk Image for CD ROM
	mkdir -p $(BUILD_DIR)/isodir/boot/grub
	rm -f $(BUILD_DIR)/isodir/boot/bonesOS.bin
	rm -f $(BUILD_DIR)/isodir/boot/grub.cfg
	cp $(BUILD_DIR)/bonesOS.bin $(BUILD_DIR)/isodir/boot/bonesOS.bin
	cp grub.cfg $(BUILD_DIR)/isodir/boot/grub/grub.cfg
	grub-mkrescue -o $(BUILD_DIR)/bonesOS.iso $(BUILD_DIR)/isodir

	grub-file --is-x86-multiboot $(BUILD_DIR)/bonesOS.bin

	echo Complete

$(BUILD_DIR)/%.o: %.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/%.o: %.asm | $(BUILD_DIR)
	nasm -felf32 -g $< -o $@

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

clean:
	rm -rf $(BUILD_DIR) *.o bonesOS.bin bonesOS.iso

q:
	qemu-system-i386 -vga none -device VGA,edid=on,xres=1920,yres=1210 -kernel $(BUILD_DIR)/bonesOS.bin -full-screen
qdb:
	qemu-system-i386 -s -S -vga none -device VGA,edid=on,xres=1920,yres=1210 -kernel $(BUILD_DIR)/bonesOS.bin

	
