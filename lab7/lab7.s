.globl _start

.data

input_buffer:   .skip 32
output_buffer:  .skip 32
linha_1:        .skip 3068
linha_2:        .skip 3068

.text
.align 4

@ Funcao inicial
_start:

    @ Chama a funcao "read" para ler 3 caracteres da entrada padrao
    ldr r0, =input_buffer
    mov r1, #4             @ 3 caracteres + '\n'
    bl  read
    mov r4, r0             @ copia o retorno para r4.

    @ Chama a funcao "atoi" para converter a string para um numero
    ldr r0, =input_buffer
    mov r1, r4
    bl  atoi
    mov r4, r0             @ copia o retorno para r4

    @r4 numero de linhas
    mov r5, #0 @ contador linhas
    mov r6, #0 @ contador de numeros
    mov r7, #linha_1 @r7 linha anterior
    mov r8, #linha_2 @r8 linha atual

    @loop aqui
triang_loop:
    mov r6, #0
    cmp r5, r4
    bge fim
            linha_loop:
                cmp r6, #0
                bl eh_um
                cmp r6, r5
                bl eh_um
                @ eh 2 ou mais o indice

                sub r6, r6, #1
                @mul r11, r6, #4
		mov r6, r6, lsl #4
		mov r11, r6

                ldr r9, [r7, r11]
                add r6, r6, #1
                @mul r11, r6, #4
		mov r6, r6, lsl #4
		mov r11, r6
                ldr r10, [r7, r11]
                add r10, r10, r9
                str r10, [r8, r11]
                b nao_eh_um

            eh_um:
                @mul r11, r6, #4 @ tamanho a ser pulado
		mov r6, r6, lsl #4
		mov r11, r6
                mov r10, #1
                str r10, [r8, r11]   @ escreve na memoria
            nao_eh_um:
                add r6, r6, #1
                cmp r6, r5
                ble linha_loop
            end_linha:
    @printa linha







    add r5, r5, #1
    mov r10, r7 @ inverte linha anterior e atual
    mov r7, r8
    mov r8, r10
    b triang_loop
fim:



    @ Adiciona o caractere '\n' ao final da sequencia (byte 12)
    ldr r0, =output_buffer
    mov r1, #'\n'
    strb r1, [r0, #12]

    @ Chama a funcao write para escrever os 12 caracteres e
    @ o '\n' na saida padrao.
    ldr r0, =output_buffer
    mov r1, #13         @ 12 caracteres + '\n'
    bl  write

    @ Chama a funcao exit para finalizar processo.
    mov r0, #0
    bl  exit

@ Le uma sequencia de bytes da entrada padrao.
@ parametros:
@  r0: endereco do buffer de memoria que recebera a sequencia de bytes.
@  r1: numero maximo de bytes que pode ser lido (tamanho do buffer).
@ retorno:
@  r0: numero de bytes lidos.
read:
    push {r4,r5, lr}
    mov r4, r0
    mov r5, r1
    mov r0, #0         @ stdin file descriptor = 0
    mov r1, r4         @ endereco do buffer
    mov r2, r5         @ tamanho maximo.
    mov r7, #3         @ read
    svc 0x0
    pop {r4, r5, lr}
    mov pc, lr

@ Escreve uma sequencia de bytes na saida padrao.
@ parametros:
@  r0: endereco do buffer de memoria que contem a sequencia de bytes.
@  r1: numero de bytes a serem escritos
write:
    push {r4,r5, lr}
    mov r4, r0
    mov r5, r1
    mov r0, #1         @ stdout file descriptor = 1
    mov r1, r4         @ endereco do buffer
    mov r2, r5         @ tamanho do buffer.
    mov r7, #4         @ write
    svc 0x0
    pop {r4, r5, lr}
    mov pc, lr

@ Finaliza a execucao de um processo.
@  r0: codigo de finalizacao (Zero para finalizacao correta)
exit:
    mov r7, #1         @ syscall number for exit
    svc 0x0

@ Converte uma sequencia de caracteres '0' e '1' em um numero binario
@ parametros:
@  r0: endereco do buffer de memoria que armazena a sequencia de caracteres.
@  r1: numero de caracteres a ser considerado na conversao
@ retorno:
@  r0: numero binario
atoi:
    push {r4, r5, lr}
    mov r4, r0         @ r4 == endereco do buffer de caracteres
    mov r5, r1         @ r5 == numero de caracteres a ser considerado
    mov r0, #0         @ number = 0
    mov r1, #0         @ loop indice
atoi_loop:
    cmp r1, r5         @ se indice == tamanho maximo
    beq atoi_end       @ finaliza conversao
    mov r0, r0, lsl #4
    ldrb r2, [r4, r1]

    cmp r2, #65   @ valor de A
    blt isNumeric
    sub r2, r2, #65
    add r2, r2, #10
    b charHexToi_end
isNumeric:
    sub r2, r2, #48
charHexToi_end:
    add r0, r0, r2

    add r1, r1, #1     @ indice++
    b atoi_loop
atoi_end:
    pop {r4, r5, lr}
    mov pc, lr

@ Converte um numero binario em uma sequencia de caracteres '0' e '1'
@ parametros:
@  r0: endereco do buffer de memoria que recebera a sequencia de caracteres.
@  r1: numero de caracteres a ser considerado na conversao
@  r2: numero binario
itoa:
    push {r4, r5, lr}
    mov r4, r0
itoa_loop:
    sub r1, r1, #1         @ decremento do indice
    cmp r1, #0          @ verifica se ainda ha bits a serem lidos
    blt itoa_end
    and r3, r2, #1
    cmp r3, #0
    moveq r3, #'0'      @ identifica o bit
    movne r3, #'1'
    mov r2, r2, lsr #1  @ prepara o proximo bit
    strb r3, [r4, r1]   @ escreve caractere na memoria
    b itoa_loop
itoa_end:
    pop {r4, r5, lr}
    mov pc, lr
