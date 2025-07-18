/* assembly to compute the key powers */

	.p2align 5
	.globl poly1305_keypowers
	
poly1305_keypowers:

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
	
	movq	%rdx,%rcx

	/* load 2-limb key */
	movq    0(%rsi),%r14
	movq    8(%rsi),%r15

	/* pack and store 5-limb r */
	movq    %r14,448(%rdi)
	movq    %r15,456(%rdi)
	
	cmpq	$1,%rcx
	je	.L3
	
	cmpq	$2,%rcx
	je	.L1

	movq    %r14,%r8
	andq    pmask1(%rip),%r8
	movq    %r8,24(%rdi)

	movq    %r14,%r8
	andq    pmask2(%rip),%r8
	shrq    $26,%r8
	movq    %r8,56(%rdi)

	movq    %r14,%r8
	andq    pmask3(%rip),%r8
	shrq    $52,%r8
	movq    %r15,%r9
	andq    pmask4(%rip),%r9
	shlq    $12,%r9
	orq     %r9,%r8
	movq    %r8,88(%rdi)

	movq    %r15,%r8
	andq    pmask5(%rip),%r8
	shrq    $14,%r8
	movq    %r8,120(%rdi)

	movq    %r15,%r8
	andq    pmask6(%rip),%r8
	shrq    $40,%r8
	movq    %r8,152(%rdi)
	
.L1:
	/* compute r^2 */
	xorq    %r11,%r11
	movq    %r14,%rdx
	    
	mulx    %r15,%r9,%r10
	  
	shld    $1,%r10,%r11
	shld    $1,%r9,%r10
	shlq    $1,%r9
	     
	xorq    %rdx,%rdx
	movq    %r14,%rdx
	mulx    %rdx,%r8,%rdx
	adcx    %rdx,%r9

	movq    %r15,%rdx
	mulx    %rdx,%rbx,%rdx
	adcx    %rbx,%r10
	adcx    %rdx,%r11

	movq    %r10,%rbx

	andq    mask2(%rip),%r10
	andq    mask2c(%rip),%rbx

	addq    %rbx,%r8
	adcq    %r11,%r9
	adcq    $0,%r10

	shrd    $2,%r11,%rbx
	shrq    $2,%r11

	addq    %rbx,%r8
	adcq    %r11,%r9
	adcq    $0,%r10

	movq    %r10,%r11
	andq    mask2(%rip),%r10

	shrq    $2,%r11

	imul    $5,%r11,%r11
	addq    %r11,%r8
	adcq    $0,%r9
	adcq    $0,%r10

	/* store 3-limb r^2 */
	movq    %r8,464(%rdi)
	movq    %r9,472(%rdi)
	movq    %r10,480(%rdi)
	
	cmpq	$2,%rcx
	je	.L3
	
	cmpq	$3,%rcx
	je	.L2		

	/* pack and store 5-limb r^2 */
	movq    %r8,%r11
	andq    pmask1(%rip),%r11
	movq    %r11,16(%rdi)

	movq    %r8,%r11
	andq    pmask2(%rip),%r11
	shrq    $26,%r11
	movq    %r11,48(%rdi)

	andq    pmask3(%rip),%r8
	shrq    $52,%r8
	movq    %r9,%r12
	andq    pmask4(%rip),%r12
	shlq    $12,%r12
	orq     %r8,%r12
	movq    %r12,80(%rdi)

	movq    %r9,%r11
	andq    pmask5(%rip),%r11
	shrq    $14,%r11
	movq    %r11,112(%rdi)

	andq    pmask6(%rip),%r9
	shrq    $40,%r9
	movq    %r10,%r12
	andq    pmask7(%rip),%r12
	shlq    $24,%r12
	orq     %r9,%r12
	movq    %r12,144(%rdi)
	
