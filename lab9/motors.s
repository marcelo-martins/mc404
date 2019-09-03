@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@
@ Codigo de exemplo para controle basico de um robo.
@ Este codigo le os valores de 2 sonares frontais para decidir se o
@ robo deve parar ou seguir em frente.
@ 2 syscalls serao utilizadas para controlar o robo:
@   write_motors  (syscall de numero 124)
@                 Parametros:
@                       r0 : velocidade para o motor 0  (valor de 6 bits)
@                       r1 : velocidade para o motor 1  (valor de 6 bits)
@
@  read_sonar (syscall de numero 125)
@                 Parametros:
@                       r0 : identificador do sonar   (valor de 4 bits)
@                 Retorno:
@                       r0 : distancia capturada pelo sonar consultado (valor de 12 bits)
@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


.text
.align 4
.globl _start

_start:                         @ main

        mov r0, #0              @ Carrega em r0 a velocidade do motor 0.
                                @ Lembre-se: apenas os 6 bits menos significativos
                                @ serao utilizados.
        mov r1, #0              @ Carrega em r1 a velocidade do motor 1.
        mov r7, #124            @ Identifica a syscall 124 (write_motors).
        svc 0x0                 @ Faz a chamada da syscall.

        ldr r6, =1200           @ r6 <- 1200 (Limiar para parar o robo)

loop:
        mov r0, #3              @ Define em r0 o identificador do sonar a ser consultado.
        mov r7, #125            @ Identifica a syscall 125 (read_sonar).
        svc 0x0
        mov r5, r0              @ Armazena o retorno da syscall.

        mov r0, #4              @ Define em r0 o sonar.
        mov r7, #125
        svc 0x0

        cmp r5, r0              @ Compara o retorno (em r0) com r5.
        bge min                 @ Se r5 > r0: Salta pra min
        mov r0, r5              @ Senao: r0 <- r5
        b min2
min:
       @vira para esq

       @checa o sensor da esq de novo para ele continuar virando
        mov r0, #4
        mov r7, #125
        svc 0x0

        cmp r0, r6              @ Compara r0 com r6
        bge end1                @ Se r0 menor que o limiar: Salta para end

                                @ Senao define uma velocidade para os 2 motores
        mov r0, #15
        mov r1, #0
        mov r7, #124
        svc 0x0

        b min                  @ Refaz toda a logica

min2:  @vira para direita

        mov r0, #3
        mov r7, #125
        svc 0x0

        cmp r0, r6              @ Compara r0 com r6
        bge end1                @ Se r0 menor que o limiar: Salta para end

                                @ Senao define uma velocidade para os 2 motores
        mov r0, #0
        mov r1, #15
        mov r7, #124
        svc 0x0

        b min2                 @ Refaz toda a logica


end1:                            @ girar o robo
        mov r0, #25
        mov r1, #25
        mov r7, #124
        svc 0x0

        b loop

@end2:
@        mov r0, #0
@        mov r1, #60
@        mov r7, #124
@        svc 0x0
@
@        b loop                  @ Refaz toda a logica
