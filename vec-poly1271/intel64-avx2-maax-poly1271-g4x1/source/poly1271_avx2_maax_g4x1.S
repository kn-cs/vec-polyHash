/* assembly to compute poly1271 using a delayed reduction  
   over a group of 4x(1+1) = 8 field elements */

	.p2align 5
	.globl poly1271_avx2_maax_g4x1
	
poly1271_avx2_maax_g4x1:

	movq    %rsp,%r11
	andq 	$-32,%rsp
	subq 	$256,%rsp

	movq 	%r11,0(%rsp)
	movq 	%r12,8(%rsp)
	movq 	%r13,16(%rsp)
	movq 	%r14,24(%rsp)
	movq 	%r15,32(%rsp)
	movq 	%rbx,40(%rsp)
	movq 	%rbp,48(%rsp)
	
	movq 	%rdx,56(%rsp)
	movq 	%rdi,224(%rsp)
	movq 	%r8,232(%rsp)

	movq	$0,%r8
	movq	$0,%r9
	movq	%rdx,%rdi

	cmpq	$3,%rcx
	je	.L9

	cmpq	$2,%rcx
	je	.L11
	
	cmpq	$1,%rcx
	je	.L13

	vmovdqu   0(%rsi),%ymm0
	vmovdqu   30(%rsi),%ymm1
	
	vpand     vecmask240(%rip),%ymm0,%ymm2
	vpsllq    $8,%ymm2,%ymm2
	vpermq	  $148,%ymm0,%ymm3
	vpsrlvq   sh56(%rip),%ymm3,%ymm3
	vpand     vecmask56q1(%rip),%ymm3,%ymm3
	vpor	  %ymm3,%ymm2,%ymm0

	vpand     vecmask240(%rip),%ymm1,%ymm2
	vpsllq    $8,%ymm2,%ymm2
	vpermq	  $148,%ymm1,%ymm3
	vpsrlvq   sh56(%rip),%ymm3,%ymm3
	vpand     vecmask56q1(%rip),%ymm3,%ymm3
	vpor	  %ymm3,%ymm2,%ymm1
	
	vpunpcklqdq	%ymm1,%ymm0,%ymm2
	vpunpckhqdq	%ymm1,%ymm0,%ymm3

	vpermq	  $216,%ymm2,%ymm2
	vpermq	  $216,%ymm3,%ymm3

	vpand     vecmask26(%rip),%ymm2,%ymm6

	vpsrlq    $26,%ymm2,%ymm4
	vpand     vecmask26(%rip),%ymm4,%ymm7

	vpsrlq    $52,%ymm2,%ymm4
	vpsllq    $12,%ymm3,%ymm5
	vpor      %ymm4,%ymm5,%ymm4
	vpand     vecmask26(%rip),%ymm4,%ymm8

	vpsrlq    $14,%ymm3,%ymm4
	vpand     vecmask26(%rip),%ymm4,%ymm9

	vpsrlq    $40,%ymm3,%ymm10
	
	cmpq      $4,%rcx
	je        .L0

	vpor      vecpad(%rip),%ymm10,%ymm10
	jmp       .L2

.L0:
	cmpq      $0,232(%rsp)
	je        .L1

	vpor      vecpad(%rip),%ymm10,%ymm10
	jmp	  .L2
.L1:	
	vpor      vecpadend(%rip),%ymm10,%ymm10	

.L2:
	vmovdqa   160(%rdx),%ymm11	
	vmovdqa   192(%rdx),%ymm12
	vmovdqa   224(%rdx),%ymm13
	vmovdqa   256(%rdx),%ymm14
	vmovdqa   288(%rdx),%ymm15

	addq      $60,%rsi
	subq      $4,%rcx
	cmpq      $4,%rcx
	je        .L4
	jl        .L7

