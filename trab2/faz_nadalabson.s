.text
.align 4
.globl _start

_start:                         @ main

        mov r0, #63             @ Carrega em r0 a velocidade do motor 0.
                                @ Lembre-se: apenas os 6 bits menos significativos
                                @ serao utilizados.
        mov r1, #63             @ Carrega em r1 a velocidade do motor 1.
        mov r7, #19            @ Identifica a syscall 124 (write_motors).
        svc 0x0                 @ Faz a chamada da syscall.

        ldr r6, =900          @ r6 <- 1200 (Limiar para parar o robo)

loop:
        mov r0, #3              @ Define em r0 o identificador do sonar a ser consultado.
        mov r7, #16            @ Identifica a syscall 125 (read_sonar).
        svc 0x0
        mov r5, r0              @ Armazena o retorno da syscall.

        mov r0, #4              @ Define em r0 o sonar.
        mov r7, #16
        svc 0x0

        cmp r5, r0              @ Compara o retorno (em r0) com r5.
        bge viraPraEsquerda     @ Se r5(distancia do s03) > r0(distancia do s04): Salta pra min
        mov r0, r5              @ Senao: r0 <- r5
        b viraPraDireita

viraPraEsquerda:

        cmp r0, r6              @ Compara r0 com r6
        bge end                 @ Se r0 menor que o limiar: Salta para end

                                @ Senao define uma velocidade para os 2 motores
        mov r0, #20
        mov r1, #0
        mov r7, #19
        svc 0x0

        b loop                  @ Refaz toda a logica


viraPraDireita:

        cmp r0, r6              @ Compara r0 com r6
        bge end                 @ Se r0 menor que o limiar: Salta para end

                                @ Senao define uma velocidade para os 2 motores
        mov r0, #0
        mov r1, #20
        mov r7, #19
        svc 0x0

        b loop                  @ Refaz toda a logica


end:                            @ Faz o robo ir reto ate bater
        mov r0, #63
        mov r1, #63
        mov r7, #19
	
	svc 0x0

        b loop
