#include <zephyr.h>
#include <sys/printk.h>
#include <kernel.h>

#define fm_row_size 16
#define fm_column_size 16
#define sm_column_size 16

#define ADR_TIMER_BASE 0x80000000
#define TMR(x)   (*(volatile uint32_t *)(x))

#define DATA_0(r, c) (DATA_0[(r)*fm_column_size + (c)])
#define DATA_1(r, c) (DATA_1[(r)*sm_column_size + (c)])
#define DATA_2(r, c) (DATA_2[(r)*sm_column_size + (c)])
#define DATA_3(r, c) (DATA_3[(r)*sm_column_size + (c)])

union printable_integer {
/* %d and %x are not working for printk*/
    int   myint;
    uint32_t   myuint;
    struct {
        char char1;
        char char2;
        char char3;
        char char4;
    } myChars;
};

int multiply(int n, int m) {

	int ans = 0;
	int count = 0;

	while (m)
	{
		if ((m & 0x1) == 1){          
			ans = ans + (n << count);
		}

		count = count + 1;
		m = m >> 1;
	}	

	return ans;
}

void main(void)
{
	union printable_integer p_int;

static int DATA_0[256] = {66,235,20,171,192,121,55,66,15,233,196,204,193,246,233,219,
                148,135,101,21,225,86,63,161,242,59,17,120,41,52,4,57,
                87,171,31,118,48,178,225,6,181,112,253,166,215,222,69,138,
                32,179,228,253,116,52,22,241,57,130,34,226,192,120,154,163,
                216,88,38,220,92,116,17,157,37,252,151,141,63,100,54,217,
                214,223,162,151,31,106,15,76,245,155,241,246,156,28,66,119,
                185,78,193,192,3,6,17,230,221,20,182,17,194,89,199,84,
                251,128,206,153,110,118,84,101,92,145,151,93,122,80,164,120,
                197,39,195,201,29,21,243,194,220,96,133,74,8,34,105,75,
                232,85,197,250,31,19,179,91,150,43,179,134,61,152,61,75,
                5,50,223,40,169,237,152,110,32,106,237,254,70,154,0,176,
                78,136,162,32,48,91,215,237,58,201,103,22,7,208,251,73,
                200,133,27,115,1,176,34,94,182,155,227,216,89,211,141,5,
                73,159,86,181,155,109,78,152,2,138,46,175,245,77,231,239,
                239,66,90,19,132,127,189,19,125,249,56,152,28,235,44,52,
                254,88,83,5,88,209,35,125,104,193,21,184,216,128,232,219};
static int DATA_1[256] = {4,33,56,27,111,55,110,132,239,17,198,123,71,147,196,159,
                92,222,248,176,64,207,83,250,139,215,181,56,236,177,70,250,
                61,213,80,53,86,32,157,124,106,158,150,128,179,237,46,44,
                28,206,66,45,67,53,69,8,163,156,152,18,119,150,121,144,
                23,175,246,141,30,26,81,8,252,20,81,252,128,194,160,50,
                63,43,131,78,158,249,82,98,111,196,216,76,54,156,97,172,
                198,40,80,217,45,88,129,206,183,26,79,73,41,126,234,53,
                241,230,67,167,89,59,200,119,168,210,58,119,32,130,36,70,
                96,70,167,52,158,234,146,19,13,94,30,28,148,5,12,116,
                202,207,194,116,245,148,176,237,73,150,142,148,185,78,231,87,
                241,35,120,182,69,1,166,39,5,241,149,19,193,86,50,153,
                110,230,107,33,69,26,60,7,20,25,60,118,18,157,151,44,
                75,178,17,243,118,205,71,253,100,245,208,11,229,163,59,37,
                103,80,57,196,204,15,45,217,75,173,235,86,7,99,92,19,
                115,113,26,249,105,188,141,100,0,75,9,184,132,194,161,208,
                206,121,242,232,138,62,99,218,220,157,164,142,16,163,24,211};
static int DATA_2[256] = {296631,359940,316181,385516,283470,249964,254754,341719,269594,354726,345403,256314,286556,357166,280095,300158,
                154709,219471,217976,173902,158539,164705,177591,162910,203567,174564,178700,169808,167490,206684,155243,161851,
                274176,261592,262652,328759,253292,245584,232223,304479,224743,321367,320356,168920,252727,284677,235828,252696,
                248803,385293,250932,299298,230298,210343,243617,278856,256435,321858,282785,223231,252565,341543,214945,237959,
                240359,281998,250150,247152,234626,172799,224117,248921,253283,272952,281324,200126,202351,268810,226782,242912,
                250818,316358,279007,259131,244952,243215,257479,258661,223524,315689,300154,184844,289940,299357,217968,279288,
                219202,262638,174429,261704,204346,198334,240473,223635,200122,289440,239546,158050,242204,262819,159778,227193,
                226280,287307,239886,273074,230126,210634,247619,267106,256710,280909,290675,215319,253562,313326,238517,256271,
                231089,240449,194089,223796,188807,168899,243471,205865,224500,222129,210589,169331,197483,245876,210101,206202,
                210709,249791,195511,229800,195763,152597,220533,219942,229525,245083,261479,161558,208189,266286,212820,211563,
                261676,275123,259397,269725,213628,160743,224436,236359,225183,282992,279018,207530,195597,295678,206731,196860,
                269391,258701,209537,303876,226745,196396,248732,287266,210034,264270,235015,211872,201300,270746,228792,216939,
                231302,248000,215486,247497,244812,217477,223596,233416,174657,279474,275877,168486,222000,250743,221678,238019,
                248251,338561,254928,333178,227942,231390,228981,297235,265821,300205,282062,231038,242242,336602,235485,258458,
                200679,218375,223472,222874,232135,174373,200901,252508,219059,197248,256358,199279,175833,236267,252627,178032,
                242010,292853,250236,307992,273705,260990,241568,312321,253937,282250,299424,243131,225189,318524,249203,262764};

	int DATA_3[256];
	printk("m_ing\n");
	
	uint32_t start_time = TMR(ADR_TIMER_BASE);
	int i, j, k;
	int sum = 0;
	for (i = 0; i < fm_row_size; i++) {
		for (j = 0; j < sm_column_size; j++) {
			sum = 0;
			for (k = 0; k < fm_column_size; k++){
				sum += multiply(DATA_0(i,k),DATA_1(k,j));
			}
			DATA_3(i,j) = sum;
		}
	}
	p_int.myuint =  TMR(ADR_TIMER_BASE);
	
	printk("Finished at(cycle) = %c%c%c%c\n", p_int.myChars.char4,p_int.myChars.char3,p_int.myChars.char2,p_int.myChars.char1);
	p_int.myuint = p_int.myuint - start_time;
	printk("Total count(cycle) = %c%c%c%c\n", p_int.myChars.char4,p_int.myChars.char3,p_int.myChars.char2,p_int.myChars.char1);
	p_int.myuint =  start_time;
	printk("Started at(cycle) = %c%c%c%c\n", p_int.myChars.char4,p_int.myChars.char3,p_int.myChars.char2,p_int.myChars.char1);
	
	printk("m_done\n");
	for(int i = 0; i<fm_row_size; i++){
		for(int j = 0; j<sm_column_size; j++){
			if(DATA_2(i,j) == DATA_3(i,j)){
				//printk("eq\n");
			}else{
				printk("f");
			}
		}
	}

	while(1){
		printk("looping\n");
		k_sleep(K_MSEC(500));
	}
}

