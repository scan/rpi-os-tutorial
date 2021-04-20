.section ".text.boot"

.global _start

_start:
  ; Send cores #0 through #2 to sleep
  mrc p15, #0, r1, c0, c0, #5 ; Get core number
  and r1, r1, #3
  cmp r1, #0
  bne halt ; Jump to halt unless it's core #3

  ; Set stack pointer to 0x8000
  mov sp, #0x8000

  ; Zero out the BSS section
  ldr r4, =__bss_start
  mov r5, #0
  mov r6, #0
  mov r7, #0
  mov r8, #0
  ldr r9, =__bss_end
  b 2f

1:
  stmia r4!, {r5-r8} ; Set the address in r4 to the values of r5 to r8, 16 bytes at a time

2:
  cmp r4, r9
  blo 1b ; Repeat until we've reached end of BSS section

  ; Load main function and jump to it
  ldr r3, =kernel_main
  blx r3

halt:
  wfe ; Wait for event
  b halt ; Jump back to halt
