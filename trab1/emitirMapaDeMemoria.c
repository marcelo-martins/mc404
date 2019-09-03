#include "montador.h"
#include <stdio.h>
#include <stdlib.h>

/* Retorna:
 *  1 caso haja erro na montagem;
 *  0 caso não haja erro.
 */

int emitirMapaDeMemoria()
{
  int i, j=0, tamanhoNomes;
  Token aux;
  char* palavra = null;
  char** definicoes = malloc(sizeof(char*) * 4096);
  for(i=0; i< getNumberOfTokens(); i++){
    aux = recuperaToken(i);
    palavra = aux.palavra;
    if(aux.tipo == DefRotulo){
      palavra[strlen(palavra)-1] = '\0';//para retirar os 2 pontos
      definicoes[j] = aux.palavra;
      j++;
      tamanhoNomes=j;
    }
    else if(aux.tipo == Nome){
      Token ehSet;
      if(i>=1){
        ehSet = recuperaToken(i-1);
        palavra = ehSet.palavra;
        if(strcmp(palavra, ".set")==0){
          definicoes[j] = aux.palavra;
          j++;
          tamanhoNomes = j;
        }

        else{
          int g, find=0;
          for(g = 0; g<tamanhoNomes; g++){
            if(strcmp(palavra, definicoes[g])==0){
              find=1;
            }
            if(find==0){
              errNotUsed(palavra);
              return 1;
            }
          }
        }
      }
    }
  }

  for(i=0; i<tamanhoNomes; i++){
    printf("Palavra: %s\n", definicoes[i]);
  }
  for(i=tamanhoNomes; i<4096; i++){
    free(definicoes[i]);
  }



  printf("Você deve implementar esta função para a parte 2.\n");
  return 0;
}

void errNotUsed(char* palavra){
  fprintf(stderr, "USADO MAS NAO DEFINIDO: %s!\n", palavra);
}
