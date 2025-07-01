/* assembly to compute the key powers */

	.p2align 5
	.globl poly1271_keypowers
	
poly1271_keypowers:

	movq    %rsp,%r11
	andq 	$-32,%rsp
	subq 	$88,%rsp

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

	movq    %rax,1312(%rdi)
	movq    %rcx,1320(%rdi)
	
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

	movq    %rax,1328(%rdi)
	movq    %rcx,1336(%rdi)
	
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
	movq    1312(%rdi),%rdx

	mulx    1328(%rdi),%r8,%r9
	mulx    1336(%rdi),%rcx,%r10
	addq    %rcx,%r9
	adcq    $0,%r10

	xorq    %r11,%r11
	movq    1320(%rdi),%rdx

	mulx    1328(%rdi),%rcx,%rax
	adcx    %rcx,%r9
	adox    %rax,%r10

	mulx    1336(%rdi),%rcx,%rax
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
	
	movq    %r8,1344(%rdi)
	movq    %r9,1352(%rdi)
	
	cmpq	$3,%rbp
	je	.L3

	movq    %r8,%rax
	andq    pmask1(%rip),%r8
	movq    %r8,8(%rdi)

	movq    %rax,%r8
	andq    pmask2(%rip),%r8
	shrq    $26,%r8
	movq    %r8,40(%rdi)

	movq    %rax,%r8
	andq    pmask3(%rip),%r8
	shrq    $52,%r8
	movq    %r9,%rcx
	andq    pmask4(%rip),%r9
	shlq    $12,%r9
	orq     %r9,%r8
	movq    %r8,72(%rdi)

	movq    %rcx,%r9
	andq    pmask5(%rip),%r9
	shrq    $14,%r9
	movq    %r9,104(%rdi)

	movq    %rcx,%r9
	andq    pmask6(%rip),%r9
	shrq    $40,%r9
	movq    %r9,136(%rdi)

	movq    1328(%rdi),%rax
	movq    1336(%rdi),%rcx
	
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
	
	movq	%rax,64(%rsp)
	movq	%rcx,72(%rsp)	

	movq    %rax,%r11
	andq    pmask1(%rip),%r11
	movq    %r11,0(%rdi)

	movq    %rax,%r12
	andq    pmask2(%rip),%r12
	shrq    $26,%r12
	movq    %r12,32(%rdi)

	movq	%rax,%r8
	andq    pmask3(%rip),%r8
	shrq    $52,%r8
	movq    %rcx,%r13
	andq    pmask4(%rip),%r13
	shlq    $12,%r13
	orq     %r8,%r13
	movq    %r13,64(%rdi)

	movq    %rcx,%r14
	andq    pmask5(%rip),%r14
	shrq    $14,%r14
	movq    %r14,96(%rdi)

	movq	%rcx,%r9
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

	vmovdqa   %ymm0,800(%rdi)
	vmovdqa   %ymm1,832(%rdi)
	vmovdqa   %ymm2,864(%rdi)
	vmovdqa   %ymm3,896(%rdi)	
	
	cmpq	$12,%rbp
	jl 	.L3	
	
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
	
	movq	%rax,80(%rsp)
	movq	%rcx,88(%rsp)	

	movq    %rax,%r8
	andq    pmask1(%rip),%r8
	movq    %r8,344(%rdi)
	movq    %r8,336(%rdi)
	movq    %r8,328(%rdi)
	movq    %r8,320(%rdi)

	movq    %rax,%r8
	andq    pmask2(%rip),%r8
	shrq    $26,%r8
	movq    %r8,376(%rdi)
	movq    %r8,368(%rdi)
	movq    %r8,360(%rdi)
	movq    %r8,352(%rdi)

	movq    %rax,%r8
	andq    pmask3(%rip),%r8
	shrq    $52,%r8
	movq    %rcx,%r9
	andq    pmask4(%rip),%r9
	shlq    $12,%r9
	orq     %r9,%r8
	movq    %r8,408(%rdi)
	movq    %r8,400(%rdi)
	movq    %r8,392(%rdi)
	movq    %r8,384(%rdi)

	movq    %rcx,%r8
	andq    pmask5(%rip),%r8
	shrq    $14,%r8
	movq    %r8,440(%rdi)
	movq    %r8,432(%rdi)
	movq    %r8,424(%rdi)
	movq    %r8,416(%rdi)

	movq    %rcx,%r8
	andq    pmask6(%rip),%r8
	shrq    $40,%r8
	movq    %r8,472(%rdi)
	movq    %r8,464(%rdi)
	movq    %r8,456(%rdi)
	movq    %r8,448(%rdi)

	vpmuludq  352(%rdi),%ymm12,%ymm0
	vpmuludq  384(%rdi),%ymm12,%ymm1
	vpmuludq  416(%rdi),%ymm12,%ymm2
	vpmuludq  448(%rdi),%ymm12,%ymm3	

	vmovdqa   %ymm0,928(%rdi)
	vmovdqa   %ymm1,960(%rdi)
	vmovdqa   %ymm2,992(%rdi)
	vmovdqa   %ymm3,1024(%rdi)
	
	cmpq	$16,%rbp
	jl 	.L3
	
	movq    64(%rsp),%rdx

	mulx    80(%rsp),%r8,%r9
	mulx    88(%rsp),%rcx,%r10
	addq    %rcx,%r9
	adcq    $0,%r10

	xorq    %r11,%r11
	movq    72(%rsp),%rdx

	mulx    80(%rsp),%rcx,%rax
	adcx    %rcx,%r9
	adox    %rax,%r10

	mulx    88(%rsp),%rcx,%rax
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

	movq    %r8,%rax
	andq    pmask1(%rip),%r8
	movq    %r8,504(%rdi)
	movq    %r8,496(%rdi)
	movq    %r8,488(%rdi)
	movq    %r8,480(%rdi)

	movq    %rax,%r8
	andq    pmask2(%rip),%r8
	shrq    $26,%r8
	movq    %r8,536(%rdi)
	movq    %r8,528(%rdi)
	movq    %r8,520(%rdi)
	movq    %r8,512(%rdi)

	movq    %rax,%r8
	andq    pmask3(%rip),%r8
	shrq    $52,%r8
	movq    %r9,%rcx
	andq    pmask4(%rip),%r9
	shlq    $12,%r9
	orq     %r9,%r8
	movq    %r8,568(%rdi)
	movq    %r8,560(%rdi)
	movq    %r8,552(%rdi)
	movq    %r8,544(%rdi)

	movq    %rcx,%r8
	andq    pmask5(%rip),%r8
	shrq    $14,%r8
	movq    %r8,600(%rdi)
	movq    %r8,592(%rdi)
	movq    %r8,584(%rdi)
	movq    %r8,576(%rdi)

	movq    %rcx,%r8
	andq    pmask6(%rip),%r8
	shrq    $40,%r8
	movq    %r8,632(%rdi)
	movq    %r8,624(%rdi)
	movq    %r8,616(%rdi)
	movq    %r8,608(%rdi)
	
	vpmuludq  512(%rdi),%ymm12,%ymm0
	vpmuludq  544(%rdi),%ymm12,%ymm1
	vpmuludq  576(%rdi),%ymm12,%ymm2
	vpmuludq  608(%rdi),%ymm12,%ymm3	

	vmovdqa   %ymm0,1056(%rdi)
	vmovdqa   %ymm1,1088(%rdi)
	vmovdqa   %ymm2,1120(%rdi)
	vmovdqa   %ymm3,1152(%rdi)
	
	cmpq	$20,%rbp
	jl 	.L3
	
	movq	80(%rsp),%rax
	movq	88(%rsp),%rcx
	
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
	
	movq    %rax,%r8
	andq    pmask1(%rip),%r8
	movq    %r8,664(%rdi)
	movq    %r8,656(%rdi)
	movq    %r8,648(%rdi)
	movq    %r8,640(%rdi)

	movq    %rax,%r8
	andq    pmask2(%rip),%r8
	shrq    $26,%r8
	movq    %r8,696(%rdi)
	movq    %r8,688(%rdi)
	movq    %r8,680(%rdi)
	movq    %r8,672(%rdi)

	movq    %rax,%r8
	andq    pmask3(%rip),%r8
	shrq    $52,%r8
	movq    %rcx,%r9
	andq    pmask4(%rip),%r9
	shlq    $12,%r9
	orq     %r9,%r8
	movq    %r8,728(%rdi)
	movq    %r8,720(%rdi)
	movq    %r8,712(%rdi)
	movq    %r8,704(%rdi)

	movq    %rcx,%r8
	andq    pmask5(%rip),%r8
	shrq    $14,%r8
	movq    %r8,760(%rdi)
	movq    %r8,752(%rdi)
	movq    %r8,744(%rdi)
	movq    %r8,736(%rdi)

	movq    %rcx,%r8
	andq    pmask6(%rip),%r8
	shrq    $40,%r8
	movq    %r8,792(%rdi)
	movq    %r8,784(%rdi)
	movq    %r8,776(%rdi)
	movq    %r8,768(%rdi)
	
	vpmuludq  672(%rdi),%ymm12,%ymm0
	vpmuludq  704(%rdi),%ymm12,%ymm1
	vpmuludq  736(%rdi),%ymm12,%ymm2
	vpmuludq  768(%rdi),%ymm12,%ymm3	

	vmovdqa   %ymm0,1184(%rdi)
	vmovdqa   %ymm1,1216(%rdi)
	vmovdqa   %ymm2,1248(%rdi)
	vmovdqa   %ymm3,1280(%rdi)			

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
