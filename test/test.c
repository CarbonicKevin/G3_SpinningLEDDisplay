#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define NO_THETAS     180 // delta theta to be used in calcs
#define NO_ARM_LED    32  // no. led's per arm
#define NO_POLAR_PAIR NO_THETAS * NO_ARM_LED
#define NO_STRIP_LED  144 // number of leds on the full strip
#define LED_STRIP_LEN 100 // cm
#define ARM_LEN       (LED_STRIP_LEN * NO_ARM_LED / NO_STRIP_LED)
#define DELTA_X       NO_STRIP_LED / LED_STRIP_LEN                   // space between LEDs

typedef struct {
    int r;
    int t;
} polar_pair;

typedef struct {
    int x;
    int y;
} car_pair;     

void print_array_polar(polar_pair *a, int len){
    for (int i=0; i<len; i++){
        printf("[%d, %d], ", a[i].r, a[i].t);
    }
    printf("\n");
}

void print_array_car(car_pair **a){
    for (int i=0; i<NO_THETAS; i++){
        printf("[");
        for (int j=0; j<NO_ARM_LED; j++){
            printf("[%d, %d], ", a[i][j].x, a[i][j].y);
        }
        printf("]\n");
    }
    printf("\n");
}

void main(void){
    int i, r, t, x, y, idx;

    // printf("%d\n", NO_POLAR_PAIR);

    polar_pair polar[NO_POLAR_PAIR];
    i = 0;
    for (r=0; r < NO_ARM_LED; r++){
        for (t=0; t<NO_THETAS; t++){
            polar[i].r = r;
            polar[i].t = t;
            i++;
        }
    }

    // print_array_polar(polar, NO_POLAR_PAIR);

    car_pair* sorted_by_theta[NO_THETAS];
    for (i=0; i<NO_THETAS; i++){
        sorted_by_theta[i] = (car_pair*)calloc(NO_ARM_LED,sizeof(car_pair));
    }
    int theta_idx[NO_THETAS];
    for (i=0; i < NO_THETAS; i++) theta_idx[i] = 0;
    for (i=0; i < NO_POLAR_PAIR; i++){
        r = polar[i].r;
        t = polar[i].t;
        idx = theta_idx[t];
        sorted_by_theta[t][idx].x = round(r*cos(t)) + 31;
        sorted_by_theta[t][idx].y = round(r*sin(t)) + 31;
        theta_idx[t]++;
    }

    // print_array_car(sorted_by_theta);

    return;
}