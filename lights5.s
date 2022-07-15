.equ    switches, 0x00002030
.equ    leds, 0x00002020
.equ    hexa, 0x00002010
.equ    hexb, 0x00002000

.global _start
_start: movia r2, switches
        movia r3, leds
		  
LOOP:   ldbio r4, 0(r2)
        stbio r4, 0(r3)
		  
		  movia r5, hexa
		  movia r6, hexb
		  andi r7, r4, 0xF0 #leftbits
		  srli r7, r7, 4 #bitshift
		  
		  andi r8, r4, 0x0F #rightbits
		  
		  movia r10, lut
		  
		  slli r13, r7, 2
		  
		  add r13, r10, r13
		  ldw r14, 0(r13)
		  
		  slli r11, r8, 2
		  
		  add r11, r10, r11
		  ldw r12, 0(r11)
		  
		  stbio r12, 0(r5)
		  stbio r14, 0(r6)
        br LOOP
		  
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

.end