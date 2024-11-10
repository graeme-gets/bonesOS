all:
	echo Build full system
	nasm -felf32 boot.asm -o boot.o
	i686-elf-gcc -c kernel.c -o kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra
	i686-elf-gcc -T linker.ld -o bonesOS.bin -ffreestanding -O2 -nostdlib boot.o kernel.o -lgcc

	# Create Disk Image for CD ROM
	rm -f isodir/boot/bonesOS.bin
	rm -f isofor/boot/grub.cfg
	cp bonesOS.bin isodir/boot/bonesOS.bin
	cp grub.cfg isodir/boot/grub/grub.cfg
	grub-mkrescue -o bonesOS.iso isodir

	grub-file --is-x86-multiboot bonesOS.bin

	echo Complete



