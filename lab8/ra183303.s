.global ajudaORobinson         @Torna a funcao global
.data
output: .skip 40            @vetor da saida
string: .asciz "Não existe um caminho!\n"     @print de erro
.text
.align 4

@ajudaORobinson Vai receber parametros:
@ r0:xRob, r1: yRob, r2: xLoc, r3: yLoc

ajudaORobinson:
  @inicializa os visitados, da push de r4, que sera flag de sucesso

  stmfd sp!, {r4, lr}
  bl inicializaVisitados

  bl posicaoYLocal
  mov r3, r0
  bl posicaoXLocal
  mov r2, r0
  bl posicaoYRobinson
  mov r1, r0
  bl posicaoXRobinson @Continua no r0

  @Achar caminho
  bl achar_caminho
  cmp r0, #0         @Testa se falhou
  bne desempilha     @Caso nao tenha falhado, desempilha
  @Senao, nao achou caminho e imprime a mensagem de falha
  bl imprimeFalha

desempilha:
  ldmfd sp!, {r4, lr}
  mov pc, lr

achar_caminho:
  stmfd sp!, {r4, lr} @push do r4 e do lr

  @r4 flag de sucesso 0=falha, 1=sucesso
  mov r4, #0

  stmfd sp!, {r0-r3}
  bl visitaCelula     @Marca a célula como visitada
  ldmfd sp!, {r0-r3}  @Retorna o r0-r3

  cmp r0, r2 @Testa para ver se r0 eh igual a posicao que queremos chegar
  bne nao_achou
  cmp r1, r3 @Testa para ver se r1 ja esta na posicao que queremos
  bne nao_achou

  @Caso contrario, se chegar aqui eh pq chegamos no destino
  mov r4, #1

  bl imprime

  ldmfd sp!, {r4, lr}
  mov pc, lr

nao_achou:
  stmfd sp!, {r0-r3} @começando pela direita, x+1, y

  add r0, r0, #1 @Soma um no x
  bl daParaPassar @Testa se nao é X
  cmp r0, #0 @retorno de r0 da daParaPassar, se for 0, nao da para passar
  ldmfd sp!, {r0-r3}
  beq caminho2 @Se r0 for 0, testamos um outro vizinho da coordenada atual

  @se nao pulei, da para passar
  stmfd sp!, {r0-r3}
  add r0, r0, #1
  bl foiVisitado @se for 1, ja foi visitado
  cmp r0, #0
  ldmfd sp!, {r0-r3}
  bne caminho2 @Se nao for 0, ja foi visitado e devo ir para outra coordenada

  @se cheguei aqui, posso visitar
  stmfd sp!, {r0-r3}
  add r0, r0, #1
  bl achar_caminho

  cmp r0, #0

  ldmfd sp!, {r0-r3}
  beq caminho2 @Se r0 for 0, nao achou o caminho e pode ir para outro vizinho da coordenada

  @Se chegou aqui, achou caminho e setamos r4=1
  stmfd sp!, {r0-r3}
  mov r4, #1
  bl imprime
  ldmfd sp!, {r0-r3}

  b end

caminho2:
  stmfd sp!, {r0-r3} @começando pela direita, x+1, y+1

  add r0, r0, #1 @Soma um no x
  add r1, r1, #1 @Soma 1 no y
  bl daParaPassar
  cmp r0, #0 @retorno de r0, se for 0, nao da para passar
  ldmfd sp!, {r0-r3}
  beq caminho3
  @se nao pulei, da para passar

  stmfd sp!, {r0-r3}
  add r0, r0, #1
  add r1, r1, #1
  bl foiVisitado @se for 1, ja foi visitado
  cmp r0, #0
  ldmfd sp!, {r0-r3}
  bne caminho3

  @se cheguei aqui, posso visitar
  stmfd sp!, {r0-r3}
  add r0, r0, #1
  add r1, r1, #1
  bl achar_caminho
  cmp r0, #0

  ldmfd sp!, {r0-r3}
  beq caminho3

  stmfd sp!, {r0-r3}
  mov r4, #1
  bl imprime @pula se nao for 0
  ldmfd sp!, {r0-r3}

  b end

caminho3:
  stmfd sp!, {r0-r3} @começando pela direita, x, y+1

  add r1, r1, #1
  bl daParaPassar
  cmp r0, #0 @retorno de r0, se for 0, nao da para passar
  ldmfd sp!, {r0-r3}
  beq caminho4
  @se nao pulei, da para passar

  stmfd sp!, {r0-r3}
  add r1, r1, #1
  bl foiVisitado @se for 1, ai nao quero
  cmp r0, #0
  ldmfd sp!, {r0-r3}
  bne caminho4

  @se cheguei aqui, posso visitar
  stmfd sp!, {r0-r3}
  add r1, r1, #1
  bl achar_caminho
  cmp r0, #0

  ldmfd sp!, {r0-r3}
  beq caminho4

  stmfd sp!, {r0-r3}
  mov r4, #1
  bl imprime @pula se nao for 0
  ldmfd sp!, {r0-r3}

  b end

caminho4:
  stmfd sp!, {r0-r3} @começando pela direita, x-1, y+1

  sub r0, r0, #1
  add r1, r1, #1
  bl daParaPassar
  cmp r0, #0 @retorno de r0, se for 0, nao da para passar
  ldmfd sp!, {r0-r3}
  beq caminho5
  @se nao pulei, da para passar

  stmfd sp!, {r0-r3}
  sub r0, r0, #1
  add r1, r1, #1
  bl foiVisitado @se for 1, ai nao quero
  cmp r0, #0
  ldmfd sp!, {r0-r3}
  bne caminho5

  @se cheguei aqui, posso visitar
  stmfd sp!, {r0-r3}
  sub r0, r0, #1
  add r1, r1, #1
  bl achar_caminho
  cmp r0, #0

  ldmfd sp!, {r0-r3}
  beq caminho5

  stmfd sp!, {r0-r3}
  mov r4, #1
  bl imprime @pula se nao for 0
  ldmfd sp!, {r0-r3}

  b end

