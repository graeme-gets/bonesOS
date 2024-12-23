#ifndef _VGA_DISPAY_DRV_H
#define _VGA_DISPAY_DRV_H


/*
 * External Prototype Definitions
 */

extern void put_char(char c);
extern void vga_init(uint8_t fg, uint8_t bg);
extern void cursor_set(); //todo: add col/row args
extern void cursor_state_set(uint8_t state, uint8_t start, uint8_t end);
extern void print_string(char*c);
extern uint8_t cursor_pos_get();
/* Hardware text mode color constants. */
enum vga_color {
	VGA_COLOR_BLACK 	= 0,
	VGA_COLOR_BLUE 		= 1,
	VGA_COLOR_GREEN 	= 2,
	VGA_COLOR_CYAN 		= 3,
	VGA_COLOR_RED 		= 4,
	VGA_COLOR_MAGENTA 	= 5,
	VGA_COLOR_BROWN 	= 6,
	VGA_COLOR_LIGHT_GREY 	= 7,
	VGA_COLOR_DARK_GREY 	= 8,
	VGA_COLOR_LIGHT_BLUE 	= 9,
	VGA_COLOR_LIGHT_GREEN 	= 10,
	VGA_COLOR_LIGHT_CYAN 	= 11,
	VGA_COLOR_LIGHT_RED 	= 12,
	VGA_COLOR_LIGHT_MAGENTA = 13,
	VGA_COLOR_LIGHT_BROWN 	= 14,
	VGA_COLOR_WHITE 	= 15,
};


#endif
