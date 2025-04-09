org 0x7C00

[BITS 16]

Execute_Real_Mode:

   mov ax, 0x2401
   int 0x15 ; ENABLE A20 BIT
   
   mov ax, 0x3
   int 0x10 ; ENABLE VGA TEXT MODE

   cli

   lgdt [GDT_Descriptor]
   mov bx, 0x0000
   mov es, bx
   xor bx, bx

   mov ah, 0x02
   mov al, 0x15
   mov ch, 0x00
   mov cl, 0x02
   mov dh, 0x00
   mov dl, 0x80
   int 0x13

   
   mov eax, cr0
   or eax, 0x1 ; PROTECTED MODE BIT
   mov cr0, eax
   jmp CODE_SEGMENT:Execute_Protected_Mode

GDT_Start:
   null_descriptor:
      dq 0
   GDT_Code:
      dw 0xFFFF    ; SEGMENT LIMIT [0-15 BITS [64KB]]
      dw 0x0000    ; LITTLE ADDRESS [0-15 BITS]
      db 0x00      ; MIDDLE ADDRESS [16-23 BITS]
      db 10011010b ; FLAGS: 32 bit, Provoleged, Present
      db 11001111b ; GRANUALITY, LIMIT [16-19 BITS], G=1 [4KB PAGES]
      db 0x00      ; BIG ADDRESS [24-31 BITS]
   GDT_Data:
      dw 0xFFFF    ; SEGMENT LIMIT [0-15 BITS [64KB]]
      dw 0x0000    ; LITTLE ADDRESS [0-15 BITS]
      db 0x00      ; MIDDLE ADDRESS [16-23 BITS]
      db 10010010b ; FLAGS: 32 bit, Provoleged, Present
      db 11001111b ; GRANUALITY, LIMIT [16-19 BITS], G=1 [4KB PAGES]
      db 0x00      ; BIG ADDRESS [24-31 BITS]
GDT_End:
GDT_Descriptor:
   dw GDT_End - GDT_Start - 1
   dd GDT_Start

CODE_SEGMENT equ GDT_Code - GDT_Start
DATA_SEGMENT equ GDT_Data - GDT_Start
[BITS 32]



Execute_Protected_Mode:

   mov ax, DATA_SEGMENT
   mov ds, ax
   mov es, ax
   mov fs, ax
   mov gs, ax
   mov ss, ax

   mov ebp, 0x90000
   mov esp, ebp
   cli
   jmp CODE_SEGMENT:0x0000

times 510 - ($ - $$) db 0
dw 0xAA55
