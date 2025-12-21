#include "common.h"

uint8_t *memset(uint8_t *dest, size_t size, uint8_t val) {
  for (size_t i = 0; i < size; i++) {
    dest[i] = val;
  }
  return dest;
}

 void outportb(uint16_t port, uint8_t val) {
  asm volatile ("outb %0, %1" : : "a"(val), "Nd"(port));
}

 inline uint8_t inportb(uint16_t port) {
    uint8_t ret;
    asm volatile ("inb %1, %0" : "=a"(ret) : "Nd"(port));
    return ret;
}