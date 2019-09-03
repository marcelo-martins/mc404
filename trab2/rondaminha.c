#include "api_robot2.h"

int main(){

    motor_cfg_t motor0, motor1;
    motor0.id = 0;
    motor1.id = 1;

    unsigned int time = 0;
    unsigned int time2 = 1;
    int somador=1;

    motor0.speed = 45;
    motor1.speed = 45;
    set_motor_speed(&motor0);
    set_motor_speed(&motor1);

    set_time(0);
    get_time(&time);

    while(1){
        set_time(0);
        time=0;

        add_alarm(curva, time);
        while(time<time2){
            get_time(&time);
        }
        time2+=somador;

    }
}

void curva(){
    motor_cfg_t motor0, motor1;
    motor0.id = 0;
    motor1.id = 1;

    motor0.speed = 0;
    motor1.speed = 45;
    set_motors_speed(&motor0, &motor1);

    for (i = 0; i < 5; i++) {
        set_motor_speed(&motor0);
        set_motor_speed(&motor1);
    }

    motor0.speed = 45;
    motor1.speed = 45;
    set_motors_speed(&motor0, &motor1);


}
