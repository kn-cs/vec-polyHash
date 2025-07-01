/* assembly to compute the key powers */

	.p2align 5
	.globl poly1305_keypowers
	
poly1305_keypowers:

	movq    %rsp,%r11
	andq 	$-32,%rsp
	subq 	$128,%rsp

	movq 	%r11,0(%rsp)
	movq 	%r12,8(%rsp)
	movq 	%r13,16(%rsp)
	movq 	%r14,24(%rsp)
	movq 	%r15,32(%rsp)
	movq 	%rbx,40(%rsp)
	movq 	%rbp,48(%rsp)
	
	movq	%rdx,%rcx

	movq    0(%rsi),%r14
	movq    8(%rsi),%r15	

	movq    %r14,1312(%rdi)
	movq    %r15,1320(%rdi)
	
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

	movq    %r8,1328(%rdi)
	movq    %r9,1336(%rdi)
	movq    %r10,1344(%rdi)
	
	cmpq	$2,%rcx
	je	.L3
	
	cmpq	$3,%rcx
	je	.L2

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
	movq    1312(%rdi),%rdx    
	xorq    %r12,%r12

	mulx    1328(%rdi),%r8,%r9
	mulx    1336(%rdi),%rbx,%r10
	adcx    %rbx,%r9     

	mulx    1344(%rdi),%rbx,%r11
	adcx    %rbx,%r10    
	adcx    %r12,%r11

	xorq    %r13,%r13
	movq    1320(%rdi),%rdx
	   
	mulx    1328(%rdi),%rbx,%rbp
	adcx    %rbx,%r9
	adox    %rbp,%r10
	    
	mulx    1336(%rdi),%rbx,%rbp
	adcx    %rbx,%r10
	adox    %rbp,%r11
	    
	mulx    1344(%rdi),%rbx,%rbp
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

	movq    %r8,1352(%rdi)
	movq    %r9,1360(%rdi)
	movq    %r10,1368(%rdi)
	
	cmpq	$3,%rcx
	je	.L3

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

	movq    1312(%rdi),%rdx    
	xorq    %r12,%r12

	mulx    1352(%rdi),%r8,%r9
	mulx    1360(%rdi),%rbx,%r10
	adcx    %rbx,%r9     

	mulx    1368(%rdi),%rbx,%r11
	adcx    %rbx,%r10    
	adcx    %r12,%r11

	xorq    %r13,%r13
	movq    1320(%rdi),%rdx
	   
	mulx    1352(%rdi),%rbx,%rbp
	adcx    %rbx,%r9
	adox    %rbp,%r10
	    
	mulx    1360(%rdi),%rbx,%rbp
	adcx    %rbx,%r10
	adox    %rbp,%r11
	    
	mulx    1368(%rdi),%rbx,%rbp
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

	movq    %r8,64(%rsp)
	movq    %r9,72(%rsp)
	movq    %r10,80(%rsp)

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

	vpmuludq  192(%rdi),%ymm12,%ymm0
	vpmuludq  224(%rdi),%ymm12,%ymm1
	vpmuludq  256(%rdi),%ymm12,%ymm2
	vpmuludq  288(%rdi),%ymm12,%ymm3	

	vmovdqa   %ymm0,800(%rdi)
	vmovdqa   %ymm1,832(%rdi)
	vmovdqa   %ymm2,864(%rdi)
	vmovdqa   %ymm3,896(%rdi)	
	
	cmpq	$12,%rcx
	jl 	.L3	
	
	xorq    %r12,%r12
	movq    64(%rsp),%rdx
	    
	mulx    72(%rsp),%r9,%r10

	mulx    80(%rsp),%rbx,%r11
	adcx    %rbx,%r10
	adcx    %r12,%r11
	    
	movq    72(%rsp),%rdx
	xorq    %r13,%r13
	    
	mulx    80(%rsp),%rbx,%rdx
	adcx    %rbx,%r11
	adox    %rdx,%r12
	adcx    %r13,%r12
	    
	shld    $1,%r11,%r12
	shld    $1,%r10,%r11
	shld    $1,%r9,%r10
	addq    %r9,%r9
	     
	xorq    %rdx,%rdx
	movq    64(%rsp),%rdx
	mulx    %rdx,%r8,%rdx
	adcx    %rdx,%r9

	movq    72(%rsp),%rdx
	mulx    %rdx,%rbx,%rdx
	adcx    %rbx,%r10
	adcx    %rdx,%r11

	movq    80(%rsp),%rdx
	mulx    %rdx,%rbx,%rdx
	adcx    %rbx,%r12

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

	movq    %r8,88(%rsp)
	movq    %r9,96(%rsp)
	movq    %r10,104(%rsp)

	movq    %r8,%r11
	andq    pmask1(%rip),%r11
	movq    %r11,344(%rdi)
	movq    %r11,336(%rdi)
	movq    %r11,328(%rdi)
	movq    %r11,320(%rdi)

	movq    %r8,%r11
	andq    pmask2(%rip),%r11
	shrq    $26,%r11
	movq    %r11,376(%rdi)
	movq    %r11,368(%rdi)
	movq    %r11,360(%rdi)
	movq    %r11,352(%rdi)

	andq    pmask3(%rip),%r8
	shrq    $52,%r8
	movq    %r9,%r12
	andq    pmask4(%rip),%r12
	shlq    $12,%r12
	orq     %r8,%r12
	movq    %r12,408(%rdi)
	movq    %r12,400(%rdi)
	movq    %r12,392(%rdi)
	movq    %r12,384(%rdi)

	movq    %r9,%r11
	andq    pmask5(%rip),%r11
	shrq    $14,%r11
	movq    %r11,440(%rdi)
	movq    %r11,432(%rdi)
	movq    %r11,424(%rdi)
	movq    %r11,416(%rdi)

	andq    pmask6(%rip),%r9
	shrq    $40,%r9
	movq    %r10,%r12
	andq    pmask7(%rip),%r12
	shlq    $24,%r12
	orq     %r9,%r12
	movq    %r12,472(%rdi)
	movq    %r12,464(%rdi)
	movq    %r12,456(%rdi)
	movq    %r12,448(%rdi)

	vpmuludq  352(%rdi),%ymm12,%ymm0
	vpmuludq  384(%rdi),%ymm12,%ymm1
	vpmuludq  416(%rdi),%ymm12,%ymm2
	vpmuludq  448(%rdi),%ymm12,%ymm3	

	vmovdqa   %ymm0,928(%rdi)
	vmovdqa   %ymm1,960(%rdi)
	vmovdqa   %ymm2,992(%rdi)
	vmovdqa   %ymm3,1024(%rdi)
	
	cmpq	$16,%rcx
	jl 	.L3
	
	movq    64(%rsp),%rdx    
	xorq    %r12,%r12

	mulx    88(%rsp),%r8,%r9
	mulx    96(%rsp),%rbx,%r10
	adcx    %rbx,%r9     

	mulx    104(%rsp),%rbx,%r11
	adcx    %rbx,%r10    
	adcx    %r12,%r11

	xorq    %r13,%r13

	movq    72(%rsp),%rdx
	   
	mulx    88(%rsp),%rbx,%rbp
	adcx    %rbx,%r9
	adox    %rbp,%r10
	    
	mulx    96(%rsp),%rbx,%rbp
	adcx    %rbx,%r10
	adox    %rbp,%r11
	    
	mulx    104(%rsp),%rbx,%rbp
	adcx    %rbx,%r11
	adox    %rbp,%r12
	adcx    %r13,%r12
	    
	xorq    %r14,%r14

	movq    80(%rsp),%rdx
	    
	mulx    88(%rsp),%rbx,%rbp
	adcx    %rbx,%r10
	adox    %rbp,%r11
	    
	mulx    96(%rsp),%rbx,%rbp
	adcx    %rbx,%r11
	adox    %rbp,%r12
	    
	mulx    104(%rsp),%rbx,%rbp
	adcx    %rbx,%r12

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

	movq    %r8,%r11
	andq    pmask1(%rip),%r11
	movq    %r11,504(%rdi)
	movq    %r11,496(%rdi)
	movq    %r11,488(%rdi)
	movq    %r11,480(%rdi)

	movq    %r8,%r11
	andq    pmask2(%rip),%r11
	shrq    $26,%r11
	movq    %r11,536(%rdi)
	movq    %r11,528(%rdi)
	movq    %r11,520(%rdi)
	movq    %r11,512(%rdi)

	andq    pmask3(%rip),%r8
	shrq    $52,%r8
	movq    %r9,%r12
	andq    pmask4(%rip),%r12
	shlq    $12,%r12
	orq     %r8,%r12
	movq    %r12,568(%rdi)
	movq    %r12,560(%rdi)
	movq    %r12,552(%rdi)
	movq    %r12,544(%rdi)

	movq    %r9,%r11
	andq    pmask5(%rip),%r11
	shrq    $14,%r11
	movq    %r11,600(%rdi)
	movq    %r11,592(%rdi)
	movq    %r11,584(%rdi)
	movq    %r11,576(%rdi)

	andq    pmask6(%rip),%r9
	shrq    $40,%r9
	movq    %r10,%r12
	andq    pmask7(%rip),%r12
	shlq    $24,%r12
	orq     %r9,%r12
	movq    %r12,632(%rdi)
	movq    %r12,624(%rdi)
	movq    %r12,616(%rdi)
	movq    %r12,608(%rdi)
	
	vpmuludq  512(%rdi),%ymm12,%ymm0
	vpmuludq  544(%rdi),%ymm12,%ymm1
	vpmuludq  576(%rdi),%ymm12,%ymm2
	vpmuludq  608(%rdi),%ymm12,%ymm3	

	vmovdqa   %ymm0,1056(%rdi)
	vmovdqa   %ymm1,1088(%rdi)
	vmovdqa   %ymm2,1120(%rdi)
	vmovdqa   %ymm3,1152(%rdi)
	
	cmpq	$20,%rcx
	jl 	.L3
	
	xorq    %r12,%r12
	movq    88(%rsp),%rdx
	    
	mulx    96(%rsp),%r9,%r10

	mulx    104(%rsp),%rbx,%r11
	adcx    %rbx,%r10
	adcx    %r12,%r11
	    
	movq    96(%rsp),%rdx
	xorq    %r13,%r13
	    
	mulx    104(%rsp),%rbx,%rdx
	adcx    %rbx,%r11
	adox    %rdx,%r12
	adcx    %r13,%r12
	    
	shld    $1,%r11,%r12
	shld    $1,%r10,%r11
	shld    $1,%r9,%r10
	addq    %r9,%r9
	     
	xorq    %rdx,%rdx
	movq    88(%rsp),%rdx
	mulx    %rdx,%r8,%rdx
	adcx    %rdx,%r9

	movq    96(%rsp),%rdx
	mulx    %rdx,%rbx,%rdx
	adcx    %rbx,%r10
	adcx    %rdx,%r11

	movq    104(%rsp),%rdx
	mulx    %rdx,%rbx,%rdx
	adcx    %rbx,%r12

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

	movq    %r8,%r11
	andq    pmask1(%rip),%r11
	movq    %r11,664(%rdi)
	movq    %r11,656(%rdi)
	movq    %r11,648(%rdi)
	movq    %r11,640(%rdi)

	movq    %r8,%r11
	andq    pmask2(%rip),%r11
	shrq    $26,%r11
	movq    %r11,696(%rdi)
	movq    %r11,688(%rdi)
	movq    %r11,680(%rdi)
	movq    %r11,672(%rdi)

	andq    pmask3(%rip),%r8
	shrq    $52,%r8
	movq    %r9,%r12
	andq    pmask4(%rip),%r12
	shlq    $12,%r12
	orq     %r8,%r12
	movq    %r12,728(%rdi)
	movq    %r12,720(%rdi)
	movq    %r12,712(%rdi)
	movq    %r12,704(%rdi)

	movq    %r9,%r11
	andq    pmask5(%rip),%r11
	shrq    $14,%r11
	movq    %r11,760(%rdi)
	movq    %r11,752(%rdi)
	movq    %r11,744(%rdi)
	movq    %r11,736(%rdi)

	andq    pmask6(%rip),%r9
	shrq    $40,%r9
	movq    %r10,%r12
	andq    pmask7(%rip),%r12
	shlq    $24,%r12
	orq     %r9,%r12
	movq    %r12,792(%rdi)
	movq    %r12,784(%rdi)
	movq    %r12,776(%rdi)
	movq    %r12,768(%rdi)
	
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
