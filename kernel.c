#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
//#include <stdlib.h>
#include "common.h"
#include "idt.h"
#include "isr.h"
#include "idt.h"
#include "vgadisplay_drv.h"
#include "keyboard_drv.h"
#include "convert.h"
/* Check if the compiler thinks you are targeting the wrong operating system. */
#if defined(__linux__)
#error "You are not using a cross-compiler, you will most certainly run into trouble"
#endif

/* This tutorial will only work for the 32-bit ix86 targets. */
#if !defined(__i386__)
#error "This tutorial needs to be compiled with a ix86-elf compiler"
#endif

#define IRQ(x) x+32

#define KBC_STATUS   0x64
#define KBC_EA       0x60

void cb_keyboardInterrupt(struct regs *r)
{
	int scancode;
	char hexBuffer[10];
	// get the keyboard char 
	if (inportb(KBC_STATUS) & 1)
	{

		scancode = inportb(KBC_EA);

		charToHex(scancode,hexBuffer);
		print_string(hexBuffer);
		print_string("\n\r");
	}
	

}

void kernel_main(void) 
{
	idt_install();
	isrs_install();


	vga_init(VGA_COLOR_BROWN, VGA_COLOR_BLACK);
	register_interrupt_handler(IRQ(1), &cb_keyboardInterrupt);

	print_string("\r\nBONES OS version 0.1.0\r\n");

	int kbStatus = keyboard_status_get();
	print_string("Keyboard Status: ");
	//print_string(itoa(kbStatus));


	
	while (1)
	{
		for(int64_t i =0; i< 0xffffff;i++){}
	};

}
