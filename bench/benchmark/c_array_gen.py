from sys import argv
from contextlib import redirect_stdout
from random import randint
import numpy as np

# generate two RxC matrices and their multiplication
# $ python c_array_gen.py 16 16 > data.txt

RS = int(argv[1])
CS = int(argv[2])
fm_np = np.random.randint(255, size=(RS, CS))
sm_np = np.random.randint(255, size=(RS, CS))
verify_np = np.zeros((RS,CS))
def create_c_array(RS,CS,rnd_matrix,nm):
    print(f'int DATA_{nm}[{RS*CS}] = ',end='')
    for row in range(0,RS):
        if(row == 0):
            print('{',end='')
        else:
            print('                ',end='')
        for column in range(0,CS-1):
            r_int = rnd_matrix[row,column]
            print(str(r_int).zfill(0) + ',',end='')
        r_int = rnd_matrix[row,column+1]
        print(str(r_int) ,end='')
        if(row == RS-1):
            print("};")
        else:
            print(',')
create_c_array(RS,CS,fm_np,0)
create_c_array(RS,CS,sm_np,1)
verify_np = np.matmul(fm_np, sm_np)
create_c_array(RS,CS,verify_np,2)
