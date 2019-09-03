#include "api_robot2.h"

void curva();

int multiplicador = 100;
int alarm = 0;

int main() {
    motor_cfg_t motor0, motor1;

    //inicia os motores
    motor0.id = 0;
    motor1.id = 1;
    motor0.speed = 45;
    motor1.speed = 45;
    set_motors_speed(&motor0, &motor1);
    while (1) {
        set_time(1);
        add_alarm(curva, multiplicador);
        while(alarm == 0) {
        }
        alarm = 0;
        multiplicador += 300;
    }
    return ;
}

void curva() {
    motor_cfg_t motor0, motor1;
    unsigned int i = 0;
    unsigned int time = 0;
    motor0.id = 0;
    motor1.id = 1;


    for (i = 0; i < 10; i++) {
        motor0.speed = 0;
        motor1.speed = 50;
        set_motor_speed(&motor0);
    }
    motor0.speed = 45;
    motor1.speed = 45;
    set_motors_speed(&motor0, &motor1);

    alarm = 1;
    return;
}
