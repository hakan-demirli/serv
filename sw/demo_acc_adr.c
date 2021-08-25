#include <zephyr.h>
#include <sys/printk.h>
#include <kernel.h>

#define ACC_IO(x)   (*(volatile int *)(x))

#ifndef GPIO_BASE
#define GPIO_BASE 0x40000000
#endif

#define FM_0_0    (0x20001000)
#define FM_0_1    (0x20001004)
#define FM_0_2    (0x20001008)
#define FM_1_0    (0x20001080)
#define FM_1_1    (0x20001084)
#define FM_1_2    (0x20001088)
#define FM_2_0    (0x20001100)
#define FM_2_1    (0x20001104)
#define FM_2_2    (0x20001108)
 
 
#define SM_0_0    (0x20002000)
#define SM_0_1    (0x20002004)
#define SM_0_2    (0x20002008)
#define SM_1_0    (0x20002080)
#define SM_1_1    (0x20002084)
#define SM_1_2    (0x20002088)
#define SM_2_0    (0x20002100)
#define SM_2_1    (0x20002104)
#define SM_2_2    (0x20002108)
 
#define data_start 0x1030303
#define ACC_CONFIG    (0x20000000)
#define data_stop  0x30303
#define FINISHED    (0x20004000)
 
#define TM_0_0    (0x20003000)
#define TM_0_1    (0x20003004)
#define TM_0_2    (0x20003008)
#define TM_1_0    (0x20003080)
#define TM_1_1    (0x20003084)
#define TM_1_2    (0x20003088)
#define TM_2_0    (0x20003100)
#define TM_2_1    (0x20003104)
#define TM_2_2    (0x20003108)


typedef struct
{
  uint32_t GPIO_0;   	// gpio register,        offset: 000
  uint32_t GPIO_1;  	// gpio register,        offset: 004
  uint32_t GPIO_2; 	// gpio register,        offset: 008
  uint32_t GPIO_3;  	// gpio register,        offset: 012
  uint32_t GPIO_4;  	// gpio register,        offset: 016
  uint32_t GPIO_5;     // gpio register,        offset: 020
  uint32_t GPIO_6;     // gpio register,        offset: 024
  uint32_t GPIO_7;     // gpio register,        offset: 028
} GPIO_t;

union printable_integer {
/* %d and %x are not working for printk*/
    uint32_t   myint;
    struct {
        char char1;
        char char2;
        char char3;
        char char4;
    } myChars;
};

volatile GPIO_t* GPIO = ((uint32_t *)GPIO_BASE);

void main(void)
{
	union printable_integer p_int;
	
	ACC_IO(FM_0_0) = 1;
	ACC_IO(FM_0_1) = 2;
	ACC_IO(FM_0_2) = 3;
	ACC_IO(FM_1_0) = 4;
	ACC_IO(FM_1_1) = 5;
	ACC_IO(FM_1_2) = 6;
	ACC_IO(FM_2_0) = 7;
	ACC_IO(FM_2_1) = 8;
	ACC_IO(FM_2_2) = 9;
	printk("fm\n");
	
	ACC_IO(SM_0_0) = 1;
	ACC_IO(SM_0_1) = 2;
	ACC_IO(SM_0_2) = 3;
	ACC_IO(SM_1_0) = 4;
	ACC_IO(SM_1_1) = 5;
	ACC_IO(SM_1_2) = 6;
	ACC_IO(SM_2_0) = 7;
	ACC_IO(SM_2_1) = 8;
	ACC_IO(SM_2_2) = 9;
	printk("sm\n");
	
	ACC_IO(ACC_CONFIG) = data_start; // start = 1
	ACC_IO(ACC_CONFIG) = data_stop; // start = 0
	printk("conf\n");
	
	while(!ACC_IO(FINISHED)){

	}
	printk("finished\n");
	
	p_int.myint = (uint32_t)ACC_IO(TM_0_0);
	printk("%c\n",p_int.myChars.char1);
	p_int.myint = (uint32_t)ACC_IO(TM_0_1);
	printk("%c\n",p_int.myChars.char1);
	p_int.myint = (uint32_t)ACC_IO(TM_0_2);
	printk("%c\n",p_int.myChars.char1);
	p_int.myint = (uint32_t)ACC_IO(TM_1_0);
	printk("%c\n",p_int.myChars.char1);
	p_int.myint = (uint32_t)ACC_IO(TM_1_1);
	printk("%c\n",p_int.myChars.char1);
	p_int.myint = (uint32_t)ACC_IO(TM_1_2);
	printk("%c\n",p_int.myChars.char1);
	p_int.myint = (uint32_t)ACC_IO(TM_2_0);
	printk("%c\n",p_int.myChars.char1);
	p_int.myint = (uint32_t)ACC_IO(TM_2_1);
	printk("%c\n",p_int.myChars.char1);
	p_int.myint = (uint32_t)ACC_IO(TM_2_2);
	printk("%c\n",p_int.myChars.char1);
	
	while(1){
		printk("looping\n");
		GPIO->GPIO_1 = 1;
		k_sleep(K_MSEC(500));
		GPIO->GPIO_1 = 0;
		k_sleep(K_MSEC(500));
	}
}