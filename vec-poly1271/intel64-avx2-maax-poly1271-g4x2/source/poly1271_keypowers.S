/* assembly to compute the key powers */

	.p2align 5
	.globl poly1271_keypowers
	
poly1271_keypowers:

	movq    %rsp,%r11
	andq 	$-32,%rsp
	subq 	$64+3*8,%rsp

	movq 	%r11,0(%rsp)
	movq 	%r12,8(%rsp)
	movq 	%r13,16(%rsp)
	movq 	%r14,24(%rsp)
	movq 	%r15,32(%rsp)
	movq 	%rbx,40(%rsp)
	movq 	%rbp,48(%rsp)
	
	movq	%rdx,%rbp

	// pre-compute the powers of r

	// load 2-limb r
	movq    0(%rsi),%rax
	movq    8(%rsi),%rcx

	// pack and store 5-limb r
	movq    %rax,736+0*8(%rdi)
	movq    %rcx,736+1*8(%rdi)
	
	cmpq	$1,%rbp
	je	.L3
	
	cmpq	$2,%rbp
	je	.L1

	movq    %rax,%r8
	andq    pmask1(%rip),%r8
	movq    %r8,3*8(%rdi)

	movq    %rax,%r8
	andq    pmask2(%rip),%r8
	shrq    $26,%r8
	movq    %r8,7*8(%rdi)

	movq    %rax,%r8
	andq    pmask3(%rip),%r8
	shrq    $52,%r8
	movq    %rcx,%r9
	andq    pmask4(%rip),%r9
	shlq    $12,%r9
	orq     %r9,%r8
	movq    %r8,11*8(%rdi)

	movq    %rcx,%r8
	andq    pmask5(%rip),%r8
	shrq    $14,%r8
	movq    %r8,15*8(%rdi)

	movq    %rcx,%r8
	andq    pmask6(%rip),%r8
	shrq    $40,%r8
	movq    %r8,19*8(%rdi)
	
.L1:
	// compute r^2
	movq    %rcx,%rdx
	addq    %rdx,%rdx
	mulx    %rax,%r9,%r10

	movq    %rax,%rdx
	mulx    %rdx,%rax,%rdx
	addq    %rdx,%r9

	movq    %rcx,%rdx
	mulx    %rdx,%rcx,%r11
	adcq    %rcx,%r10
	adcq    $0,%r11

	shld    $1,%r10,%r11
	shld    $1,%r9,%r10

	andq	mask63(%rip),%r9
	xorq	%rdx,%rdx
	adcx    %r10,%rax
	adcx    %r11,%r9

	movq    %r9,%rcx
	andq	mask63(%rip),%rcx
	shrq    $63,%r9
	addq    %r9,%rax
	adcq    $0,%rcx

	// store 2-limb r^2
	movq    %rax,736+2*8(%rdi)
	movq    %rcx,736+3*8(%rdi)
	
	cmpq	$2,%rbp
	je	.L3
	
	cmpq	$3,%rbp
	je	.L2		

	// pack and store 5-limb r^2
	movq    %rax,%r8
	andq    pmask1(%rip),%r8
	movq    %r8,2*8(%rdi)

	movq    %rax,%r8
	andq    pmask2(%rip),%r8
	shrq    $26,%r8
	movq    %r8,6*8(%rdi)

	movq    %rax,%r8
	andq    pmask3(%rip),%r8
	shrq    $52,%r8
	movq    %rcx,%r9
	andq    pmask4(%rip),%r9
	shlq    $12,%r9
	orq     %r9,%r8
	movq    %r8,10*8(%rdi)

	movq    %rcx,%r8
	andq    pmask5(%rip),%r8
	shrq    $14,%r8
	movq    %r8,14*8(%rdi)

	movq    %rcx,%r8
	andq    pmask6(%rip),%r8
	shrq    $40,%r8
	movq    %r8,18*8(%rdi)
	
