/* assembly constants  */

.data

.globl vec8
.globl vecmask26
.globl vecmask23
.globl vecpad
.globl vecpadend
.globl veczero

.globl mask26
.globl mask23
.globl mask62
.globl mask63
.globl zero

.globl pmask1
.globl pmask2
.globl pmask3
.globl pmask4
.globl pmask5
.globl pmask6
.globl pmask7

.globl pmask8
.globl pmask9
.globl pmask10
.globl pmask11

.globl p0
.globl p1

.globl mask56
.globl c

.globl sh8
.globl sh56
.globl vecmask240
.globl vecmask56q1

.p2align 5

vec8		: .quad 8,8,8,8
vecmask26	: .quad 0x3FFFFFF,0x3FFFFFF,0x3FFFFFF,0x3FFFFFF
vecmask23	: .quad 0x7FFFFF,0x7FFFFF,0x7FFFFF,0x7FFFFF
vecpad		: .quad 0x10000,0x10000,0x10000,0x10000
vecpadend	: .quad 0x10000,0x10000,0x10000,0x00000
veczero	: .quad 0,0,0,0

mask26		: .quad 0x0000000003FFFFFF
mask23		: .quad 0x00000000007FFFFF
mask62		: .quad 0x3FFFFFFFFFFFFFFF
mask63		: .quad 0x7FFFFFFFFFFFFFFF
zero		: .quad 0x0

pmask1		: .quad 0x0000000003FFFFFF
pmask2		: .quad 0x000FFFFFFC000000
pmask3		: .quad 0xFFF0000000000000
pmask4		: .quad 0x0000000000003FFF
pmask5		: .quad 0x000000FFFFFFC000
pmask6		: .quad 0x7FFFFF0000000000

pmask8		: .quad 0x0000000003FFF000
pmask9		: .quad 0x00000000007FFFFF
pmask10 	: .quad 0x000000000F000000
pmask11 	: .quad 0x0000000000000FFF

p0		: .quad 0xFFFFFFFFFFFFFFFF
p1		: .quad 0x7FFFFFFFFFFFFFFF

mask56		: .quad 0x00FFFFFFFFFFFFFF
c		: .quad 0x0100000000000000


sh8		: .quad 0,0,8,8
sh56		: .quad 0,0,56,56
vecmask240	: .quad 0,0,-1,0xFFFFFFFFFFFF
vecmask56q1	: .quad -1,0xFFFFFFFFFFFFFF,-1,-1
