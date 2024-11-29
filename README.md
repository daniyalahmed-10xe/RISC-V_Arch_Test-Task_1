# <center> RISC-V Arch Test </center>

## *<center> Implementation of Task 1 </center>*

#### Question Statement:

###### *Implement and configure a function and a trap handler to switch modes*

1. Pre-requisites:
	- mstatus specific fields, mepc, mtval, mtvec, mret, mcause, ecall

2. Implement the following in your test:
	1. Function:
		- Implement a function which will take an argument (0 or 1) and then jump to relevant mode (0 for supervisor and 1 for user). (This function is only called in machine mode)
	2. Trap handler:
		- Implement a trap handler function for mcause (SUPERVISOR_ECALL and USER_ECALL) and jump to 1 higher mode e.g if there is USER_ECALL then after handling the trap it should return in Supervisor mode.

3. Write assembly test:
	- Your test should start in M mode (How can you start your test in M-mode?) 
	- Setup your trap-handler and the function as explained in point b.
	- Try switching to S mode
	- Verify that you have switched to the required mode(Figure out How to verify this)
	- Try switching to U mode. (figure out how you can do this using standard way) Note: You are currently in S mode.
	- Now switch to M mode and exit the test. (always exit your test in M mode)

#### Build & Run:

###### *Compile Assembly File to Elf:*

```shell
riscv64-unknown-elf-gcc -march=rv32g -mabi=ilp32 -nostdlib -T link.ld test.S -o test.elf
```
###### *Create a Disassembly:*

```shell
riscv64-unknown-elf-objdump -D test.elf > test.disass
```

###### *Simulate on Spike & Generate Logfile:*

```shell
spike --isa=rv32gc -l --log-commits test.elf 1> spike.out 2> spike.log
```

###### *Simulate on Sail & Generate Logfile:*

```shell
riscv_sim_RV32 test.elf --trace=step 2> sail.out 1> sail.log
```

#### Documentation:

###### *Report Available at:*
-	<span style = 
			"color: rgb(255, 64, 92);
			background: rgb(228, 228, 228);
			padding: 4px 12px;
			border-radius: 10px"
		> RISC-V_Arch_Test_Task_1_Report.docx
	</span>

###### *Output Screenshots Available at:*
-	<span style = 
			"color: rgb(255, 64, 92);
			background: rgb(228, 228, 228);
			padding: 4px 12px;
			border-radius: 10px"
		> /Screenshots
	</span>