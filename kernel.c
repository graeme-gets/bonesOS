#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include "vgadisplay_drv.h"
/* Check if the compiler thinks you are targeting the wrong operating system. */
#if defined(__linux__)
#error "You are not using a cross-compiler, you will most certainly run into trouble"
#endif

/* This tutorial will only work for the 32-bit ix86 targets. */
#if !defined(__i386__)
#error "This tutorial needs to be compiled with a ix86-elf compiler"
#endif

void kernel_main(void) 
{
	vga_init(VGA_COLOR_BROWN, VGA_COLOR_BLACK);
	print_string("BONES OS version 0.1.0\n\r");
	print_string("Hello World!");
	set_cursor_state(1);
	set_cursor();
}
