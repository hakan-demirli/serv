# Detailed Instructions can be found at:
https://github.com/olofk/serv   
https://docs.zephyrproject.org/latest/getting_started/index.html   

# Install Updates
Run all the commands at ```~/``` directory.   
```
cd ~
```
Update package list:      
```
sudo apt update
```  
Install updates:  
```
sudo apt upgrade
```
# Get SERV:  
Install fusesoc:  
```
pip install fusesoc
```  
Get core library:  
```
fusesoc library add fusesoc_cores https://github.com/fusesoc/fusesoc-cores
```  
Get serv repo:  
```
fusesoc library add serv https://github.com/hakan-demirli/serv
```  

Set your path variables:  
```
export SERV=/home/zerotoasic/fusesoc_libraries/serv
export PATH=$SERV/:$PATH
export WORKSPACE=/home/zerotoasic
export PATH=$WORKSPACE/:$PATH
```
Install Verilator:  
```
sudo apt-get install verilator
```  
Run static code analysis:  
```
fusesoc run --target=lint serv
```  
Run hello_world test software:  
```
fusesoc run --target=verilator_tb servant --uart_baudrate=57600 --firmware=$SERV/sw/zephyr_hello.hex
```  

# RISC-V Compliance Tests:  
Build verilator test bench:  
```
fusesoc run --target=verilator_tb --build servant
```  
Download the test repo:  
```
git clone https://github.com/riscv/riscv-compliance --branch 1.0
```  
Run compliance tests:  
```
cd riscv-compliance && make TARGETDIR=$SERV/riscv-target RISCV_TARGET=serv RISCV_DEVICE=rv32i RISCV_ISA=rv32i TARGET_SIM=$WORKSPACE/build/servant_1.0.2-r1/verilator_tb-verilator/Vservant_sim
```  


# ZEPHYR  
```
cd ~
```  

```
sudo apt install --no-install-recommends git cmake ninja-build gperf \
  ccache dfu-util device-tree-compiler wget \
  python3-dev python3-pip python3-setuptools python3-tk python3-wheel xz-utils file \
  make gcc gcc-multilib g++-multilib libsdl2-dev
```  
```
pip3 install --user -U west
```  

```
pip3 install pyelftools
```  

```
echo 'export PATH=~/.local/bin:"$PATH"' >> ~/.bashrc
```

```
source ~/.bashrc
```

```
west init
```

```
west config manifest.path $SERV
```

```
west update
```

```
cd ~
```

```
wget https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.12.4/zephyr-sdk-0.12.4-x86_64-linux-setup.run
```

```
chmod +x zephyr-sdk-0.12.4-x86_64-linux-setup.run
```

```
./zephyr-sdk-0.12.4-x86_64-linux-setup.run -- -d ~/zephyr-sdk-0.12.4
```

```
cd zephyr/samples/hello_world
```

The .bin and .elf files will be generated at: ```/home/zerotoasic/zephyr/samples/hello_world/build/zephyr```

```
west build -b service
```

```
cd ~
```

```
python3 $SERV/sw/makehex.py /home/zerotoasic/zephyr/samples/hello_world/build/zephyr/zephyr.bin 4096 > hello.hex
```

Change the memsize accordingly  
```
fusesoc run --target=verilator_tb servant --uart_baudrate=57600 --memsize=32768 --firmware=/home/zerotoasic/hello.hex
```

# Errors and Solutions
``` 
%Warning-UNUSED
```   
![alt text](https://github.com/hakan-demirli/serv/blob/main/error_jpg/Warning_UNUSED.png?raw=true)  
SOLUTION
* Add “-Wno-UNUSED” argument to the serv.core
``` 
$readmem file not found
```   
![alt text](https://github.com/hakan-demirli/serv/blob/main/error_jpg/%24readmem%20file%20not%20found.png?raw=true)  
SOLUTION
* Set your $SERV and $WORKSPACE variables correctly.
``` 
RISC-V Compliance Error: Error 2
```   
![alt text](https://github.com/hakan-demirli/serv/blob/main/error_jpg/Compliance_error.png?raw=true)  
SOLUTION
* Change the RISCV_GCC variable to RISCV_GCC_A: riscv-target/serv/rv32i/make.include:
``` 
$readmem file address beyond bounds
```   
![alt text](https://github.com/hakan-demirli/serv/blob/main/error_jpg/%24readmem_file_address_beyond_bounds.png?raw=true)  
SOLUTION
* Use “--memsize=32768” argument to specify the memory size. Change the size accordingly.    
```fusesoc run --target=verilator_tb servant --uart_baudrate=57600 --memsize=32768 --firmware=/home/zerotoasic/zephyr/samples/hello_world/hello.hex```

``` 
unsupported or unknown PLI call: $dumpfile
```   
SOLUTION
* Update verilator by building latest version.
