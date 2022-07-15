.equ    switches, 0x00003030
.equ    hexa, 0x00003010
.equ    hexb, 0x00003000

.global _start

__default_stacksize=1024

_start: 
	movia sp, STACK
	movia r16, switches
	movia r20, hexa
	movia r21, hexb


#main
	lewp: call read
	      mov r4, r2       	#moving the return value from the read function into the parameter for the next function to be called
	      
	      call fact
              mov r4, r2      	#moves return value from fact into parameter for next function to be called
	      
	      call printRes
              call lewp
              ret

read:
	ldbio r16, 0(r2)
	ret

fact:
	subi sp, sp, 12 	#allocates stack for registers by moving stack pointer
	stw r8, 4(sp)  		#allocates space for r8
	stw ra, 8(sp)		#allocates space for the return address

  loop: bne, r4, r0, else 	#this loop falls through if (r4 = 0)
	movi r2, 1		#makes the return register = 1
	br done
	
  else: mov r8, r4		#moves x into temporary register
	subi r4, r4, 1		#x = x - 1
	stw r8, 0(sp)		#allocates space for caller-save register r8
	call fact
	ldw r8, 0(sp)		#deallocates space for caller-save register r8
	mul r2, r8, r2		#r2 = fact(x-1) * x
	
  done: ldw r8, 4(sp)		#deallocates space for r8 register
	ldw ra, 8(sp)		#deallocates space for the return address
	addi sp, sp, 12		#deallocates stack for registers by moving stack pointer
	ret


print:
	movia r10, lut		#stores address of array lut into r10

	andi r8, r4, 0xF0	#left bits of 8-bit value
	srli r8, r8, 4		#shifts 4 bits to the right

	andi r9, r4, 0x0F	#right bits of 8-bit value

	slli r8, r8, 2		#shifts left bits 2 bits to the left to calculate i * size
	add r11, r8, r10	#r11 = size * i + &lut
	ldw r12, 0(r11)		#loads result into r11

	slli r9, r9, 2		#shifts right bits 2 bits to the left to calculate i * size
	add r13, r9, r10	#r13 = size * i + &lut
	ldw r14, 0(r13)		#loads result into r13
	
	stbio r12, 0(r21)
	stbio r14, 0(r20)
	
	.data
	lut:
	.word 0b1000000 #a[0]
	.word 0b1111001 #a[1]
	.word 0b0100100 #a[2]
	.word 0b0110000 #a[3]
	.word 0b0011001 #a[4]
	.word 0b0010010 #a[5]
	.word 0b0000010 #a[6]
	.word 0b1111000 #a[7]
	.word 0b0000000 #a[8]
	.word 0b0011000 #a[9]
	.word 0b0001000 #a[10]
	.word 0b0000011 #a[11]
	.word 0b0100111 #a[12]
	.word 0b0100001 #a[13]
	.word 0b0000110 #a[14]
	.word 0b0001110 #a[15]

.data
.skip __default_stacksize
STACK:
.end