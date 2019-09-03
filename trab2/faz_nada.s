
.globl _start


.text
        mov r0, #10
        mov r1, #10
        mov r7, #20

        svc 0x0

        lopp:
          b lopp
