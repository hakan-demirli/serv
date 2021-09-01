#ifndef MAT_MUL_ADR_H
#define MAT_MUL_ADR_H

	#define FMRS 			16
	#define FMCS 			16
	#define SMCS 			16

	#define ADR_CONTROL_BASE 	0x20000000
	#define ADR_FM_BASE 		0x20000400
	#define ADR_SM_BASE 		0x20000800
	#define ADR_TM_BASE 		0x20000C00
	#define ADR_FINISHED 		0x20001000

	#define DATA_START        	0x01101010
	#define DATA_STOP         	0x00101010

	#define ACC_IO(x)   (*(volatile int *)(x))

	#define FM(r, c) (FM[(r)*FMCS + (c)])
	#define SM(r, c) (SM[(r)*SMCS + (c)])
	#define TM(r, c) (TM[(r)*SMCS + (c)])

	extern volatile int* FM = ((int *)ADR_FM_BASE);
	extern volatile int* SM = ((int *)ADR_SM_BASE);
	extern volatile int* TM = ((int *)ADR_TM_BASE);
#endif // MAT_MUL_ADR_H

