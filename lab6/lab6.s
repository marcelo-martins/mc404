.globl _start

.data

input_buffer:   .skip 32
output_buffer:  .skip 32

.text
.align 4

@ Funcao inicial
_start:
    @ Chama a funcao "read" para ler 4 caracteres da entrada padrao
    ldr r0, =input_buffer
    mov r1, #5             @ 4 caracteres + '\n'
    bl  read
    mov r4, r0             @ copia o retorno para r4.

    @ Chama a funcao "atoi" para converter a string para um numero
    ldr r0, =input_buffer
    mov r1, r4
    bl  atoi

    @ Chama a funcao "encode" para codificar o valor de r0 usando
    @ o codigo de hamming.
    bl  encode
    mov r4, r0             @ copia o retorno para r4.

    @ Chama a funcao "itoa" para converter o valor codificado
    @ para uma sequencia de caracteres '0's e '1's
    ldr r0, =output_buffer
    mov r1, #7
    mov r2, r4
    bl  itoa

    @ Adiciona o caractere '\n' ao final da sequencia (byte 7)
    ldr r0, =output_buffer
    mov r1, #'\n'
    strb r1, [r0, #7]

    @ Chama a funcao write para escrever os 7 caracteres e
    @ o '\n' na saida padrao.
    ldr r0, =output_buffer
    mov r1, #8         @ 7 caracteres + '\n'
    bl  write

    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

    @ Chama a funcao "read" para ler 4 caracteres da entrada padrao
    ldr r0, =input_buffer
    mov r1, #8             @ 8 caracteres + '\n'
    bl  read
    mov r4, r0             @ copia o retorno para r4.

    @ Chama a funcao "atoi" para converter a string para um numero
    ldr r0, =input_buffer
    mov r1, r4
    bl  atoi

    @ Chama a funcao "encode" para codificar o valor de r0 usando
    @ o codigo de hamming.
    bl  decode
    mov r4, r0             @ copia o retorno para r4.
    mov r5, r1           @ copia o r1 para r5.

    @ Chama a funcao "itoa" para converter o valor codificado
    @ para uma sequencia de caracteres '0's e '1's
    ldr r0, =output_buffer
    mov r1, #4
    mov r2, r4
    bl  itoa

    @ Adiciona o caractere '\n' ao final da sequencia (byte 7)
    ldr r0, =output_buffer
    mov r1, #'\n'
    strb r1, [r0, #4]

    @ Chama a funcao write para escrever os 7 caracteres e
    @ o '\n' na saida padrao.
    ldr r0, =output_buffer
    mov r1, #5         @ 7 caracteres + '\n'
    bl  write

    @ Chama a funcao "itoa" para converter o valor codificado
    @ para uma sequencia de caracteres '0's e '1's
    ldr r0, =output_buffer
    mov r1, #1
    mov r2, r5
    bl  itoa

    @ Adiciona o caractere '\n' ao final da sequencia (byte 7)
    ldr r0, =output_buffer
    mov r1, #'\n'
    strb r1, [r0, #1]

    @ Chama a funcao write para escrever os 7 caracteres e
    @ o '\n' na saida padrao.
    ldr r0, =output_buffer
    mov r1, #2         @ 1 caracteres + '\n'
    bl  write

    @ Chama a funcao exit para finalizar processo.
    mov r0, #0
    bl  exit

@ Codifica o valor de entrada usando o codigo de hamming.
@ parametros:
@  r0: valor de entrada (4 bits menos significativos)
@ retorno:
@  r0: valor codificado (7 bits como especificado no enunciado).
encode:
       push {r4-r11, lr}

       @ <<<<<< ADICIONE SEU CODIGO AQUI >>>>>>
	@ r0 eh a saida,  fazer : r4=d4, r5=d3, r6=d2, r7=d1

      @d4 ja esta na ultima posicao
      @fazendo AND com 15 deixo o r0 com 000000000d1d2d3d4

      and r0, r0 , #0b1111

      and r4, r0, #0b1
      mov r0, r0, lsr #0b1
      and r5, r0, #0b1
      mov r0, r0, lsr #0b1
      and r6, r0, #0b1
      mov r0, r0, lsr #0b1
      and r7, r0, #0b1
      @deixa r0 nulo
      mov r0, r0, lsr #0b1

      @fazer: r8=p1, r9=p2, r10=p3
      @faz o xor no d1 e d2 e salva em r8
      eor r8, r7, r6
      @faz o xor de d3 com o resto e salva em r8
      eor r8, r8, r4 @p1

      @para o p2, xor de d1, d3, d4
      eor r9, r7, r5
      eor r9, r9, r4 @p2

      @para o p3, xor de d2, d3, d4
      eor r10, r6, r5
      eor r10, r10, r4 @p3

      @colocar cada um na sua posicao e somar
      @p1 p2 d1 p3 d2 d3 d4

      @mover d3 1 pos esq
      mov r5, r5, lsl #0b1
      @mover d2 2 pos esq
      mov r6, r6, lsl #0b10
      @mover p3 3 pos esq
      mov r10, r10, lsl #0b11
      @mover d1 4 pos esq
      mov r7, r7, lsl #0b100
      @mover p2 5 pos esq
      mov r9, r9, lsl #0b101
      @mover p1 6 pos esq
      mov r8, r8, lsl #0b110

      @somar tudo para ter a codificacao e somar em r11
      add r11, r11, r4
      add r11, r11, r5
      add r11, r11, r6
      add r11, r11, r7
      add r11, r11, r8
      add r11, r11, r9
      add r11, r11, r10

      @salvar em r0

      orr r0, r0, r11
       pop  {r4-r11, lr}
       mov  pc, lr

@ Decodifica o valor de entrada usando o codigo de hamming.
@ parametros:
@  r0: valor de entrada (7 bits menos significativos)
@ retorno:
@  r0: valor decodificado (4 bits como especificado no enunciado).
@  r1: 1 se houve erro e 0 se nao houve.
decode:
       push {r4-r11, lr}

       @ <<<<<< ADICIONE SEU CODIGO AQUI >>>>>>

       @7 bits recebidos em r0
       @separar eles em p1=r4 p2=r5 d1=r6 p3=r7 d2=r8 d3=r9 d4=r10

       and r10, r0, #1
       mov r0, r0, lsr #1
       and r9, r0, #1
       mov r0, r0, lsr #1
       and r8, r0, #1
       mov r0, r0, lsr #1
       and r7, r0, #1
       mov r0, r0, lsr #1
       and r6, r0, #1
       mov r0, r0, lsr #1
       and r5, r0, #1
       mov r0, r0, lsr #1
       and r4, r0, #1
       mov r0, r0, lsr #1 @deixa r0 nulo


      @deixar r11 nulo
      and r11, r11, #0
      @Teste XOR de p1, XOR de d2 com d4, resultado com d1 e resultado com p1 salvando em r11
      eor r11, r8, r10
      eor r11, r11, r6
      eor r11, r11, r4
      @salva r11 em p1 e deixa r11 nulo
      mov r4, r11
      and r11, r11, #0

      @Teste xor de p2
      eor r11, r9, r10
      eor r11, r11, r6
      eor r11, r11, r5
      @Salva r11 em p2 e deixa r11 nulo
      mov r5, r11
      and r11, r11, #0

      @Teste xor de p3
      eor r11, r9, r10
      eor r11, r11, r8
      eor r11, r11, r7
      @Salva r11 em p3  e deixa r11 nulo
      mov r7, r11
      and r11, r11, #0

      @flag de erro no r1
      @inicializa com 0
      and r1, #0
      orr r1, r7
      orr r1, r5
      orr r1, r4

      @Pega d1,d2,d3,d4 e coloca em r0

      @shift de d3 1 bit esq
      mov r9, r9, lsl #1
      @shift de d2 2 bit esq
      mov r8, r8, lsl #2
      @shift de d1 3 bit esq
      mov r6, r6, lsl #3

      @soma d1 d2 d3 e d4 e coloca em r0
      @deixar nulo antes
      and r0, r0, #0
      add r0, r10
      add r0, r9
      add r0, r8
      add r0, r6

       pop  {r4-r11, lr}
       mov  pc, lr

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
    mov r0, r0, lsl #1
    ldrb r2, [r4, r1]
    cmp r2, #'0'       @ identifica bit
    orrne r0, r0, #1
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