.L2:
	// compute r^3
	movq    736+0*8(%rdi),%rdx

	mulx    736+2*8(%rdi),%r8,%r9
	mulx    736+3*8(%rdi),%rcx,%r10
	addq    %rcx,%r9
	adcq    $0,%r10

	xorq    %r11,%r11
	movq    736+1*8(%rdi),%rdx

	mulx    736+2*8(%rdi),%rcx,%rax
	adcx    %rcx,%r9
	adox    %rax,%r10

	mulx    736+3*8(%rdi),%rcx,%rax
	adcx    %rcx,%r10
	adox    %rax,%r11
	adcx    zero(%rip),%r11

	shld    $1,%r10,%r11
	shld    $1,%r9,%r10

	andq	mask63(%rip),%r9
	xorq	%rdx,%rdx
	adcx    %r10,%r8
	adcx    %r11,%r9

	movq    %r9,%r10
	shrq    $63,%r10
	andq	mask63(%rip),%r9
	addq    %r10,%r8
	adcq    $0,%r9
	
	// store 2-limb r^3
	movq    %r8,736+4*8(%rdi)
	movq    %r9,736+5*8(%rdi)
	
	cmpq	$3,%rbp
	je	.L3

	// pack and store 5-limb r^3
	movq    %r8,%rax
	andq    pmask1(%rip),%rax
	movq    %rax,1*8(%rdi)

	movq    %r8,%rax
	andq    pmask2(%rip),%rax
	shrq    $26,%rax
	movq    %rax,5*8(%rdi)

	movq    %r8,%rax
	andq    pmask3(%rip),%rax
	shrq    $52,%rax
	movq    %r9,%rcx
	andq    pmask4(%rip),%rcx
	shlq    $12,%rcx
	orq     %rcx,%rax
	movq    %rax,9*8(%rdi)

	movq    %r9,%rax
	andq    pmask5(%rip),%rax
	shrq    $14,%rax
	movq    %rax,13*8(%rdi)

	movq    %r9,%rax
	andq    pmask6(%rip),%rax
	shrq    $40,%rax
	movq    %rax,17*8(%rdi)

	// compute r^4
	movq    736+2*8(%rdi),%rax
	movq    736+3*8(%rdi),%rcx
	
	movq    %rcx,%rdx
	addq    %rdx,%rdx
	mulx    %rax,%r9,%r10

	movq    %rax,%rdx
	mulx    %rdx,%rax,%rdx
	addq    %rdx,%r9

	movq    %rcx,%rdx
	mulx    %rdx,%rcx,%r11
	adcq    %rcx,%r10
	adcq    $0,%r11

	shld    $1,%r10,%r11
	shld    $1,%r9,%r10

	andq	mask63(%rip),%r9
	xorq	%rdx,%rdx
	adcx    %r10,%rax
	adcx    %r11,%r9

	movq    %r9,%rcx
	andq	mask63(%rip),%rcx
	shrq    $63,%r9
	addq    %r9,%rax
	adcq    $0,%rcx

	// pack and store 5-limb r^4
	movq    %rax,%r11
	andq    pmask1(%rip),%r11
	movq    %r11,0*8(%rdi)

	movq    %rax,%r12
	andq    pmask2(%rip),%r12
	shrq    $26,%r12
	movq    %r12,4*8(%rdi)

	movq	%rax,%r8
	andq    pmask3(%rip),%r8
	shrq    $52,%r8
	movq    %rcx,%r13
	andq    pmask4(%rip),%r13
	shlq    $12,%r13
	orq     %r8,%r13
	movq    %r13,8*8(%rdi)

	movq    %rcx,%r14
	andq    pmask5(%rip),%r14
	shrq    $14,%r14
	movq    %r14,12*8(%rdi)

	movq	%rcx,%r9
	andq    pmask6(%rip),%r9
	shrq    $40,%r9
	movq    %r9,16*8(%rdi)
	
	cmpq	$8,%rbp
	jl 	.L3
		
	// store 5-limb r^4
	movq    %r11,160+3*8(%rdi)
	movq    %r11,160+2*8(%rdi)
	movq    %r11,160+1*8(%rdi)
	movq    %r11,160+0*8(%rdi)

	movq    %r12,160+7*8(%rdi)
	movq    %r12,160+6*8(%rdi)
	movq    %r12,160+5*8(%rdi)
	movq    %r12,160+4*8(%rdi)

	movq    %r13,160+11*8(%rdi)
	movq    %r13,160+10*8(%rdi)
	movq    %r13,160+9*8(%rdi)
	movq    %r13,160+8*8(%rdi)

	movq    %r14,160+15*8(%rdi)
	movq    %r14,160+14*8(%rdi)
	movq    %r14,160+13*8(%rdi)
	movq    %r14,160+12*8(%rdi)

	movq    %r9,160+19*8(%rdi)
	movq    %r9,160+18*8(%rdi)
	movq    %r9,160+17*8(%rdi)
	movq    %r9,160+16*8(%rdi)	

	vmovdqa   vec8(%rip),%ymm12

	// pre-compute and store 8r^4

	/*
	vmovdqa   6*32(%rdi),%ymm12
	vmovdqa   7*32(%rdi),%ymm13
	vmovdqa   8*32(%rdi),%ymm14
	vmovdqa   9*32(%rdi),%ymm15

	vpsllq    $3,%ymm12,%ymm0
	vpsllq    $3,%ymm13,%ymm1
	vpsllq    $3,%ymm14,%ymm2
	vpsllq    $3,%ymm15,%ymm3
	*/
	
	vpmuludq  6*32(%rdi),%ymm12,%ymm0
	vpmuludq  7*32(%rdi),%ymm12,%ymm1
	vpmuludq  8*32(%rdi),%ymm12,%ymm2
	vpmuludq  9*32(%rdi),%ymm12,%ymm3	

	vmovdqa   %ymm0,15*32(%rdi)
	vmovdqa   %ymm1,16*32(%rdi)
	vmovdqa   %ymm2,17*32(%rdi)
	vmovdqa   %ymm3,18*32(%rdi)
	
	cmpq	$12,%rbp
	jl 	.L3	
	
	// compute r^8	
	movq    %rcx,%rdx
	addq    %rdx,%rdx
	mulx    %rax,%r9,%r10

	movq    %rax,%rdx
	mulx    %rdx,%rax,%rdx
	addq    %rdx,%r9

	movq    %rcx,%rdx
	mulx    %rdx,%rcx,%r11
	adcq    %rcx,%r10
	adcq    $0,%r11

	shld    $1,%r10,%r11
	shld    $1,%r9,%r10

	andq	mask63(%rip),%r9
	xorq	%rdx,%rdx
	adcx    %r10,%rax
	adcx    %r11,%r9

	movq    %r9,%rcx
	andq	mask63(%rip),%rcx
	shrq    $63,%r9
	addq    %r9,%rax
	adcq    $0,%rcx

	// pack and store 5-limb r^8
	movq    %rax,%r8
	andq    pmask1(%rip),%r8
	movq    %r8,320+3*8(%rdi)
	movq    %r8,320+2*8(%rdi)
	movq    %r8,320+1*8(%rdi)
	movq    %r8,320+0*8(%rdi)

	movq    %rax,%r8
	andq    pmask2(%rip),%r8
	shrq    $26,%r8
	movq    %r8,320+7*8(%rdi)
	movq    %r8,320+6*8(%rdi)
	movq    %r8,320+5*8(%rdi)
	movq    %r8,320+4*8(%rdi)

	movq    %rax,%r8
	andq    pmask3(%rip),%r8
	shrq    $52,%r8
	movq    %rcx,%r9
	andq    pmask4(%rip),%r9
	shlq    $12,%r9
	orq     %r9,%r8
	movq    %r8,320+11*8(%rdi)
	movq    %r8,320+10*8(%rdi)
	movq    %r8,320+9*8(%rdi)
	movq    %r8,320+8*8(%rdi)

	movq    %rcx,%r8
	andq    pmask5(%rip),%r8
	shrq    $14,%r8
	movq    %r8,320+15*8(%rdi)
	movq    %r8,320+14*8(%rdi)
	movq    %r8,320+13*8(%rdi)
	movq    %r8,320+12*8(%rdi)

	movq    %rcx,%r8
	andq    pmask6(%rip),%r8
	shrq    $40,%r8
	movq    %r8,320+19*8(%rdi)
	movq    %r8,320+18*8(%rdi)
	movq    %r8,320+17*8(%rdi)
	movq    %r8,320+16*8(%rdi)

	// compute 8r^8
	vpmuludq  11*32(%rdi),%ymm12,%ymm0
	vpmuludq  12*32(%rdi),%ymm12,%ymm1
	vpmuludq  13*32(%rdi),%ymm12,%ymm2
	vpmuludq  14*32(%rdi),%ymm12,%ymm3	

	vmovdqa   %ymm0,19*32(%rdi)
	vmovdqa   %ymm1,20*32(%rdi)
	vmovdqa   %ymm2,21*32(%rdi)
	vmovdqa   %ymm3,22*32(%rdi)	

.L3:
	movq 	0(%rsp),%r11
	movq 	8(%rsp),%r12
	movq 	16(%rsp),%r13
	movq 	24(%rsp),%r14
	movq 	32(%rsp),%r15
	movq 	40(%rsp),%rbx
	movq 	48(%rsp),%rbp

	movq 	%r11,%rsp

	ret
