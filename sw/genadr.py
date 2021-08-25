from sys import argv

'''
B_A:
    mem = 000
    acc = 001
    gpio = 010
    timer = 100
    testcon = 110
CONFIG:
    #define ACC_CONFIG    0x20000000
    #define FINISHED      0x20004000
'''
#define data_stop     0x00030303
#define data_start    0x01030303

B_A = 0b001
F_MATRIX_ROW_SIZE = int(argv[1])
F_MATRIX_COLUMN_SIZE = int(argv[2])
S_MATRIX_COLUMN_SIZE = int(argv[3])

base_address = B_A << 29
#print("{0:b}".format(base_address).zfill(32))

for row in range(0,(F_MATRIX_ROW_SIZE)*4,4):
    row_base = base_address | ((row)<<5)
    for column in range(0,(F_MATRIX_COLUMN_SIZE)*4,4):
        SMTH = row_base | ((column))
        SMTH = SMTH | (1<<12)
        print(f'#define FM_{row//4}_{column//4}    0x' + "{0:x}".format(SMTH).zfill(8))
print("\n")

for row in range(0,(F_MATRIX_COLUMN_SIZE)*4,4):
    row_base = base_address | ((row)<<5)
    for column in range(0,(S_MATRIX_COLUMN_SIZE)*4,4):
        SMTH = row_base | ((column))
        SMTH = SMTH | (2<<12)
        print(f'#define SM_{row//4}_{column//4}    0x' + "{0:x}".format(SMTH).zfill(8))
print("\n")

for row in range(0,(F_MATRIX_ROW_SIZE)*4,4):
    row_base = base_address | ((row)<<5)
    for column in range(0,(S_MATRIX_COLUMN_SIZE)*4,4):
        SMTH = row_base | ((column))
        SMTH = SMTH | (3<<12)
        print(f'#define TM_{row//4}_{column//4}    0x' + "{0:x}".format(SMTH).zfill(8))
print("\n")

data_start = F_MATRIX_ROW_SIZE
data_start = data_start | (F_MATRIX_COLUMN_SIZE<<8)
data_start = data_start | (S_MATRIX_COLUMN_SIZE<<16)
data_start = data_start | (1<<24)
print(f'#define DATA_START    0x' + "{0:x}".format(data_start).zfill(8))

data_stop = F_MATRIX_ROW_SIZE
data_stop = data_stop | (F_MATRIX_COLUMN_SIZE<<8)
data_stop = data_stop | (S_MATRIX_COLUMN_SIZE<<16)
data_stop = data_stop | (0<<24)
print(f'#define DATA_STOP     0x' + "{0:x}".format(data_stop).zfill(8))
print('#define ACC_CONFIG    0x20000000')
print('#define FINISHED      0x20004000')