caminho5:
  stmfd sp!, {r0-r3} @começando pela direita, x-1, y

  sub r0, r0, #1 @Sub um no x
  bl daParaPassar
  cmp r0, #0 @retorno de r0, se for 0, nao da para passar
  ldmfd sp!, {r0-r3}
  beq caminho6
  @se nao pulei, da para passar

  stmfd sp!, {r0-r3}
  sub r0, r0, #1
  bl foiVisitado @se for 1, ai nao quero
  cmp r0, #0
  ldmfd sp!, {r0-r3}
  bne caminho6

  @se cheguei aqui, posso visitar
  stmfd sp!, {r0-r3}
  sub r0, r0, #1
  bl achar_caminho
  cmp r0, #0

  ldmfd sp!, {r0-r3}
  beq caminho6

  stmfd sp!, {r0-r3}
  mov r4, #1
  bl imprime @pula se nao for 0
  ldmfd sp!, {r0-r3}

  b end

caminho6:
  stmfd sp!, {r0-r3} @começando pela direita, x-1, y-1

  sub r0, r0, #1 @Soma um no x
  sub r1, r1, #1
  bl daParaPassar
  cmp r0, #0 @retorno de r0, se for 0, nao da para passar
  ldmfd sp!, {r0-r3}
  beq caminho7
  @se nao pulei, da para passar

  stmfd sp!, {r0-r3}
  sub r0, r0, #1
  sub r1, r1, #1
  bl foiVisitado @se for 1, ai nao quero
  cmp r0, #0
  ldmfd sp!, {r0-r3}
  bne caminho7

  @se cheguei aqui, posso visitar
  stmfd sp!, {r0-r3}
  sub r0, r0, #1
  sub r1, r1, #1
  bl achar_caminho
  cmp r0, #0

  ldmfd sp!, {r0-r3}
  beq caminho7

  stmfd sp!, {r0-r3}
  mov r4, #1
  bl imprime @pula se nao for 0
  ldmfd sp!, {r0-r3}

  b end

caminho7:
  stmfd sp!, {r0-r3} @começando pela direita, x, y-1

  sub r1, r1, #1
  bl daParaPassar
  cmp r0, #0 @retorno de r0, se for 0, nao da para passar
  ldmfd sp!, {r0-r3}
  beq caminho8
  @se nao pulei, da para passar

  stmfd sp!, {r0-r3}
  sub r1, r1, #1
  bl foiVisitado @se for 1, ai nao quero
  cmp r0, #0
  ldmfd sp!, {r0-r3}
  bne caminho8

  @se cheguei aqui, posso visitar
  stmfd sp!, {r0-r3}
  sub r1, r1, #1
  bl achar_caminho
  cmp r0, #0

  ldmfd sp!, {r0-r3}
  beq caminho8

  stmfd sp!, {r0-r3}
  mov r4, #1
  bl imprime @pula se nao for 0
  ldmfd sp!, {r0-r3}

  b end

caminho8:
  stmfd sp!, {r0-r3} @começando pela direita, x+1, y-1

  add r0, r0, #1 @Soma um no x
  sub r1, r1, #1
  bl daParaPassar
  cmp r0, #0 @retorno de r0, se for 0, nao da para passar
  ldmfd sp!, {r0-r3}
  beq end
  @se nao pulei, da para passar

  stmfd sp!, {r0-r3}
  add r0, r0, #1
  sub r1, r1, #1
  bl foiVisitado @se for 1, ai nao quero
  cmp r0, #0
  ldmfd sp!, {r0-r3}
  bne end

  @se cheguei aqui, posso visitar
  stmfd sp!, {r0-r3}
  add r0, r0, #1
  sub r1, r1, #1
  bl achar_caminho
  cmp r0, #0

  ldmfd sp!, {r0-r3}
  beq end

  stmfd sp!, {r0-r3}
  mov r4, #1
  bl imprime @pula se nao for 0
  ldmfd sp!, {r0-r3}

  b end

end:
  mov r0, r4
  ldmfd sp!, {r4, lr}
  mov pc, lr


imprime:
  @x esta em r0, y esta em r1
  @write espera em r0 o endereço de output e em r1 o numero de char

  stmfd sp!, {r0-r3, lr}
  mov r2, r1 @x @imprimir invertido pois o enunciado adota uma convenção de X,Y e a matriz adota outra
  mov r3, r0 @y

  add r2, r2, #48  @transforma para char
  add r3, r3, #48

  ldr r0, =output
  strb r2, [r0] @coloca o char de r2 em r0
  mov r2, #' '
  strb r2, [r0, #1]
  strb r3, [r0, #2]
  mov r3, #'\n'
  strb r3, [r0, #3]

  mov r1, #4 @numero de caracteres que quero imprimir
  bl write
  ldmfd sp!, {r0-r3, lr}
  mov pc, lr

imprimeFalha:
  mov r0, #1      @ carrega o valor 1 em r0, indicando que a saída da syscall write sera em stdout
  ldr r1, =string @ carrega em r1 o endereco da string
  mov r2, #25     @ carrega em r2 o tamanho da string. r0,r1 e r2 serão os argumentos da syscall write
  mov r7, #4      @ carrega o valor 4 para r7, indica o tipo da syscall
  svc 0x0         @ realiza uma chamada de sistema (syscall)
  @mov r0, #123   @ return = 123
  mov r7, #1      @ carrega o valor 1 em r7, indicando a escolha da
  svc 0x0         @ syscall exit


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
