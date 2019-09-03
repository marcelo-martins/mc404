.org 0x0
.section .iv,"a"

_start:
                                    @PSR le entrada DR escreve na saida------------------------------
interrupt_vector:
    b RESET_HANDLER
.org 0x04
    b UNDEFINED_HANDLER
.org 0x08
    b SVC_HANDLER
.org 0x0c
    b UNDEFINED_HANDLER
.org 0x10
    b UNDEFINED_HANDLER
.org 0x14
    b UNDEFINED_HANDLER
.org 0x18
    b IRQ_HANDLER
.org 0x1c
    b UNDEFINED_HANDLER


.org 0x100

.set TIME_SZ, 200
.set MAX_CALLBACKS, 8
.set MAX_ALARMS, 8


.data
    CONTADOR: .word 0
    .skip 159
    IRQ_STACK:
    .skip 159
    SVC_STACK:
    .skip 159
    USR_STACK:
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

    @Configuracao GDIR
    ldr r3, =0x53F84004
    ldr r4, =0b11111111111111000000000000111110
    str r4, [r3]








    @ Ajustar a pilha do modo IRQ.
    msr CPSR_c, #0b00010010                 @Se der merda, sp=r13_irq
    ldr sp, =IRQ_STACK
    msr CPSR_c, #0b00010011
    @Ajustar a pilha no modo USR
    msr CPSR_c, #0b00010000
    ldr sp, =USR_STACK
    msr CPSR_c, #0b00010011
    @Ajustar a pilha no modo SUPERVISOR
    msr CPSR_c, #0b00010011
    ldr sp, =SVC_STACK                   @Se der merda, sp = r13_svc






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

    msr  CPSR_c, #0x10

    ldr r2, =0x77801200
    bx r2



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

SVC_HANDLER:
    push {r4-r12}
    @Pegar valor de r7 para decidir qual syscall ir
    cmp r7, #16
    beq read_sonar
    cmp r7, #17
    beq register_proximity_callback
    cmp r7, #18
    beq set_motor_speed
    cmp r7, #19
    beq set_motors_speed
    cmp r7, #20
    beq get_time
    cmp r7, #21
    beq set_time
    cmp r7, #22
    beq set_alarm
    b end       @ver se precisa ir para o final mesmo/ dedo no cu e gritaria


@READ SONAR
read_sonar:
    cmp r0, #0
    blt invalido_read
    cmp r0, #15
    bgt invalido_read
    b nao_invalido

invalido_read:
    mov r0, #-1
    b end

nao_invalido: @Radar esta ok
    mov r0, r0, lsl #2 @coloca 0 na flag e o trigger

    @Colocar o numero do sonar em Sonar_mux
    ldr r4, =0b11111111111111111111111111000000
    orr r4, r0, r4 @Salva o ID do sonar desejado e deixa 0 no trigger e na flag
    ldr r3, =0x53F84008 @Leitura do psr
    ldr r5, [r3]
    and r4, r4, r5
    ldr r3, =0x53F84000 @Escrita no DR
    str r4, [r3]

    @ trigger = 0
    @Esperar 15ms
    mov r6, #0
while1:
    add r6, r6, #1
    ldr r8, =1000000
    cmp r6, r8
    blt while1
    @Colocar trigger em 1
    ldr r3, =0x53F84008 @Leitura do PSR
    ldr r4, [r3]
    orr r4, r4, #2
    ldr r3, =0x53F84000 @Escrita no DR
    str r4, [r3]

    @espera 15ms
    mov r6, #0
while2:
    add r6, r6, #1
    ldr r8, =1000000
    cmp r6, r8
    blt while2
    @Colocar 0 no trigger
    ldr r3, =0x53F84008 @Leitura do PSR
    ldr r4, [r3]
    ldr r5, =0b11111111111111111111111111111101
    and r4, r4, r5
    ldr r3, =0x53F84000 @Escrita no DR
    str r4, [r3]


    @Checar se flag eh 1
