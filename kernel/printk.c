#include "kernel.h"
void yesyesyesy() {
      volatile char *vidmem = (char*)0xB8000;
   vidmem[10] = 'a';
   vidmem[11] = 0x07;
};
