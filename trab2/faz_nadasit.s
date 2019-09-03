.globl _start

.text
sonar_teste_loop:
  mov r10, #0

reading_sonars:
  mov r0, r10
  mov r7, #16
  svc 0x0
  push {r0}

  add r10, r10, #1
  cmp r10, #16
  bne reading_sonars

  mov r10, #0
  mov r0, #0

  pop {r0-r7} @ Pega os 8 radares traseiros (8-15)

  mov r0, r0

  pop {r0-r7} @ Pega os 8 radares dianteiros (0-7)

  b sonar_teste_loop