.L3:	
	vpmuludq  %ymm11,%ymm6,%ymm0

	vpmuludq  %ymm11,%ymm7,%ymm1
	vpmuludq  %ymm12,%ymm6,%ymm5
	vpaddq    %ymm5,%ymm1,%ymm1

	vpmuludq  %ymm11,%ymm8,%ymm2
	vpmuludq  %ymm12,%ymm7,%ymm5
	vpaddq    %ymm5,%ymm2,%ymm2
	vpmuludq  %ymm13,%ymm6,%ymm5
	vpaddq    %ymm5,%ymm2,%ymm2

	vpmuludq  %ymm11,%ymm9,%ymm3
	vpmuludq  %ymm12,%ymm8,%ymm5
	vpaddq    %ymm5,%ymm3,%ymm3
	vpmuludq  %ymm13,%ymm7,%ymm5
	vpaddq    %ymm5,%ymm3,%ymm3
	vpmuludq  %ymm14,%ymm6,%ymm5
	vpaddq    %ymm5,%ymm3,%ymm3

	vpmuludq  %ymm11,%ymm10,%ymm4
	vpmuludq  %ymm12,%ymm9,%ymm5
	vpaddq    %ymm5,%ymm4,%ymm4
	vpmuludq  %ymm13,%ymm8,%ymm5
	vpaddq    %ymm5,%ymm4,%ymm4
	vpmuludq  %ymm14,%ymm7,%ymm5
	vpaddq    %ymm5,%ymm4,%ymm4
	vpmuludq  %ymm15,%ymm6,%ymm5
	vpaddq    %ymm5,%ymm4,%ymm4

	vmovdqa   320(%rdx),%ymm11
	vmovdqa   352(%rdx),%ymm12
	vmovdqa   384(%rdx),%ymm13
	vmovdqa   416(%rdx),%ymm14

	vpmuludq  %ymm11,%ymm10,%ymm5
	vpaddq    %ymm5,%ymm0,%ymm0

	vpmuludq  %ymm12,%ymm9,%ymm5
	vpaddq    %ymm5,%ymm0,%ymm0
	vpmuludq  %ymm12,%ymm10,%ymm5
	vpaddq    %ymm5,%ymm1,%ymm1

	vpmuludq  %ymm13,%ymm8,%ymm5
	vpaddq    %ymm5,%ymm0,%ymm0
	vpmuludq  %ymm13,%ymm9,%ymm5
	vpaddq    %ymm5,%ymm1,%ymm1
	vpmuludq  %ymm13,%ymm10,%ymm5
	vpaddq    %ymm5,%ymm2,%ymm2

	vpmuludq  %ymm14,%ymm7,%ymm5
	vpaddq    %ymm5,%ymm0,%ymm0
	vpmuludq  %ymm14,%ymm8,%ymm5
	vpaddq    %ymm5,%ymm1,%ymm1
	vpmuludq  %ymm14,%ymm9,%ymm5
	vpaddq    %ymm5,%ymm2,%ymm2
	vpmuludq  %ymm14,%ymm10,%ymm5
	vpaddq    %ymm5,%ymm3,%ymm3
	
	vmovdqu   0(%rsi),%ymm11
	vmovdqu   30(%rsi),%ymm12
	
	vpand     vecmask240(%rip),%ymm11,%ymm14
	vpsllq    $8,%ymm14,%ymm14
	vpermq	  $148,%ymm11,%ymm13
	vpsrlvq   sh56(%rip),%ymm13,%ymm13
	vpand     vecmask56q1(%rip),%ymm13,%ymm13
	vpor	  %ymm13,%ymm14,%ymm11

	vpand     vecmask240(%rip),%ymm12,%ymm14
	vpsllq    $8,%ymm14,%ymm14
	vpermq	  $148,%ymm12,%ymm13
	vpsrlvq   sh56(%rip),%ymm13,%ymm13
	vpand     vecmask56q1(%rip),%ymm13,%ymm13
	vpor	  %ymm13,%ymm14,%ymm12	

	vpunpcklqdq	%ymm12,%ymm11,%ymm13
	vpunpckhqdq	%ymm12,%ymm11,%ymm14

	vpermq	  $216,%ymm13,%ymm13
	vpermq	  $216,%ymm14,%ymm14

	vpand     vecmask26(%rip),%ymm13,%ymm6

	vpsrlq    $26,%ymm13,%ymm11
	vpand     vecmask26(%rip),%ymm11,%ymm7

	vpsrlq    $52,%ymm13,%ymm11
	vpsllq    $12,%ymm14,%ymm12
	vpor      %ymm11,%ymm12,%ymm11
	vpand     vecmask26(%rip),%ymm11,%ymm8

	vpsrlq    $14,%ymm14,%ymm11
	vpand     vecmask26(%rip),%ymm11,%ymm9

	vpsrlq    $40,%ymm14,%ymm11
	vpor      vecpad(%rip),%ymm11,%ymm10

	vpaddq    %ymm6,%ymm0,%ymm0
	vpaddq    %ymm7,%ymm1,%ymm1
	vpaddq    %ymm8,%ymm2,%ymm2
	vpaddq    %ymm9,%ymm3,%ymm3
	vpaddq    %ymm10,%ymm4,%ymm4

	vpsrlq    $26,%ymm0,%ymm5
	vpaddq    %ymm5,%ymm1,%ymm1
	vpand     vecmask26(%rip),%ymm0,%ymm0

	vpsrlq    $26,%ymm1,%ymm5
	vpaddq    %ymm5,%ymm2,%ymm2
	vpand     vecmask26(%rip),%ymm1,%ymm1

	vpsrlq    $26,%ymm2,%ymm5
	vpaddq    %ymm5,%ymm3,%ymm3
	vpand     vecmask26(%rip),%ymm2,%ymm8

	vpsrlq    $26,%ymm3,%ymm5
	vpaddq    %ymm5,%ymm4,%ymm4
	vpand     vecmask26(%rip),%ymm3,%ymm9

	vpsrlq    $23,%ymm4,%ymm5
	vpaddq    %ymm5,%ymm0,%ymm0
	vpand     vecmask23(%rip),%ymm4,%ymm10

	vpsrlq    $26,%ymm0,%ymm5
	vpaddq    %ymm5,%ymm1,%ymm7
	vpand     vecmask26(%rip),%ymm0,%ymm6
	
	vmovdqa   160(%rdx),%ymm11
	vmovdqa   192(%rdx),%ymm12
	vmovdqa   224(%rdx),%ymm13
	vmovdqa   256(%rdx),%ymm14
	
	addq    $60,%rsi
	subq    $4,%rcx
	cmpq    $4,%rcx
	jg      .L3
	jl	.L7
	
