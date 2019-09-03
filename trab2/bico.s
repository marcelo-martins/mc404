.global set_motor_speed
.global set_motors_speed
.global read_sonar
.global read_sonars
.global register_proximity_callback
.global add_alarm
.global get_time
.global set_time

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
set_motor_speed:
    push {r4-r12, lr}

    @1 parametro em r0, struct com 2 bytes: 0=id, 1=speed

    ldrb r4, [r0, #0] @Salva id
    ldrb r5, [r0, #1] @Salva speed

    mov r0, r4
    mov r1, r5

    mov r7, #18
    svc 0x0

    pop {r4-r12, lr}
    mov pc, lr

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
set_motors_speed:
    push {r4-r12, lr}

    @2 structs: m1 2 bytes, 0=id, 1=speed, m2 2 bytes 0=id, 1=speed
    ldrb r4, [r0] @Primeiro id
    ldrb r5, [r1] @Segundo id

    @Teste para saber qual o primeiro id
    cmp r4, #0
    beq motor0
    b motor1

motor0:

    ldrb r0, [r0, #1] @Pega a velocidade do motor0
    ldrb r1, [r1, #1] @Pega a velocidade do motor1

    mov r7, #19
    svc 0x0
    b end_motors

motor1:

    ldrb r0, [r1, #1]@Pega a velocidade do motor0
    ldrb r1, [r0, #1]@Pega a velocidade do motor1

    mov r7, #19
    svc 0x0
    b end_motors

end_motors:
    pop {r4-r12, lr}
    mov pc, lr

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
read_sonar: @recebe em r0 1 byte com o id do sonar
    push {r4-r12, lr}

    mov r7, #16
    svc 0x0

    pop {r4-r12, lr}
    mov pc, lr

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
read_sonars:
    push {r4-r12, lr}

    mov r4, #0 @primeiro sonar a ser verificado

loop_sonar:
    cmp r1, r0 @Ver se o começo chegou no fim
    beq fim_sonares

    @Senao, le o sonar atual

    push {r0-r3}
    mov r7, #16
    svc 0x0
    mov r5, r0 @armazena a distancia que o sonar esta da parede
    pop {r0-r3}

    mov r6, r4, lsl #2 @arrumar o numero de bits para shiftar
    str r5, [r2, r6] @Move a distancia que o sonar esta para o vetor de distancias r2 deslocado da posicao em que o sonar esta

    @Soma dos contadores
    add r4, r4, #1
    add r0, r0, #1

    b loop_sonar

fim_sonares:
    pop {r4-r12, lr}
    mov pc, lr
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
register_proximity_callback:
    push {r4-r12, lr}

    mov r7, #17
    svc 0x0

    pop {r4-r12, lr}
    mov pc, lr

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
add_alarm:
    push {r4-r12, lr}

    mov r7, #22
    svc 0x0

    pop {r4-r12, lr}
    mov pc, lr

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
get_time:
    @t esta em r0
    push {r4-r12, lr}

    mov r12, r0 @Ponteiro para a variavel que recebe o tempo esta em r0

    mov r7, #20
    svc 0x0

    str r0, [r12]

    pop {r4-r12, lr}
    mov pc, lr

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
set_time:
    push {r4-r12, lr}

    mov r7, #21
    svc 0x0

    pop {r4-r12, lr}
    mov pc, lr
