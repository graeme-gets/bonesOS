#include "keyboard_drv.h"
#include "asmHelpers.h"

#define KB_STATUS   0x64

void keyboard_init()
{

}
int keyboard_status_get()
{
    return inportb(KB_STATUS);
}