.L4:	
	vpmuludq  %ymm11,%ymm6,%ymm0

	vpmuludq  %ymm11,%ymm7,%ymm1
	vpmuludq  %ymm12,%ymm6,%ymm5
	vpaddq    %ymm5,%ymm1,%ymm1

	vpmuludq  %ymm11,%ymm8,%ymm2
	vpmuludq  %ymm12,%ymm7,%ymm5
	vpaddq    %ymm5,%ymm2,%ymm2
	vpmuludq  %ymm13,%ymm6,%ymm5
	vpaddq    %ymm5,%ymm2,%ymm2

	vpmuludq  %ymm11,%ymm9,%ymm3
	vpmuludq  %ymm12,%ymm8,%ymm5
	vpaddq    %ymm5,%ymm3,%ymm3
	vpmuludq  %ymm13,%ymm7,%ymm5
	vpaddq    %ymm5,%ymm3,%ymm3
	vpmuludq  %ymm14,%ymm6,%ymm5
	vpaddq    %ymm5,%ymm3,%ymm3

	vpmuludq  %ymm11,%ymm10,%ymm4
	vpmuludq  %ymm12,%ymm9,%ymm5
	vpaddq    %ymm5,%ymm4,%ymm4
	vpmuludq  %ymm13,%ymm8,%ymm5
	vpaddq    %ymm5,%ymm4,%ymm4
	vpmuludq  %ymm14,%ymm7,%ymm5
	vpaddq    %ymm5,%ymm4,%ymm4
	vpmuludq  %ymm15,%ymm6,%ymm5
	vpaddq    %ymm5,%ymm4,%ymm4

	vmovdqa   320(%rdx),%ymm11
	vmovdqa   352(%rdx),%ymm12
	vmovdqa   384(%rdx),%ymm13
	vmovdqa   416(%rdx),%ymm14

	vpmuludq  %ymm11,%ymm10,%ymm5
	vpaddq    %ymm5,%ymm0,%ymm0

	vpmuludq  %ymm12,%ymm9,%ymm5
	vpaddq    %ymm5,%ymm0,%ymm0
	vpmuludq  %ymm12,%ymm10,%ymm5
	vpaddq    %ymm5,%ymm1,%ymm1

	vpmuludq  %ymm13,%ymm8,%ymm5
	vpaddq    %ymm5,%ymm0,%ymm0
	vpmuludq  %ymm13,%ymm9,%ymm5
	vpaddq    %ymm5,%ymm1,%ymm1
	vpmuludq  %ymm13,%ymm10,%ymm5
	vpaddq    %ymm5,%ymm2,%ymm2

	vpmuludq  %ymm14,%ymm7,%ymm5
	vpaddq    %ymm5,%ymm0,%ymm0
	vpmuludq  %ymm14,%ymm8,%ymm5
	vpaddq    %ymm5,%ymm1,%ymm1
	vpmuludq  %ymm14,%ymm9,%ymm5
	vpaddq    %ymm5,%ymm2,%ymm2
	vpmuludq  %ymm14,%ymm10,%ymm5
	vpaddq    %ymm5,%ymm3,%ymm3
	
	vmovdqu   0(%rsi),%ymm11
	vmovdqu   30(%rsi),%ymm12
	
	vpand     vecmask240(%rip),%ymm11,%ymm14
	vpsllq    $8,%ymm14,%ymm14
	vpermq	  $148,%ymm11,%ymm13
	vpsrlvq   sh56(%rip),%ymm13,%ymm13
	vpand     vecmask56q1(%rip),%ymm13,%ymm13
	vpor	  %ymm13,%ymm14,%ymm11

	vpand     vecmask240(%rip),%ymm12,%ymm14
	vpsllq    $8,%ymm14,%ymm14
	vpermq	  $148,%ymm12,%ymm13
	vpsrlvq   sh56(%rip),%ymm13,%ymm13
	vpand     vecmask56q1(%rip),%ymm13,%ymm13
	vpor	  %ymm13,%ymm14,%ymm12	

	vpunpcklqdq	%ymm12,%ymm11,%ymm13
	vpunpckhqdq	%ymm12,%ymm11,%ymm14

	vpermq	  $216,%ymm13,%ymm13
	vpermq	  $216,%ymm14,%ymm14

	vpand     vecmask26(%rip),%ymm13,%ymm6

	vpsrlq    $26,%ymm13,%ymm11
	vpand     vecmask26(%rip),%ymm11,%ymm7

	vpsrlq    $52,%ymm13,%ymm11
	vpsllq    $12,%ymm14,%ymm12
	vpor      %ymm11,%ymm12,%ymm11
	vpand     vecmask26(%rip),%ymm11,%ymm8

	vpsrlq    $14,%ymm14,%ymm11
	vpand     vecmask26(%rip),%ymm11,%ymm9

	vpsrlq    $40,%ymm14,%ymm10

	cmpq      $0,232(%rsp)
	je        .L5

	vpor      vecpad(%rip),%ymm10,%ymm10
	jmp	  .L6
	
