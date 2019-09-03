
include "mapa.h"
void ajudaORobinson(){
	if(recursaoRobinson(xLoc, yLoc, xRob, yRob)==0){
		printf("Nao existe um caminho!\n");
	}
}

int recursaoRobinson(int xLoc, int yLoc, int xRob, int yRob){//1 eh sucesso

	int achou=0;
	if(posicaoXRobinson()==xLoc && posicaoYRobinson()==yLoc) {
		printf("%d %d\n", xRob, yRob);
		return 1;
	}

	else{
		visitaCelula(xRob, yRob);
		
		if(daParaPassar(xRob+1, yRob) && !foiVisitado(xRob+1, yRob)){
			achou=1;
			recursaoRobinson(xLoc, yLoc, xRob+1, yRob);
		}
		else if(daParaPassar(xRob+1, yRob+1) && !foiVisitado(xRob+1, yRob+1)){
			achou=1;
			recursaoRobinson(xLoc, yLoc, xRob+1, yRob+1);
		}
		else if(daParaPassar(xRob, yRob+1)&& !foiVisitado(xRob, yRob+1)){
			achou=1;
			recursaoRobinson(xLoc, yLoc, xRob+1, yRob+1);
		}
		else if(daParaPassar(xRob-1, yRob+1)&& !foiVisitado(xRob-1, yRob+1)){
			achou=1;
			recursaoRobinson(xLoc, yLoc, xRob+1, yRob+1);
		}
		else if(daParaPassar(xRob-1, yRob)&& !foiVisitado(xRob-1, yRob)){
			achou=1;
			recursaoRobinson(xLoc, yLoc, xRob+1, yRob+1);
		}
		else if(daParaPassar(xRob-1, yRob-1)&& !foiVisitado(xRob-1, yRob-1)){
			achou=1;
			recursaoRobinson(xLoc, yLoc, xRob+1, yRob+1);
		}
		else if(daParaPassar(xRob, yRob-1)&& !foiVisitado(xRob, yRob-1)){
			achou=1;
			recursaoRobinson(xLoc, yLoc, xRob+1, yRob+1);
		}
		else if(daParaPassar(xRob+1, yRob-1)&& !foiVisitado(xRob+1, yRob-1)){
			achou=1;
			recursaoRobinson(xLoc, yLoc, xRob+1, yRob+1);
		}
		
		if(achou==1) {
			printf("%d %d\n", xRob, yRob);
			return 1;
		}
		else return 0;


	} 


}