loop_flag:
    ldr r5, =0b00000000000000000000000000000001
    ldr r3, =0x53F84008 @Leitura do PSR
    ldr r4, [r3]
    and r4, r4, r5
    cmp r4, #1
    beq grab_distancia
    @Entao, flag eh 0

    @Delay 10ms
    mov r6, #0
while3:
    add r6, r6, #1
    ldr r8, =1000000
    cmp r6, r8
    blt while3

    b loop_flag

grab_distancia:@Colocar o sonar_data na distancia(que sera retornada em r0)
    ldr r5, =0b00000000000000111111111111000000
    ldr r3, =0x53F84008 @Leitura do PSR
    ldr r4, [r3]
    and r4, r4, r5
    mov r0, r4
    mov r0, r0, lsr #6

    b end

@ MOTOR SPEED
set_motor_speed:
    @Teste para r0(n do motor) válido
    cmp r0, #0
    movlt r0, #-1
    blt end
    cmp r0, #1
    movgt r0, #-1
    bgt end

    @Teste para r1(velocidade) válido
    cmp r1, #0
    movlt r0, #-2
    blt end
    cmp r1, #127
    movgt r0, #-2
    bgt end

    @Caso esteja tudo ok...
    cmp r0, #0
    beq set_motor0

set_motor1:
    ldr r6, =0b000000011111111111111111111111111
    mov r1, r1, lsl #26 @arruma a velocidade na posicao

    @ le do DR, DO DR
    ldr r3, =0x53F84000
    ldr r4, [r3] @ pega valor do dr
    and r4, r4, r6 @ Aqui temos DR[velocidade tudo zero/0/resto inalterado]
    orr r4, r4, r1
    str r4, [r3] @ setta a velocidade do dr
    b end

set_motor0:
    ldr r6, =0b11111110000000111111111111111111
    mov r1, r1, lsl #19

    @ LE DO DR
    ldr r3, =0x53F84000
    ldr r4, [r3]
    and r4, r4, r6 @ Aqui temos DR[resto/velocidade zerada/0/resto]
    orr r4, r4, r1
    str r4, [r3]

    b end








@ MOTORSSS SPEED
set_motors_speed:
    @ Teste para r0(velocidade do motor 0) válido
    cmp r0, #0
    movlt r0, #-1
    blt end
    cmp r0, #127
    movgt r0, #-1
    bgt end

    @ Teste para r1(velocidade do motor 1) válido
    cmp r1, #0
    movlt r0, #-2
    blt end
    cmp r1, #127
    movgt r0, #-2
    bgt end

    @ mascara
    ldr r6, =0b00000000000000111111111111111111
    mov r0, r0, lsl #19 @ move a velocidade do motor 0 para a posicado do dr
    mov r1, r1, lsl #26 @ move a velocidade do motor 1 para a posicado do dr

    @ LE DR
    ldr r3, =0x53F84000
    ldr r4, [r3]
    and r4, r4, r6 @ DR[velocidade1 zerada/0/ṽelocidade2 zerada/0/resto]
    orr r4, r4, r0 @ coloca a velocidade do motor 0
    orr r4, r4, r1 @ coloca a velocidade do motor 1
    str r4, [r3]

    b end







@ GET TIME
get_time:
    ldr r4, =CONTADOR
    ldr r5, [r4] @ pega o tempo
    mov r0, r5 @ retorna o tempo

    b end


@ SET TIME
set_time:
    ldr r4, =CONTADOR
    str r0, [r4]

    b end


set_alarm:

register_proximity_callback:

    cmp r0, #0
    movlt r0, #-2
    blt end
    cmp r0, #15
    movgt r0, #-2
    bgt end

end:
    pop {r4-r12}
    movs pc, lr

UNDEFINED_HANDLER:
  undefinedLaco:
    b undefinedLaco
