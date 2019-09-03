//
// #include "api_robot2.h"
//
// void callback_func(motor_cfg_t, motor_cfg_t);
//
//
// int main(){
//     int dist = 1330;
//     //Criação da struct
//     motor_cfg_t robot_motor0, robot_motor1;
//     robot_motor0.id = 0;
//     robot_motor1.id = 1;
//     robot_motor0.speed = 40;
//     robot_motor1.speed = 40;
//     set_motors_speed(&robot_motor0,&robot_motor1);
//
//     while(1){
//       dist = read_sonar(3);
//       if (dist < 600) {
//         robot_motor0.speed = 0;
//         robot_motor1.speed = 0;
//         set_motors_speed(&robot_motor0,&robot_motor1);
//       }
//       else {
//         robot_motor0.speed = 40;
//         robot_motor1.speed = 40;
//         set_motors_speed(&robot_motor0,&robot_motor1);
//       }
//
//     }
//
// }


#include "api_robot2.h"

#define VEL 40
#define DIST 600
void callback_func(motor_cfg_t, motor_cfg_t);
void callback_func1(motor_cfg_t, motor_cfg_t );


int main(){
    //Criação da struct
    motor_cfg_t robot_motor0, robot_motor1;
    robot_motor0.id = 0;
    robot_motor1.id = 1;

    robot_motor0.speed = 63;
    robot_motor1.speed = 63;

    set_motors_speed(&robot_motor0, &robot_motor1);

    int i=0;
    while(i<1000000){
      i++;
    }

    register_proximity_callback(3, 1200, callback_func);
    register_proximity_callback(4, 1200, callback_func);


    while(1){
      robot_motor0.speed=63;
      robot_motor1.speed=63;
      set_motors_speed(&robot_motor0, &robot_motor1);
    }

//
//     int i=0, j=0;
//     unsigned int time1 = 0, time2=0;
//
//
//
//     //set_time(1456);
//     //get_time(&time);
//     get_time(&time1);
//     set_time(0);
//
// laco:
//     while (time1==time2) {
//       get_time(&time2);
//       // set_time(i);
//       // i++;
//       // j=0;
//       // while(j<100){
//       //   read_sonar(3);
//       //   read_sonar(4);
//       //   read_sonar(5);
//       //   j++;
//       // }
//       i=0;
//       while(i<10){
//         read_sonar(3);
//         read_sonar(4);
//         read_sonar(5);
//         i++;
//       }
//     }
//     time1++;
//     set_time(time2);
//     goto laco;
    //set_time(69);
    //get_time(&time);
    //   robot_motor0.speed = 61;
    //   robot_motor1.speed = 61;
    //   set_motors_speed(&robot_motor0, &robot_motor1);
    //
    // //  while(i<100000){i++;}
    //
    //   //set_time(1200);
    //   get_time(&time);
    //   // while (time < 10000) {
    //   //   get_time(&time);
    //   // }
    //   while(1){
    //     set_time(0);
    //     set_motors_speed(&robot_motor0, &robot_motor1);
    //     // get_time(&time);
        // if(time>1000){
        //   robot_motor0.speed = 0;
        //   robot_motor1.speed = 0;
        //   set_motors_speed(&robot_motor0, &robot_motor1);
        // }
        // else{
        //   //set_time(0);
        //   get_time(&time);
        // }
      //}
      //robot_motor0.speed = 40;
      //set_motor_speed(&robot_motor0);

    // robot_motor0.speed = VEL;
    // robot_motor1.speed = VEL;
    // set_motors_speed(&robot_motor0, &robot_motor1);

    while(1){}

}

void callback_func(motor_cfg_t motor0, motor_cfg_t motor1){
      //motor_cfg_t robot_motor0, robot_motor1;
      motor0.id = 0;
      motor1.id = 1;


      motor0.speed = 12;
      motor1.speed = 12;
      set_motors_speed(&motor0, &motor1);

      register_proximity_callback(0, 600, callback_func1);
}
void callback_func1(motor_cfg_t motor0, motor_cfg_t motor1){
      motor0.speed = 63;
      motor1.speed = 12;
      set_motors_speed(&motor0, &motor1);

      register_proximity_callback(0, 600, callback_func1);
}
/*
target remote localhost:5000
c
p *(int)0x77801800
c
p *(int)0x77801800
c
p *(int)0x77801800
c
p *(int)0x77801800
c
p *(int)0x77801800
c
p *(int)0x77801800
c
p *(int)0x77801800
c
p *(int)0x77801800
c
p *(int)0x77801800
c
p *(int)0x77801800
c
p *(int)0x77801800
c
p *(int)0x77801800
c
p *(int)0x77801800
c
p *(int)0x77801800
c
p *(int)0x77801800
c
p *(int)0x77801800
c
p *(int)0x77801800
c
p *(int)0x77801800
c
p *(int)0x77801800
c
p *(int)0x77801800
c
p *(int)0x77801800
c
p *(int)0x77801800

*/

