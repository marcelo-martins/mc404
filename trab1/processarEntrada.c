#include "montador.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//Pragmas das funcoes de erro
void errLexico(int);
void errGramatical(int);
//Funcao para localizar erro gramatical
int localizaErrGramatical(){
	Token t;
	Token k;

	if(getNumberOfTokens()<=1) return 0;

	int i;
	for(i = 0; i<getNumberOfTokens(); i++){
		t = recuperaToken(i);
		if(i != getNumberOfTokens()-1){
			k = recuperaToken(i+1);

			if(t.linha == k.linha){//Tokens em linhas diferentes nao produzem erro gramatical
				if(k.tipo == DefRotulo){//DefRotulo é sempre a primeira coisa da linha, se ele existir
					errGramatical(k.linha);
					return 1;
				}
				else if(k.tipo == Diretiva){//Erros para diretivas
					if(t.tipo == Diretiva || t.tipo == Decimal || t.tipo == Hexadecimal || t.tipo == Instrucao){
						errGramatical(k.linha);
						return 1;
					}
				}
				else if(k.tipo == Instrucao){//Erros para intrucoes
					if(t.tipo == Decimal || t.tipo == Hexadecimal || t.tipo == Diretiva){
						errGramatical(k.linha);
						return 1;
					}
				}
				else if(k.tipo == Hexadecimal){//Erros para hexadecimais
					if(t.tipo == Diretiva){
						if(strcmp(t.palavra, ".align")==0 || strcmp(t.palavra, ".wfill")==0){
							errGramatical(k.linha);
							return 1;
						}
					}
					else if(t.tipo == Decimal){
						if(i-1>=0){//Teste para .wfill Dec Hexa
							Token aux = recuperaToken(i-1);
							if(aux.linha == t.linha && strcmp(aux.palavra, ".wfill") !=0){
								errGramatical(k.linha);
								return 1;
							}
						}
						else{//Caso a linha seja Dec Hexa, sem .wfill no início, é erro
							errGramatical(k.linha);
							return 1;
						}
					}
					else if(t.tipo == DefRotulo){
						errGramatical(k.linha);
						return 1;
					}
				}
				else if(k.tipo == Decimal){//Erros para decimais
					if(t.tipo == DefRotulo || t.tipo == Hexadecimal){
						errGramatical(k.linha);
						return 1;
					}
					else if(t.tipo == Decimal){
						if(i-1>=0){//Teste para .wfill Dec Dec
							Token aux = recuperaToken(i-1);
							if(aux.linha == t.linha && strcmp(aux.palavra, ".wfill") !=0){
								errGramatical(k.linha);
								return 1;
							}
						}
						else{
							errGramatical(k.linha);
							return 1;
						}
					}
					else if(t.tipo == Diretiva){
						if(strcmp(t.palavra, ".set")==0){
							errGramatical(k.linha);
							return 1;
						}
					}
					else if(t.tipo == Nome){//Erros para nomes
						if(i-1>=0){//Teste para .set Nome, linhas nao podem comecar com nomes
							Token aux = recuperaToken(i-1);
							if(aux.linha == t.linha && strcmp(aux.palavra, ".set") !=0){
								errGramatical(k.linha);
								return 1;
							}
						}
						else{
							errGramatical(k.linha);
							return 1;
						}
					}
				}
				else if(k.tipo == Nome){
					if(!(t.tipo == Instrucao || t.tipo == Decimal || (t.tipo == Diretiva && strcmp(t.palavra, ".word")==0)
					|| (t.tipo == Diretiva && strcmp(t.palavra, ".set")==0))){
						errGramatical(k.linha);
						return 1;
					}
					if(t.tipo == Decimal){
						if(i-1>=0){
							Token aux = recuperaToken(i-1);
							if(aux.linha == t.linha && strcmp(aux.palavra, ".wfill") !=0){
								errGramatical(k.linha);
								return 1;
							}
						}
						else{
							errGramatical(k.linha);
							return 1;
						}
					}
				}
			}
		}
	}
	return 0;
}