.L5:
	vpor      vecpadend(%rip),%ymm10,%ymm10
	
.L6:
	vpaddq    %ymm6,%ymm0,%ymm0
	vpaddq    %ymm7,%ymm1,%ymm1
	vpaddq    %ymm8,%ymm2,%ymm2
	vpaddq    %ymm9,%ymm3,%ymm3
	vpaddq    %ymm10,%ymm4,%ymm4

	vpsrlq    $26,%ymm0,%ymm5
	vpaddq    %ymm5,%ymm1,%ymm1
	vpand     vecmask26(%rip),%ymm0,%ymm0

	vpsrlq    $26,%ymm1,%ymm5
	vpaddq    %ymm5,%ymm2,%ymm2
	vpand     vecmask26(%rip),%ymm1,%ymm1

	vpsrlq    $26,%ymm2,%ymm5
	vpaddq    %ymm5,%ymm3,%ymm3
	vpand     vecmask26(%rip),%ymm2,%ymm8

	vpsrlq    $26,%ymm3,%ymm5
	vpaddq    %ymm5,%ymm4,%ymm4
	vpand     vecmask26(%rip),%ymm3,%ymm9

	vpsrlq    $23,%ymm4,%ymm5
	vpaddq    %ymm5,%ymm0,%ymm0
	vpand     vecmask23(%rip),%ymm4,%ymm10

	vpsrlq    $26,%ymm0,%ymm5
	vpaddq    %ymm5,%ymm1,%ymm7
	vpand     vecmask26(%rip),%ymm0,%ymm6

	addq    $60,%rsi
	subq    $4,%rcx

