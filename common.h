#ifndef _COMMON_H_
#define _COMMON_H_

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

uint8_t *memset(uint8_t *dest, size_t size, uint8_t val) ;
//static inline 
void outportb(uint16_t port, uint8_t val);
//static inline 
uint8_t inportb(uint16_t port);

struct regs {
  uint32_t gs, fs, es, ds;
  uint32_t edi, esi, ebp, esp, ebx, edx, ecx, eax;
  uint32_t int_no, err_code;
  uint32_t eip, cs, eflags, useresp, ss;
}__attribute__((packed));

#endif