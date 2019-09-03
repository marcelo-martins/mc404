.org 0x0
.section .iv,"a"

_start:

interrupt_vector:
    b RESET_HANDLER
.org 0x18
    b IRQ_HANDLER


.org 0x100
.data
    CONTADOR: .word 0
.text

RESET_HANDLER:

    @ Zera o contador
    ldr r2, =CONTADOR  @lembre-se de declarar esse contador em uma secao de dados!
    mov r0, #0
    str r0, [r2]

    @Faz o registrador que aponta para a tabela de interrupções apontar para a tabela interrupt_vector
    ldr r0, =interrupt_vector
    mcr p15, 0, r0, c12, c0, 0

    @Configuracao do gpt
    ldr r3, =0x53FA0000  @Move o endereço de gpt_cr para r3
    mov r4, #0x00000041 @Move o valor necessarioque habilita gpt_cr e configura clock_src como periferico
    str r4, [r3] @Move o valor de r4 para o endereço de r3

    ldr r3, =0x53FA0004  @Colocando 0 em gpt_pr
    mov r4, #0
    str r4, [r3]

    ldr r3, =0x53FA0010  @Colocando 100(numero que queremos para gerar interrupcao) em gpt_ocr1
    mov r4, #100
    str r4, [r3]

    ldr r3, =0x53FA000C @Gravar 1 em gpt_IR
    mov r4, #1
    str r4, [r3]





    @ Ajustar a pilha do modo IRQ.





    @ Você deve iniciar a pilha do modo IRQ aqui. Veja abaixo como usar a instrução MSR para chavear de modo.
    @ ...

    @@@...continua tratando o reset

    SET_TZIC:
    @ Constantes para os enderecos do TZIC
    .set TZIC_BASE,             0x0FFFC000
    .set TZIC_INTCTRL,          0x0
    .set TZIC_INTSEC1,          0x84
    .set TZIC_ENSET1,           0x104
    .set TZIC_PRIOMASK,         0xC
    .set TZIC_PRIORITY9,        0x424

    @ Liga o controlador de interrupcoes
    @ R1 <= TZIC_BASE

    ldr	r1, =TZIC_BASE

    @ Configura interrupcao 39 do GPT como nao segura
    mov	r0, #(1 << 7)
    str	r0, [r1, #TZIC_INTSEC1]

    @ Habilita interrupcao 39 (GPT)
    @ reg1 bit 7 (gpt)

    mov	r0, #(1 << 7)
    str	r0, [r1, #TZIC_ENSET1]

    @ Configure interrupt39 priority as 1
    @ reg9, byte 3

    ldr r0, [r1, #TZIC_PRIORITY9]
    bic r0, r0, #0xFF000000
    mov r2, #1
    orr r0, r0, r2, lsl #24
    str r0, [r1, #TZIC_PRIORITY9]

    @ Configure PRIOMASK as 0
    eor r0, r0, r0
    str r0, [r1, #TZIC_PRIOMASK]

    @ Habilita o controlador de interrupcoes
    mov	r0, #1
    str	r0, [r1, #TZIC_INTCTRL]

    @instrucao msr - habilita interrupcoes
    msr  CPSR_c, #0x13       @ SUPERVISOR mode, IRQ/FIQ enabled

    laco:
      b laco

IRQ_HANDLER:
    ldr r3, =0x53FA0008 @Move 1 para gpt_sr
    mov r4, #1
    str r4, [r3]

    ldr r3, =CONTADOR @Somar 1 no contador
    ldr r4, [r3]
    add r4, r4, #1
    str r4, [r3]

    sub r15, r15, #4

    movs pc, lr
