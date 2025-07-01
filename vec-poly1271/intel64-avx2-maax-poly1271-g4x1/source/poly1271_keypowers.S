/* assembly to compute the key powers */

	.p2align 5
	.globl poly1271_keypowers
	
poly1271_keypowers:

	movq    %rsp,%r11
	andq 	$-32,%rsp
	subq 	$64,%rsp

	movq 	%r11,0(%rsp)
	movq 	%r12,8(%rsp)
	movq 	%r13,16(%rsp)
	movq 	%r14,24(%rsp)
	movq 	%r15,32(%rsp)
	movq 	%rbx,40(%rsp)
	movq 	%rbp,48(%rsp)
	
	movq	%rdx,%rbp

	movq    0(%rsi),%rax
	movq    8(%rsi),%rcx

	movq    %rax,448(%rdi)
	movq    %rcx,456(%rdi)
	
	cmpq	$1,%rbp
	je	.L3
	
	cmpq	$2,%rbp
	je	.L1

	movq    %rax,%r8
	andq    pmask1(%rip),%r8
	movq    %r8,24(%rdi)

	movq    %rax,%r8
	andq    pmask2(%rip),%r8
	shrq    $26,%r8
	movq    %r8,56(%rdi)

	movq    %rax,%r8
	andq    pmask3(%rip),%r8
	shrq    $52,%r8
	movq    %rcx,%r9
	andq    pmask4(%rip),%r9
	shlq    $12,%r9
	orq     %r9,%r8
	movq    %r8,88(%rdi)

	movq    %rcx,%r8
	andq    pmask5(%rip),%r8
	shrq    $14,%r8
	movq    %r8,120(%rdi)

	movq    %rcx,%r8
	andq    pmask6(%rip),%r8
	shrq    $40,%r8
	movq    %r8,152(%rdi)
	
.L1:
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

	movq    %rax,464(%rdi)
	movq    %rcx,472(%rdi)
	
	cmpq	$2,%rbp
	je	.L3
	
	cmpq	$3,%rbp
	je	.L2		

	movq    %rax,%r8
	andq    pmask1(%rip),%r8
	movq    %r8,16(%rdi)

	movq    %rax,%r8
	andq    pmask2(%rip),%r8
	shrq    $26,%r8
	movq    %r8,48(%rdi)

	movq    %rax,%r8
	andq    pmask3(%rip),%r8
	shrq    $52,%r8
	movq    %rcx,%r9
	andq    pmask4(%rip),%r9
	shlq    $12,%r9
	orq     %r9,%r8
	movq    %r8,80(%rdi)

	movq    %rcx,%r8
	andq    pmask5(%rip),%r8
	shrq    $14,%r8
	movq    %r8,112(%rdi)

	movq    %rcx,%r8
	andq    pmask6(%rip),%r8
	shrq    $40,%r8
	movq    %r8,144(%rdi)
	
.L2:
	movq    448(%rdi),%rdx

	mulx    464(%rdi),%r8,%r9
	mulx    472(%rdi),%rcx,%r10
	addq    %rcx,%r9
	adcq    $0,%r10

	xorq    %r11,%r11
	movq    456(%rdi),%rdx

	mulx    464(%rdi),%rcx,%rax
	adcx    %rcx,%r9
	adox    %rax,%r10

	mulx    472(%rdi),%rcx,%rax
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
	
	movq    %r8,480(%rdi)
	movq    %r9,488(%rdi)
	
	cmpq	$3,%rbp
	je	.L3

	movq    %r8,%rax
	andq    pmask1(%rip),%rax
	movq    %rax,8(%rdi)

	movq    %r8,%rax
	andq    pmask2(%rip),%rax
	shrq    $26,%rax
	movq    %rax,40(%rdi)

	movq    %r8,%rax
	andq    pmask3(%rip),%rax
	shrq    $52,%rax
	movq    %r9,%rcx
	andq    pmask4(%rip),%rcx
	shlq    $12,%rcx
	orq     %rcx,%rax
	movq    %rax,72(%rdi)

	movq    %r9,%rax
	andq    pmask5(%rip),%rax
	shrq    $14,%rax
	movq    %rax,104(%rdi)

	movq    %r9,%rax
	andq    pmask6(%rip),%rax
	shrq    $40,%rax
	movq    %rax,136(%rdi)

	movq    448(%rdi),%rdx

	mulx    480(%rdi),%r8,%r9
	mulx    488(%rdi),%rcx,%r10
	addq    %rcx,%r9
	adcq    $0,%r10

	xorq    %r11,%r11
	movq    456(%rdi),%rdx

	mulx    480(%rdi),%rcx,%rax
	adcx    %rcx,%r9
	adox    %rax,%r10

	mulx    488(%rdi),%rcx,%rax
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

	movq    %r8,%r11
	andq    pmask1(%rip),%r11
	movq    %r11,0(%rdi)

	movq    %r8,%r12
	andq    pmask2(%rip),%r12
	shrq    $26,%r12
	movq    %r12,32(%rdi)

	andq    pmask3(%rip),%r8
	shrq    $52,%r8
	movq    %r9,%r13
	andq    pmask4(%rip),%r13
	shlq    $12,%r13
	orq     %r8,%r13
	movq    %r13,64(%rdi)

	movq    %r9,%r14
	andq    pmask5(%rip),%r14
	shrq    $14,%r14
	movq    %r14,96(%rdi)

	andq    pmask6(%rip),%r9
	shrq    $40,%r9
	movq    %r9,128(%rdi)
	
	cmpq	$8,%rbp
	jl 	.L3
		
	movq    %r11,184(%rdi)
	movq    %r11,176(%rdi)
	movq    %r11,168(%rdi)
	movq    %r11,160(%rdi)

	movq    %r12,216(%rdi)
	movq    %r12,208(%rdi)
	movq    %r12,200(%rdi)
	movq    %r12,192(%rdi)

	movq    %r13,248(%rdi)
	movq    %r13,240(%rdi)
	movq    %r13,232(%rdi)
	movq    %r13,224(%rdi)

	movq    %r14,280(%rdi)
	movq    %r14,272(%rdi)
	movq    %r14,264(%rdi)
	movq    %r14,256(%rdi)

	movq    %r9,312(%rdi)
	movq    %r9,304(%rdi)
	movq    %r9,296(%rdi)
	movq    %r9,288(%rdi)	

	vmovdqa   vec8(%rip),%ymm12

	vpmuludq  192(%rdi),%ymm12,%ymm0
	vpmuludq  224(%rdi),%ymm12,%ymm1
	vpmuludq  256(%rdi),%ymm12,%ymm2
	vpmuludq  288(%rdi),%ymm12,%ymm3	

	vmovdqa   %ymm0,320(%rdi)
	vmovdqa   %ymm1,352(%rdi)
	vmovdqa   %ymm2,384(%rdi)
	vmovdqa   %ymm3,416(%rdi)

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