.L7:
	vmovdqa   0(%rdx),%ymm11
	vmovdqa   32(%rdx),%ymm12
	vmovdqa   64(%rdx),%ymm13
	vmovdqa   96(%rdx),%ymm14
	vmovdqa   128(%rdx),%ymm15
	
	vpmuludq  %ymm11,%ymm6,%ymm0

	vpmuludq  %ymm11,%ymm7,%ymm1
	vpmuludq  %ymm12,%ymm6,%ymm5
	vpaddq    %ymm5,%ymm1,%ymm1

	vpmuludq  %ymm11,%ymm8,%ymm2
	vpmuludq  %ymm12,%ymm7,%ymm5
	vpaddq    %ymm5,%ymm2,%ymm2
	vpmuludq  %ymm13,%ymm6,%ymm5
	vpaddq    %ymm5,%ymm2,%ymm2

	vpmuludq  %ymm11,%ymm9,%ymm3
	vpmuludq  %ymm12,%ymm8,%ymm5
	vpaddq    %ymm5,%ymm3,%ymm3
	vpmuludq  %ymm13,%ymm7,%ymm5
	vpaddq    %ymm5,%ymm3,%ymm3
	vpmuludq  %ymm14,%ymm6,%ymm5
	vpaddq    %ymm5,%ymm3,%ymm3

	vpmuludq  %ymm11,%ymm10,%ymm4
	vpmuludq  %ymm12,%ymm9,%ymm5
	vpaddq    %ymm5,%ymm4,%ymm4
	vpmuludq  %ymm13,%ymm8,%ymm5
	vpaddq    %ymm5,%ymm4,%ymm4
	vpmuludq  %ymm14,%ymm7,%ymm5
	vpaddq    %ymm5,%ymm4,%ymm4
	vpmuludq  %ymm15,%ymm6,%ymm5
	vpaddq    %ymm5,%ymm4,%ymm4
	
	vpsllq    $3,%ymm12,%ymm5
	vpmuludq  %ymm10,%ymm5,%ymm5
	vpaddq    %ymm5,%ymm0,%ymm0

	vpsllq    $3,%ymm13,%ymm12
	vpmuludq  %ymm9,%ymm12,%ymm5
	vpaddq    %ymm5,%ymm0,%ymm0
	vpmuludq  %ymm10,%ymm12,%ymm5
	vpaddq    %ymm5,%ymm1,%ymm1

	vpsllq    $3,%ymm14,%ymm12
	vpmuludq  %ymm8,%ymm12,%ymm5
	vpaddq    %ymm5,%ymm0,%ymm0
	vpmuludq  %ymm9,%ymm12,%ymm5
	vpaddq    %ymm5,%ymm1,%ymm1
	vpmuludq  %ymm10,%ymm12,%ymm5
	vpaddq    %ymm5,%ymm2,%ymm2

	vpsllq    $3,%ymm15,%ymm12
	vpmuludq  %ymm7,%ymm12,%ymm5
	vpaddq    %ymm5,%ymm0,%ymm0
	vpmuludq  %ymm8,%ymm12,%ymm5
	vpaddq    %ymm5,%ymm1,%ymm1
	vpmuludq  %ymm9,%ymm12,%ymm5
	vpaddq    %ymm5,%ymm2,%ymm2
	vpmuludq  %ymm10,%ymm12,%ymm5
	vpaddq    %ymm5,%ymm3,%ymm3

	vmovdqa   %ymm0,64(%rsp)
	vmovdqa   %ymm1,96(%rsp)
	vmovdqa   %ymm2,128(%rsp)
	vmovdqa   %ymm3,160(%rsp)
	vmovdqa   %ymm4,192(%rsp)
	
