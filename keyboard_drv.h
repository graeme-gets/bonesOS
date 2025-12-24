#ifndef _KEY_DRV_
#define _KEY_DRV_

#define KB_STATUS_INPUT_BUFFER_STATUS       1<<0
#define KB_STATUS_OUTPUT_BUFFER_STATUS      1<<1 
#define KB_STATUS_SYSTEM_FLAG               1<<2
#define KB_STATUS_CMD_DATA                  1<<3
#define KB_STATUS_ERR_TIMEOUT               1<<6
#define KB_STATUS_ERR_PARITY                1<<7


int keyboard_status_get();

#endif