.L2:
	/* compute r^3 */
	movq    448(%rdi),%rdx    
	xorq    %r12,%r12

	mulx    464(%rdi),%r8,%r9
	mulx    472(%rdi),%rbx,%r10
	adcx    %rbx,%r9     

	mulx    480(%rdi),%rbx,%r11
	adcx    %rbx,%r10    
	adcx    %r12,%r11

	xorq    %r13,%r13
	movq    456(%rdi),%rdx
	   
	mulx    464(%rdi),%rbx,%rbp
	adcx    %rbx,%r9
	adox    %rbp,%r10
	    
	mulx    472(%rdi),%rbx,%rbp
	adcx    %rbx,%r10
	adox    %rbp,%r11
	    
	mulx    480(%rdi),%rbx,%rbp
	adcx    %rbx,%r11
	adox    %rbp,%r12
	adcx    %r13,%r12
	    
	movq    %r10,%rbx

	andq    mask2(%rip),%r10
	andq    mask2c(%rip),%rbx

	addq    %rbx,%r8
	adcq    %r11,%r9
	adcq    %r12,%r10

	shrd    $2,%r11,%rbx
	shrd    $2,%r12,%r11
	shrq    $2,%r12

	addq    %rbx,%r8
	adcq    %r11,%r9
	adcq    %r12,%r10

	movq    %r10,%r11
	andq    mask2(%rip),%r10

	shrq    $2,%r11

	imul    $5,%r11,%r11
	addq    %r11,%r8
	adcq    $0,%r9
	adcq    $0,%r10

	/* store 3-limb r^3 */
	movq    %r8,488(%rdi)
	movq    %r9,496(%rdi)
	movq    %r10,504(%rdi)
	
	cmpq	$3,%rcx
	je	.L3

	/* pack and store 5-limb r^3 */
	movq    %r8,%r11
	andq    pmask1(%rip),%r11
	movq    %r11,8(%rdi)

	movq    %r8,%r11
	andq    pmask2(%rip),%r11
	shrq    $26,%r11
	movq    %r11,40(%rdi)

	andq    pmask3(%rip),%r8
	shrq    $52,%r8
	movq    %r9,%r12
	andq    pmask4(%rip),%r12
	shlq    $12,%r12
	orq     %r8,%r12
	movq    %r12,72(%rdi)

	movq    %r9,%r11
	andq    pmask5(%rip),%r11
	shrq    $14,%r11
	movq    %r11,104(%rdi)

	andq    pmask6(%rip),%r9
	shrq    $40,%r9
	movq    %r10,%r12
	andq    pmask7(%rip),%r12
	shlq    $24,%r12
	orq     %r9,%r12
	movq    %r12,136(%rdi)

	/* compute r^4 */
	movq    448(%rdi),%rdx    
	xorq    %r12,%r12

	mulx    488(%rdi),%r8,%r9
	mulx    496(%rdi),%rbx,%r10
	adcx    %rbx,%r9     

	mulx    504(%rdi),%rbx,%r11
	adcx    %rbx,%r10    
	adcx    %r12,%r11

	xorq    %r13,%r13
	movq    456(%rdi),%rdx
	   
	mulx    488(%rdi),%rbx,%rbp
	adcx    %rbx,%r9
	adox    %rbp,%r10
	    
	mulx    496(%rdi),%rbx,%rbp
	adcx    %rbx,%r10
	adox    %rbp,%r11
	    
	mulx    504(%rdi),%rbx,%rbp
	adcx    %rbx,%r11
	adox    %rbp,%r12
	adcx    %r13,%r12
	    
	movq    %r10,%rbx

	andq    mask2(%rip),%r10
	andq    mask2c(%rip),%rbx

	addq    %rbx,%r8
	adcq    %r11,%r9
	adcq    %r12,%r10

	shrd    $2,%r11,%rbx
	shrd    $2,%r12,%r11
	shrq    $2,%r12

	addq    %rbx,%r8
	adcq    %r11,%r9
	adcq    %r12,%r10

	movq    %r10,%r11
	andq    mask2(%rip),%r10

	shrq    $2,%r11

	imul    $5,%r11,%r11
	addq    %r11,%r8
	adcq    $0,%r9
	adcq    $0,%r10

	/* pack and store 5-limb r^4 */
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
	movq    %r10,%r15
	andq    pmask7(%rip),%r15
	shlq    $24,%r15
	orq     %r9,%r15
	movq    %r15,128(%rdi)
	
	cmpq	$8,%rcx
	jl 	.L3
		
	/* store 5-limb r^4 */
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

	movq    %r15,312(%rdi)
	movq    %r15,304(%rdi)
	movq    %r15,296(%rdi)
	movq    %r15,288(%rdi)	

	vmovdqa   vec5(%rip),%ymm12

	/* pre-compute and store 5r^4 */	
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
