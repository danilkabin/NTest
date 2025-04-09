[BITS 32]

global _start
extern motor_main
_start:
   mov edi, 0xB8000
   mov al, 'X'            
   mov ah, 0x07            
   mov word [edi], ax       
   call motor_main  
jmp $
