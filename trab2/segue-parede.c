#include "api_robot2.h"

#define VEL 40
#define DIST 1200
void callback_func(motor_cfg_t, motor_cfg_t);

int main(){
    //Criação dos motores
    motor_cfg_t robot_motor0, robot_motor1;
    robot_motor0.id = 0;
    robot_motor1.id = 1;

    robot_motor0.speed = 45;
    robot_motor1.speed = 45;

    //Fazer o robo andar reto, depois chamar a callback_func para faze-lo virar
    set_motors_speed(&robot_motor0, &robot_motor1);
    register_proximity_callback(3, DIST, callback_func);
    register_proximity_callback(4, DIST, callback_func);

    while(1){}

}
//Se entrar aqui, a distancia de 3 ou 4 eh menor do que DIST
void callback_func(motor_cfg_t motor0, motor_cfg_t motor1){
      motor0.id = 0;
      motor1.id = 1;

      while(1){
      while((read_sonar(1)<=read_sonar(14))){
        motor0.speed = 3;
        motor1.speed = 6;
        set_motors_speed(&motor0, &motor1);
      }
      while(read_sonar(3)<1000){
        motor0.speed = 3;
        motor1.speed = 12;
        set_motors_speed(&motor0, &motor1);
      }
      while((read_sonar(1)>=read_sonar(14))){
        motor0.speed = 8;
        motor1.speed = 3;
        set_motors_speed(&motor0, &motor1);
      }
    }
}
