
#ifndef S_GPIO_H
#define S_GPIO_H

#define ADR_GPIO_BASE 		0x40000000

typedef struct
{
  uint32_t GPIO_0;   	// gpio register,        offset: 000
  uint32_t GPIO_1;  	// gpio register,        offset: 004
  uint32_t GPIO_2; 		// gpio register,        offset: 008
  uint32_t GPIO_3;  	// gpio register,        offset: 012
  uint32_t GPIO_4;  	// gpio register,        offset: 016
  uint32_t GPIO_5;     // gpio register,        offset: 020
  uint32_t GPIO_6;     // gpio register,        offset: 024
  uint32_t GPIO_7;     // gpio register,        offset: 028
} GPIO_t;
extern volatile GPIO_t* GPIO = ((GPIO_t *)ADR_GPIO_BASE);
#endif // S_GPIO_H