.L8:
	movq    64(%rsp),%r8
	addq    72(%rsp),%r8
	addq    80(%rsp),%r8
	addq    88(%rsp),%r8

	movq    96(%rsp),%r9
	addq    104(%rsp),%r9
	addq    112(%rsp),%r9
	addq    120(%rsp),%r9

	movq    128(%rsp),%r10
	addq    136(%rsp),%r10
	addq    144(%rsp),%r10
	addq    152(%rsp),%r10

	movq    160(%rsp),%r11
	addq    168(%rsp),%r11
	addq    176(%rsp),%r11
	addq    184(%rsp),%r11

	movq    192(%rsp),%rax
	addq    200(%rsp),%rax
	addq    208(%rsp),%rax
	addq    216(%rsp),%rax
	
	movq    %r8,%r12
	shrq    $26,%r12
	addq    %r12,%r9
	andq	mask26(%rip),%r8

	movq    %r9,%r12
	shrq    $26,%r12
	addq    %r12,%r10
	andq	mask26(%rip),%r9

	movq    %r10,%r12
	shrq    $26,%r12
	addq    %r12,%r11
	andq	mask26(%rip),%r10

	movq    %r11,%r12
	shrq    $26,%r12
	addq    %r12,%rax
	andq	mask26(%rip),%r11

	movq    %rax,%r12
	shrq    $23,%r12
	addq    %r12,%r8
	andq	mask23(%rip),%rax

	movq    %r8,%r12
	shrq    $26,%r12
	addq    %r12,%r9
	andq	mask26(%rip),%r8

	movq    %r9,%r12
	shrq    $26,%r12
	addq    %r12,%r10
	andq	mask26(%rip),%r9

	movq    %r10,%r12
	shrq    $26,%r12
	addq    %r12,%r11
	andq	mask26(%rip),%r10

	movq    %r11,%r12
	shrq    $26,%r12
	addq    %r12,%rax
	andq	mask26(%rip),%r11

	movq    %rax,%r12
	shrq    $23,%r12
	addq    %r12,%r8
	andq	mask23(%rip),%rax

	movq    %r8,%r12
	shrq    $26,%r12
	addq    %r12,%r9
	andq	mask26(%rip),%r8
	
	shlq    $26,%r9
	orq     %r9,%r8
	movq    %r10,%rbx
	andq    pmask11(%rip),%rbx
	shlq    $52,%rbx
	orq     %rbx,%r8

	andq    pmask8(%rip),%r10
	shrq    $12,%r10
	shlq    $14,%r11
	orq     %r11,%r10
	movq    %rax,%r9
	andq    pmask9(%rip),%r9
	shlq    $40,%r9
	orq     %r10,%r9
	
	cmpq	$0,%rcx	
	je	.L16
	
	movq	56(%rsp),%rdi

	cmpq	$3,%rcx	
	je	.L9
	
	cmpq	$2,%rcx	
	je	.L11
	
	cmpq	$1,%rcx	
	je	.L13	
	
.L9:
	movq	8(%rsi),%rdx
	andq    mask56(%rip),%rdx	
	orq     c(%rip),%rdx
	addq	0(%rsi),%r8	
	adcq	%rdx,%r9
	
	xorq    %rdx,%rdx
	movq    %r8,%rdx

	mulx    480(%rdi),%r8,%r12
	mulx    488(%rdi),%rbx,%r13
	adcx    %rbx,%r12
	adcx    zero(%rip),%r13

	xorq    %r11,%r11
	movq    %r9,%rdx

	mulx    480(%rdi),%r9,%r10
	adcx    %r12,%r9
	adox    %r13,%r10

	mulx    488(%rdi),%rbx,%rbp
	adcx    %rbx,%r10
	adox    %rbp,%r11
	adcx    zero(%rip),%r11
	
	addq	$15,%rsi
	
	xorq    %rdx,%rdx
	movq    0(%rsi),%rdx

	mulx    464(%rdi),%r12,%r13
	mulx    472(%rdi),%rbx,%r14
	adcx    %rbx,%r13
	adcx    zero(%rip),%r14

	xorq    %r15,%r15
	movq    8(%rsi),%rdx
	andq    mask56(%rip),%rdx
	orq     c(%rip),%rdx

	mulx    464(%rdi),%rbx,%rbp
	adcx    %rbx,%r13
	adox    %rbp,%r14

	mulx    472(%rdi),%rbx,%rbp
	adcx    %rbx,%r14
	adox    %rbp,%r15
	adcx    zero(%rip),%r15
	
	xorq    %rdx,%rdx
	adcx	%r12,%r8
	adcx	%r13,%r9
	adcx	%r14,%r10
	adcx	%r15,%r11	
	
	addq	$15,%rsi	
	
	xorq    %rdx,%rdx
	movq    0(%rsi),%rdx

	mulx    448(%rdi),%r12,%r13
	mulx    456(%rdi),%rbx,%r14
	adcx    %rbx,%r13
	adcx    zero(%rip),%r14

	xorq    %r15,%r15
	movq    8(%rsi),%rdx
	andq    mask56(%rip),%rdx
	
	cmp	$0,232(%rsp)
	je	.L10	
	orq     c(%rip),%rdx

