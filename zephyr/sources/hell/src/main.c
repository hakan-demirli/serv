/*
 * Copyright (c) 2012-2014 Wind River Systems, Inc.
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#include <zephyr.h>
#include <sys/printk.h>
#include <kernel.h>

#ifndef GPIO_BASE
#define GPIO_BASE 0x40000000
#endif


volatile uint32_t * GPIO_0 = (uint32_t *)GPIO_BASE;
volatile uint32_t * GPIO_1 = (uint32_t *)(GPIO_BASE+4);
volatile uint32_t * GPIO_2 = (uint32_t *)(GPIO_BASE+8);



void main(void)
{
	while(1){
		printk("Hello World! %s\n", CONFIG_BOARD);
		GPIO_1[0] = 1;
		k_sleep(K_MSEC(1000));
		GPIO_1[0] = 0;
		k_sleep(K_MSEC(1000));
	}

}
