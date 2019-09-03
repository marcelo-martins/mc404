#include "api_robot2.h"

#define DIST3 900
#define DIST4 860

void curva();

void callback_func3();
void callback_func4();


int virar = 0;

int main(){
    //Motores
    motor_cfg_t motor0, motor1;
    motor0.id = 0;
    motor1.id = 1;

    unsigned int tempoFinal = 1;
    unsigned int tempoAtual = 0;
    int somador=1;

    motor0.speed = 25;
    motor1.speed = 25;
    set_motor_speed(&motor0);
    set_motor_speed(&motor1);

    int vezesRonda=0;//Se for 50, começa de novo a ronda

    register_proximity_callback(3, DIST3, callback_func3);
    register_proximity_callback(4, DIST4, callback_func4);
    add_alarm(curva, tempoFinal);

    set_time(0);
    while(1){
        tempoAtual = 0;
        set_time(tempoAtual);
        get_time(&tempoAtual);
        while ( tempoFinal > tempoAtual + 1) {
            get_time(&tempoAtual);
        }
        virar = 0;
        tempoFinal+=somador;
        add_alarm(curva, tempoFinal);
        while (virar == 0) {}
        vezesRonda++;
        if(vezesRonda==50){
          vezesRonda=0;
            tempoFinal=1;
        }
    }
    return 0;
}

void curva(){//vira 90 graus
    motor_cfg_t motor0, motor1;
    int i=0;
    motor0.id = 0;
    motor1.id = 1;

    motor0.speed = 0;
    motor1.speed = 0;
    set_motors_speed(&motor0, &motor1);
    for (i=0; i<10; i++){
      motor1.speed = 45;
      set_motor_speed(&motor1);
    }
    motor0.speed = 25;
    motor1.speed = 25;
    set_motors_speed(&motor0, &motor1);

    virar = 1;
    return;
}

void callback_func3(){//Desvia da parede virando para a direita
    motor_cfg_t motor0, motor1;
    motor0.id = 0;
    motor1.id = 1;
    unsigned int sonar[15];

    motor0.speed = 0;
    motor1.speed = 10;
    set_motors_speed(&motor0,&motor1);
    sonar[3] = read_sonar(3);
    sonar[0] = read_sonar(0);
    while(sonar[3] < sonar[0]){
      sonar[3] = read_sonar(3);
      sonar[0] = read_sonar(0);
    }
    motor0.speed = 20;
    motor1.speed = 20;
    set_motors_speed(&motor0, &motor1);

    register_proximity_callback(3, DIST3, callback_func3);
    return;
}

void callback_func4(){//Desvia da parede virando para a direita
    motor_cfg_t motor0, motor1;
    motor0.id = 0;
    motor1.id = 1;
    unsigned int sonar[15];

    motor0.speed = 0;
    motor1.speed = 10;
    set_motors_speed(&motor0,&motor1);
    sonar[4] = read_sonar(4);
    sonar[0] = read_sonar(0);
    while(sonar[4] < sonar[0]){
      sonar[4] = read_sonar(4);
      sonar[0] = read_sonar(0);
    }
    motor0.speed = 20;
    motor1.speed = 20;
    set_motors_speed(&motor0, &motor1);

    register_proximity_callback(4, DIST4, callback_func3);
    return;
}
