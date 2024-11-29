#define RVTEST_DATA_BEGIN                                               	\
        .pushsection .tohost,"aw",@progbits;                            	\
        .align 6; .global tohost; tohost: .dword 0; .size tohost, 8;    	\
        .align 6; .global fromhost; fromhost: .dword 0; .size fromhost, 8;	\
        .popsection;                                                    	\
        .align 4; .global begin_signature; begin_signature:
#define RVTEST_CODE_BEGIN                                               	\
        .section .text.init;                                            	\
        .align  6;                                                      	\
        .global _start;                         							\
_start:                                 									\
    j main;                            										\
RVTEST_CODE_BEGIN

main:

	# PROLOGUE
		#addi sp, sp, -16
		#sw ra, 0(sp)
		#sw fp, 4(sp)
	# END PROLOGUE
	
	la t0, trapVector		# Setup Trap Vector
	csrw mtvec, t0
	
	csrr a0, mstatus		# Check Machine Mode Status

	li a0, 0				# Switch to Supervisor Mode
	call switchMode			

	csrr a0, sstatus		# Check Supervisor Mode Status

	ecall					# Call Trap Vector to Increment Mode to Machine (Supervisor Mode --Trap--> Machine Mode)
	
	csrr a0, mstatus		# Check Machine Mode Status

	li a0, 1				# Switch to User Mode
	call switchMode
	
	ecall					# Call Trap Vector twice to Increment Mode twice to Machine (User Mode --Trap--> Supervisor Mode --Trap--> Machine Mode)
	ecall
	
	csrr a0, mstatus		# Check Machine Mode Status
    
    # EPILOGUE
		#lw fp, 4(sp)
		#lw ra, 0(sp)
		#addi sp, sp, 16
	# END EPILOGUE
    
end_main: call writeToHost

writeToHost:

	# PROLOGUE
		#addi sp, sp, -16
		#sw ra, 0(sp)
		#sw fp, 4(sp)
	# END PROLOGUE

	li gp, 1
	sw gp, tohost, t5

	# EPILOGUE
		#lw fp, 4(sp)
		#lw ra, 0(sp)
		#addi sp, sp, 16
	# END EPILOGUE

end_writeToHost: call writeToHost
    
switchMode:

	# PROLOGUE
		#addi sp, sp, -16
		#sw ra, 0(sp)
		#sw fp, 4(sp)
	# END PROLOGUE
	
	mv t0, a0
	csrr t1, mstatus
	li t6, 0x1800
	not t6, t6
	and t1, t1, t6
	
	if1: bnez t0, else1
		li t6, 0x0800
		j end_if1
	else1:
		li t6, 0x0000
		j end_if1
	end_if1:
	
	or t1, t1, t6
	csrw mstatus, t1
	
	# EPILOGUE
		#lw fp, 4(sp)
		#lw ra, 0(sp)
		#addi sp, sp, 16
		csrw mepc, ra
	# END EPILOGUE

end_switchMode: mret

trapVector:

	# PROLOGUE
		#addi sp, sp, -32
		#sw ra, 0(sp)
		#sw fp, 4(sp)
		#sw s0, 8(sp)
		#sw s1, 12(sp)
		#sw s2, 16(sp)
	# END PROLOGUE
	
	csrr s0, mcause
	li s1, 9
	li s2, 8
	
	if2: bne s0, s1, elseif2
		li s1, 0x1800
		j end_if2
	elseif2: bne s0, s2, end_if2
		li s1, 0x0800
		j end_if2
	end_if2:

	csrr s0, mstatus
	or s0, s0, s1
	csrw mstatus, s0
	
	# EPILOGUE
		#lw s2, 16(sp)
		#lw s1, 12(sp)
		#lw s0, 8(sp)
		#lw fp, 4(sp)
		#lw ra, 0(sp)
		#addi sp, sp, 32
		addi ra, ra, 4
		csrw mepc, ra
	# END EPILOGUE

end_trapVector: mret
    
.data
base:
.word 0xcafebeef
RVTEST_DATA_BEGIN