.L10:
	mulx    448(%rdi),%rbx,%rbp
	adcx    %rbx,%r13
	adox    %rbp,%r14

	mulx    456(%rdi),%rbx,%rbp
	adcx    %rbx,%r14
	adox    %rbp,%r15
	adcx    zero(%rip),%r15

	xorq    %rdx,%rdx
	adcx	%r12,%r8
	adcx	%r13,%r9
	adcx	%r14,%r10
	adcx	%r15,%r11
	
	jmp	.L15
	
.L11:
	movq	8(%rsi),%rdx
	andq    mask56(%rip),%rdx	
	orq     c(%rip),%rdx
	addq	0(%rsi),%r8	
	adcq	%rdx,%r9		
	
	xorq    %rdx,%rdx
	movq    %r8,%rdx

	mulx    464(%rdi),%r8,%r12
	mulx    472(%rdi),%rbx,%r13
	adcx    %rbx,%r12
	adcx    zero(%rip),%r13

	xorq    %r11,%r11
	movq    %r9,%rdx

	mulx    464(%rdi),%r9,%r10
	adcx    %r12,%r9
	adox    %r13,%r10

	mulx    472(%rdi),%rbx,%rbp
	adcx    %rbx,%r10
	adox    %rbp,%r11
	adcx    zero(%rip),%r11
	
	addq	$15,%rsi
	
	xorq    %rdx,%rdx
	movq    0(%rsi),%rdx

	mulx    448(%rdi),%r12,%r13
	mulx    456(%rdi),%rbx,%r14
	adcx    %rbx,%r13
	adcx    zero(%rip),%r14

	xorq    %r15,%r15
	movq    8(%rsi),%rdx
	andq    mask56(%rip),%rdx
	
	cmp	$0,232(%rsp)
	je	.L12	
	orq     c(%rip),%rdx

.L12:
	mulx    448(%rdi),%rbx,%rbp
	adcx    %rbx,%r13
	adox    %rbp,%r14

	mulx    456(%rdi),%rbx,%rbp
	adcx    %rbx,%r14
	adox    %rbp,%r15
	adcx    zero(%rip),%r15

	xorq    %rdx,%rdx
	adcx	%r12,%r8
	adcx	%r13,%r9
	adcx	%r14,%r10
	adcx	%r15,%r11
	
	jmp	.L15	
	
.L13:
	movq	8(%rsi),%rdx
	andq    mask56(%rip),%rdx
	
	cmp	$0,232(%rsp)
	je	.L14	
	
	orq     c(%rip),%rdx	
.L14:	
	addq	0(%rsi),%r8
	adcq	%rdx,%r9

	xorq    %rdx,%rdx
	movq    %r8,%rdx

	mulx    448(%rdi),%r8,%r12
	mulx    456(%rdi),%rbx,%r13
	adcx    %rbx,%r12
	adcx    zero(%rip),%r13

	xorq    %r11,%r11
	movq    %r9,%rdx

	mulx    448(%rdi),%r9,%r10
	adcx    %r12,%r9
	adox    %r13,%r10

	mulx    456(%rdi),%rbx,%rbp
	adcx    %rbx,%r10
	adox    %rbp,%r11
	adcx    zero(%rip),%r11
	
.L15:	
	shld    $1,%r10,%r11
	shld    $1,%r9,%r10

	andq	mask63(%rip),%r9
	xorq	%rdx,%rdx
	adcx    %r10,%r8
	adcx    %r11,%r9
	
.L16:	
	movq    %r9,%r10
	shrq    $63,%r10
	andq	mask63(%rip),%r9
	addq    %r10,%r8
	adcq    zero(%rip),%r9

	movq    %r8,%r11
	movq    %r9,%r12

	subq    p0(%rip),%r8
	sbbq    p1(%rip),%r9

	movq    %r9,%r10
	shlq    $1,%r10

	cmovc   %r11,%r8
	cmovc   %r12,%r9

	movq 	224(%rsp),%rdi
	andq	mask62(%rip),%r9
	movq    %r8,0(%rdi)
	movq    %r9,8(%rdi)

	movq 	0(%rsp),%r11
	movq 	8(%rsp),%r12
	movq 	16(%rsp),%r13
	movq 	24(%rsp),%r14
	movq 	32(%rsp),%r15
	movq 	40(%rsp),%rbx
	movq 	48(%rsp),%rbp

	movq 	%r11,%rsp

	ret
