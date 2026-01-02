BUILD_DIR = ../build
#export BUILD_DIR

SUBDIRS = boot libc kernel

.PHONY: $(SUBDIRS)

all: $(SUBDIRS) $(BUILD_DIR) 
	@echo "Master BUILDER"

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)
	@echo "Done"

$(SUBDIRS):
	$(MAKE) -C $@

q:
	qemu-system-i386 -vga none -device VGA,edid=on,xres=1920,yres=1210 -kernel $(BUILD_DIR)/bonesOS.bin -full-screen
qdb:
	qemu-system-i386 -s -S -vga none -device VGA,edid=on,xres=1920,yres=1210 -kernel $(BUILD_DIR)/bonesOS.bin

	