//Criacao dos tokens
int processarPalavra(char* palavra, int linhaAtual, char** mnemonicos, char** diretivas){
	int i=0, j;
	Token t;
	int diretiva=0;
  t.palavra = malloc(sizeof(char) * (strlen(palavra)+1));//Salvar a palavra que pode vir a ser um token

	if(palavra[0] == '"' && palavra[strlen(palavra)-1] == '"'){//tirar aspas
		palavra[strlen(palavra)-1] = '\0';
		palavra = &palavra[1];
	}

	strcpy(t.palavra, palavra);
	t.linha = linhaAtual;
	for(i=0; i<17; i++){//teste para instrucao
		if(strcmp(palavra, mnemonicos[i])==0){
			t.tipo = Instrucao;
			adicionarToken(t);
			return 0;
		}
	}
	for(i=0; i<5; i++){//teste para diretiva
		if(strcmp(palavra, diretivas[i])==0){
			t.tipo = Diretiva;
			adicionarToken(t);
			diretiva=1;
			return 0;
		}
	}
	if(palavra[0] == '.' && diretiva==0){
		errLexico(linhaAtual);
		return 1;
	}
	if(strlen(palavra)>0){
		if(palavra[0] == '0' && palavra[1] == 'x'){//teste para hexadec
				t.tipo=Hexadecimal;
				adicionarToken(t);
				return 0;
		}
		if(palavra[strlen(palavra)-1] == ':'){//teste para definicao de rotulo
				if((int)palavra[0]>=48 && (int)palavra[0]<=57){
					errLexico(linhaAtual);
					return 1;
				}
				else{
					int g;
					for(g=0; g<strlen(palavra)-1; g++){
						if(palavra[g] == ':'){
							//erro
							errLexico(linhaAtual);
							return 1;
						}
					}
				}
			t.tipo = DefRotulo;
			adicionarToken(t);
			return 0;

		}
		//Teste para decimais
		j = 0;
		int sohNumero=0;
		for(j=0; j<strlen(palavra); j++){
			if((int)palavra[j]<48 || (int)palavra[j]>57){
				sohNumero=1;
			}
		}
		if(sohNumero == 0){
			t.tipo = Decimal;
			adicionarToken(t);
			return 0;
		}
	}
	//Teste para nomes
		if((int)palavra[0]>=48 && (int)palavra[0]<=57){
			errLexico(linhaAtual);
			return 1;
		}
		else{
			t.tipo = Nome;
			adicionarToken(t);
		}
		return 0;
}

//Processamento de cada linha e divisao dela em palavras
int processarFrase(char* linha, char** mnemonicos, char** diretivas, int numLinhas){
	int tamanho = strlen(linha);
  	int i=0;
  	int temSimbolo = 0;
  	int linhaAtual = numLinhas;
  	char *palavra = strtok(linha, " \t");
		int retorno;

	while( palavra != NULL ) {

  	if(strcmp(palavra, ".set") == 0){
  		temSimbolo = 1;
  	}
		retorno = processarPalavra(palavra, linhaAtual, mnemonicos, diretivas);
  		palavra = strtok(NULL, " \t");//Strtok separa cada linha em seus espaços e tabs
	}
	if(retorno == 1) return retorno;//Erros léxicos
	retorno = localizaErrGramatical();//Busca de erros gramaticais

	return retorno;
}

int processarEntrada(char* entrada, unsigned tamanho){//Primeira divisao do vetor de char da entrada
	//Vetores com todas as instrucoes e diretivas possiveis
  char* mnemonicos[17] = {"LOAD", "LOAD-", "LOAD|", "LOADmq", "LOADmq_mx", "STOR", "JUMP", "JMP+", "ADD", "ADD|", "SUB", "SUB|", "MUL", "DIV", "LSH", "RSH", "STORA"};
  char* diretivas[5] = {".word", ".set", ".org", ".wfill", ".align"};

  int i, tamanhoPalavra=0, j;
  char *linha;
  int numLinhas=1, start=0;
  int sucess;

  for(i=0; i<tamanho-1; i++){//Divisao da entrada em linhas
    tamanhoPalavra++;
    if(entrada[i] == '\0' || entrada[i]== '\n'){
      tamanhoPalavra--;
      linha = malloc(sizeof(char)* (tamanhoPalavra+1));
      for(j=0; j<tamanhoPalavra; j++){
        linha[j] = entrada[start];
        start++;
      }
      for(j=0; j<tamanhoPalavra; j++){
        if(linha[j] == '#'){
          linha[j]= '\0';
          break;
        }
      }
      linha[j]='\0';
      sucess = processarFrase(linha, mnemonicos, diretivas, numLinhas);
			if(sucess==1) break;
      start++;
      tamanhoPalavra = 0;
      numLinhas++;
      free(linha);
    }
  }
  if(sucess==0) imprimeListaTokens();//Caso nao haja erros, imprime
  return sucess;
}
void errLexico(int linha){
	fprintf(stderr, "ERRO LEXICO: palavra inválida na linha %d!\n", linha);
}
void errGramatical(int linha){
	fprintf(stderr, "ERRO GRAMATICAL: palavra na linha %d!\n", linha);
}
