BUILD_DIR := ../../build
SOURCES := $(wildcard *.asm)
OBJS := $(SOURCES:%.asm=$(BUILD_DIR)/%.o)



all: $(OBJS)
	@echo $(OBJS)
	@echo "Boot : Building ASM files"
	@echo "Build Folder : " $(BUILD_DIR)
$(BUILD_DIR)/%.o: %.asm | $(BUILD_DIR)
	nasm -felf32 -g $< -o $@ -I../libc/include

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)
install:
