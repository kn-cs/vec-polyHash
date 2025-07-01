/* assembly to compute poly1271 using a delayed reduction  
   over a group of 4x(2+1) = 12 field elements */

	.p2align 5
	.globl poly1271_avx2_maax_g4x2
	
poly1271_avx2_maax_g4x2:

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
	je	.L13

	cmpq	$2,%rcx
	je	.L15
	
	cmpq	$1,%rcx
	je	.L17
	
	// read 512 bits = 64 bytes of message in 2 256-bit 
	// registers and pack it in 5 registers as a 5x4 array
	vmovdqu   0+0*30(%rsi),%ymm0
	vmovdqu   0+1*30(%rsi),%ymm1
	
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
	
	// determine control-flow based on number of message blocks
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
	addq      $60,%rsi
	subq      $4,%rcx

	cmpq      $8,%rcx
	je        .L4
	
	cmpq      $7,%rcx
	je        .L7	
	cmpq      $6,%rcx
	je        .L7	
	cmpq      $5,%rcx
	je        .L7
		
	cmpq      $4,%rcx
	je        .L7
	jl        .L11
	
.L3:	
	vmovdqa   10*32(%rdx),%ymm11	
	vmovdqa   11*32(%rdx),%ymm12
	vmovdqa   12*32(%rdx),%ymm13
	vmovdqa   13*32(%rdx),%ymm14
	vmovdqa   14*32(%rdx),%ymm15	

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

	vmovdqa   19*32(%rdx),%ymm11
	vmovdqa   20*32(%rdx),%ymm12
	vmovdqa   21*32(%rdx),%ymm13
	vmovdqa   22*32(%rdx),%ymm14

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

	// read 512 bits = 64 bytes of message in 2 256-bit 
	// registers and pack it in 5 registers as a 5x4 array
	vmovdqu   0+0*30(%rsi),%ymm11
	vmovdqu   0+1*30(%rsi),%ymm12
	
	vpand     vecmask240(%rip),%ymm11,%ymm13
	vpsllq    $8,%ymm13,%ymm13
	vpermq	  $148,%ymm11,%ymm14
	vpsrlvq   sh56(%rip),%ymm14,%ymm14
	vpand     vecmask56q1(%rip),%ymm14,%ymm14
	vpor	  %ymm13,%ymm14,%ymm11

	vpand     vecmask240(%rip),%ymm12,%ymm13
	vpsllq    $8,%ymm13,%ymm13
	vpermq	  $148,%ymm12,%ymm14
	vpsrlvq   sh56(%rip),%ymm14,%ymm14
	vpand     vecmask56q1(%rip),%ymm14,%ymm14
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

	vmovdqa   5*32(%rdx),%ymm11
	vmovdqa   6*32(%rdx),%ymm12
	vmovdqa   7*32(%rdx),%ymm13
	vmovdqa   8*32(%rdx),%ymm14
	vmovdqa   9*32(%rdx),%ymm15

	vpmuludq  %ymm11,%ymm6,%ymm5
	vpaddq    %ymm5,%ymm0,%ymm0

	vpmuludq  %ymm11,%ymm7,%ymm5
	vpaddq    %ymm5,%ymm1,%ymm1
	vpmuludq  %ymm12,%ymm6,%ymm5
	vpaddq    %ymm5,%ymm1,%ymm1

	vpmuludq  %ymm11,%ymm8,%ymm5
	vpaddq    %ymm5,%ymm2,%ymm2
	vpmuludq  %ymm12,%ymm7,%ymm5
	vpaddq    %ymm5,%ymm2,%ymm2
	vpmuludq  %ymm13,%ymm6,%ymm5
	vpaddq    %ymm5,%ymm2,%ymm2

	vpmuludq  %ymm11,%ymm9,%ymm5
	vpaddq    %ymm5,%ymm3,%ymm3
	vpmuludq  %ymm12,%ymm8,%ymm5
	vpaddq    %ymm5,%ymm3,%ymm3
	vpmuludq  %ymm13,%ymm7,%ymm5
	vpaddq    %ymm5,%ymm3,%ymm3
	vpmuludq  %ymm14,%ymm6,%ymm5
	vpaddq    %ymm5,%ymm3,%ymm3

	vpmuludq  %ymm11,%ymm10,%ymm5
	vpaddq    %ymm5,%ymm4,%ymm4
	vpmuludq  %ymm12,%ymm9,%ymm5
	vpaddq    %ymm5,%ymm4,%ymm4
	vpmuludq  %ymm13,%ymm8,%ymm5
	vpaddq    %ymm5,%ymm4,%ymm4
	vpmuludq  %ymm14,%ymm7,%ymm5
	vpaddq    %ymm5,%ymm4,%ymm4
	vpmuludq  %ymm15,%ymm6,%ymm5
	vpaddq    %ymm5,%ymm4,%ymm4

	vmovdqa   15*32(%rdx),%ymm11
	vmovdqa   16*32(%rdx),%ymm12
	vmovdqa   17*32(%rdx),%ymm13
	vmovdqa   18*32(%rdx),%ymm14

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

	// read 512 bits = 64 bytes of message in 2 256-bit 
	// registers and pack it in 5 registers as a 5x4 array
	vmovdqu   0+2*30(%rsi),%ymm11
	vmovdqu   0+3*30(%rsi),%ymm12
	
	vpand     vecmask240(%rip),%ymm11,%ymm13
	vpsllq    $8,%ymm13,%ymm13
	vpermq	  $148,%ymm11,%ymm14
	vpsrlvq   sh56(%rip),%ymm14,%ymm14
	vpand     vecmask56q1(%rip),%ymm14,%ymm14
	vpor	  %ymm13,%ymm14,%ymm11

	vpand     vecmask240(%rip),%ymm12,%ymm13
	vpsllq    $8,%ymm13,%ymm13
	vpermq	  $148,%ymm12,%ymm14
	vpsrlvq   sh56(%rip),%ymm14,%ymm14
	vpand     vecmask56q1(%rip),%ymm14,%ymm14
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

	addq      $120,%rsi
	subq      $8,%rcx

	cmpq	  $8,%rcx
	jg	  .L3
	je	  .L4
	
	cmpq      $7,%rcx
	je        .L7
	cmpq      $6,%rcx
	je        .L7	
	cmpq      $5,%rcx
	je        .L7	

	cmpq	  $4,%rcx
	je	  .L7
	jl	  .L11

.L4:
	vmovdqa   10*32(%rdx),%ymm11
	vmovdqa   11*32(%rdx),%ymm12
	vmovdqa   12*32(%rdx),%ymm13
	vmovdqa   13*32(%rdx),%ymm14
	vmovdqa   14*32(%rdx),%ymm15

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

	vmovdqa   19*32(%rdx),%ymm11
	vmovdqa   20*32(%rdx),%ymm12
	vmovdqa   21*32(%rdx),%ymm13
	vmovdqa   22*32(%rdx),%ymm14

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

	// read 512 bits = 64 bytes of message in 2 256-bit 
	// registers and pack it in 5 registers as a 5x4 array
	vmovdqu   0+0*30(%rsi),%ymm11
	vmovdqu   0+1*30(%rsi),%ymm12
	
	vpand     vecmask240(%rip),%ymm11,%ymm13
	vpsllq    $8,%ymm13,%ymm13
	vpermq	  $148,%ymm11,%ymm14
	vpsrlvq   sh56(%rip),%ymm14,%ymm14
	vpand     vecmask56q1(%rip),%ymm14,%ymm14
	vpor	  %ymm13,%ymm14,%ymm11

	vpand     vecmask240(%rip),%ymm12,%ymm13
	vpsllq    $8,%ymm13,%ymm13
	vpermq	  $148,%ymm12,%ymm14
	vpsrlvq   sh56(%rip),%ymm14,%ymm14
	vpand     vecmask56q1(%rip),%ymm14,%ymm14
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

	vmovdqa   5*32(%rdx),%ymm11
	vmovdqa   6*32(%rdx),%ymm12
	vmovdqa   7*32(%rdx),%ymm13
	vmovdqa   8*32(%rdx),%ymm14
	vmovdqa   9*32(%rdx),%ymm15

	vpmuludq  %ymm11,%ymm6,%ymm5
	vpaddq    %ymm5,%ymm0,%ymm0

	vpmuludq  %ymm11,%ymm7,%ymm5
	vpaddq    %ymm5,%ymm1,%ymm1
	vpmuludq  %ymm12,%ymm6,%ymm5
	vpaddq    %ymm5,%ymm1,%ymm1

	vpmuludq  %ymm11,%ymm8,%ymm5
	vpaddq    %ymm5,%ymm2,%ymm2
	vpmuludq  %ymm12,%ymm7,%ymm5
	vpaddq    %ymm5,%ymm2,%ymm2
	vpmuludq  %ymm13,%ymm6,%ymm5
	vpaddq    %ymm5,%ymm2,%ymm2

	vpmuludq  %ymm11,%ymm9,%ymm5
	vpaddq    %ymm5,%ymm3,%ymm3
	vpmuludq  %ymm12,%ymm8,%ymm5
	vpaddq    %ymm5,%ymm3,%ymm3
	vpmuludq  %ymm13,%ymm7,%ymm5
	vpaddq    %ymm5,%ymm3,%ymm3
	vpmuludq  %ymm14,%ymm6,%ymm5
	vpaddq    %ymm5,%ymm3,%ymm3

	vpmuludq  %ymm11,%ymm10,%ymm5
	vpaddq    %ymm5,%ymm4,%ymm4
	vpmuludq  %ymm12,%ymm9,%ymm5
	vpaddq    %ymm5,%ymm4,%ymm4
	vpmuludq  %ymm13,%ymm8,%ymm5
	vpaddq    %ymm5,%ymm4,%ymm4
	vpmuludq  %ymm14,%ymm7,%ymm5
	vpaddq    %ymm5,%ymm4,%ymm4
	vpmuludq  %ymm15,%ymm6,%ymm5
	vpaddq    %ymm5,%ymm4,%ymm4

	vmovdqa   15*32(%rdx),%ymm11
	vmovdqa   16*32(%rdx),%ymm12
	vmovdqa   17*32(%rdx),%ymm13
	vmovdqa   18*32(%rdx),%ymm14

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

	// read 512 bits = 64 bytes of message in 2 256-bit 
	// registers and pack it in 5 registers as a 5x4 array
	vmovdqu   0+2*30(%rsi),%ymm11
	vmovdqu   0+3*30(%rsi),%ymm12
	
	vpand     vecmask240(%rip),%ymm11,%ymm13
	vpsllq    $8,%ymm13,%ymm13
	vpermq	  $148,%ymm11,%ymm14
	vpsrlvq   sh56(%rip),%ymm14,%ymm14
	vpand     vecmask56q1(%rip),%ymm14,%ymm14
	vpor	  %ymm13,%ymm14,%ymm11

	vpand     vecmask240(%rip),%ymm12,%ymm13
	vpsllq    $8,%ymm13,%ymm13
	vpermq	  $148,%ymm12,%ymm14
	vpsrlvq   sh56(%rip),%ymm14,%ymm14
	vpand     vecmask56q1(%rip),%ymm14,%ymm14
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
	jmp       .L6

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

	addq      $120,%rsi
	subq      $8,%rcx

	jmp .L11

.L7:
	vmovdqa   5*32(%rdx),%ymm11
	vmovdqa   6*32(%rdx),%ymm12
	vmovdqa   7*32(%rdx),%ymm13
	vmovdqa   8*32(%rdx),%ymm14
	vmovdqa   9*32(%rdx),%ymm15

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

	vmovdqa   15*32(%rdx),%ymm11
	vmovdqa   16*32(%rdx),%ymm12
	vmovdqa   17*32(%rdx),%ymm13
	vmovdqa   18*32(%rdx),%ymm14

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
	
	// read 512 bits = 64 bytes of message in 2 256-bit 
	// registers and pack it in 5 registers as a 5x4 array
	vmovdqu   0+0*30(%rsi),%ymm11
	vmovdqu   0+1*30(%rsi),%ymm12
	
	vpand     vecmask240(%rip),%ymm11,%ymm13
	vpsllq    $8,%ymm13,%ymm13
	vpermq	  $148,%ymm11,%ymm14
	vpsrlvq   sh56(%rip),%ymm14,%ymm14
	vpand     vecmask56q1(%rip),%ymm14,%ymm14
	vpor	  %ymm13,%ymm14,%ymm11

	vpand     vecmask240(%rip),%ymm12,%ymm13
	vpsllq    $8,%ymm13,%ymm13
	vpermq	  $148,%ymm12,%ymm14
	vpsrlvq   sh56(%rip),%ymm14,%ymm14
	vpand     vecmask56q1(%rip),%ymm14,%ymm14
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
	
	cmpq      $4,%rcx
	jg        .L8

	cmpq      $0,232(%rsp)
	je        .L9

.L8:
	vpor      vecpad(%rip),%ymm10,%ymm10
	jmp       .L10

.L9:
	vpor      vecpadend(%rip),%ymm10,%ymm10

.L10:
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

	addq      $60,%rsi
	subq      $4,%rcx
	
.L11:
	vmovdqa   0*32(%rdx),%ymm11
	vmovdqa   1*32(%rdx),%ymm12
	vmovdqa   2*32(%rdx),%ymm13
	vmovdqa   3*32(%rdx),%ymm14
	vmovdqa   4*32(%rdx),%ymm15

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
	
	vmovdqa   %ymm0,64+0*32(%rsp)
	vmovdqa   %ymm1,64+1*32(%rsp)
	vmovdqa   %ymm2,64+2*32(%rsp)
	vmovdqa   %ymm3,64+3*32(%rsp)
	vmovdqa   %ymm4,64+4*32(%rsp)	
	
.L12:
	// P = T0 + T1 + T2 + T3
	movq    64+0*32+0*8(%rsp),%r8
	addq    64+0*32+1*8(%rsp),%r8
	addq    64+0*32+2*8(%rsp),%r8
	addq    64+0*32+3*8(%rsp),%r8

	movq    64+1*32+0*8(%rsp),%r9
	addq    64+1*32+1*8(%rsp),%r9
	addq    64+1*32+2*8(%rsp),%r9
	addq    64+1*32+3*8(%rsp),%r9

	movq    64+2*32+0*8(%rsp),%r10
	addq    64+2*32+1*8(%rsp),%r10
	addq    64+2*32+2*8(%rsp),%r10
	addq    64+2*32+3*8(%rsp),%r10

	movq    64+3*32+0*8(%rsp),%r11
	addq    64+3*32+1*8(%rsp),%r11
	addq    64+3*32+2*8(%rsp),%r11
	addq    64+3*32+3*8(%rsp),%r11

	movq    64+4*32+0*8(%rsp),%rax
	addq    64+4*32+1*8(%rsp),%rax
	addq    64+4*32+2*8(%rsp),%rax
	addq    64+4*32+3*8(%rsp),%rax
	
	// reduce fully the 5-limb sum
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
	//
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
	
	// pack the 5-limb result into 2-limb form
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
	je	.L20
	
	movq	56(%rsp),%rdi

	cmpq	$3,%rcx	
	je	.L13
	
	cmpq	$2,%rcx	
	je	.L15
	
	cmpq	$1,%rcx	
	je	.L17	
	
.L13:
	movq	1*8(%rsi),%rdx
	andq    mask56(%rip),%rdx	
	orq     c(%rip),%rdx
	addq	0*8(%rsi),%r8	
	adcq	%rdx,%r9
	
	// tau^3
	xorq    %rdx,%rdx
	movq    %r8,%rdx

	mulx    736+4*8(%rdi),%r8,%r12
	mulx    736+5*8(%rdi),%rbx,%r13
	adcx    %rbx,%r12
	adcx    zero(%rip),%r13

	xorq    %r11,%r11
	movq    %r9,%rdx

	mulx    736+4*8(%rdi),%r9,%r10
	adcx    %r12,%r9
	adox    %r13,%r10

	mulx    736+5*8(%rdi),%rbx,%rbp
	adcx    %rbx,%r10
	adox    %rbp,%r11
	adcx    zero(%rip),%r11
	
	addq	$15,%rsi
	
	// tau^2
	xorq    %rdx,%rdx
	movq    0*8(%rsi),%rdx

	mulx    736+2*8(%rdi),%r12,%r13
	mulx    736+3*8(%rdi),%rbx,%r14
	adcx    %rbx,%r13
	adcx    zero(%rip),%r14

	xorq    %r15,%r15
	movq    1*8(%rsi),%rdx
	andq    mask56(%rip),%rdx
	orq     c(%rip),%rdx

	mulx    736+2*8(%rdi),%rbx,%rbp
	adcx    %rbx,%r13
	adox    %rbp,%r14

	mulx    736+3*8(%rdi),%rbx,%rbp
	adcx    %rbx,%r14
	adox    %rbp,%r15
	adcx    zero(%rip),%r15
	
	// add
	xorq    %rdx,%rdx
	adcx	%r12,%r8
	adcx	%r13,%r9
	adcx	%r14,%r10
	adcx	%r15,%r11	
	
	addq	$15,%rsi	
	
	// tau
	xorq    %rdx,%rdx
	movq    0*8(%rsi),%rdx

	mulx    736+0*8(%rdi),%r12,%r13
	mulx    736+1*8(%rdi),%rbx,%r14
	adcx    %rbx,%r13
	adcx    zero(%rip),%r14

	xorq    %r15,%r15
	movq    1*8(%rsi),%rdx
	andq    mask56(%rip),%rdx
	
	cmp	$0,232(%rsp)
	je	.L14	
	orq     c(%rip),%rdx

.L14:
	mulx    736+0*8(%rdi),%rbx,%rbp
	adcx    %rbx,%r13
	adox    %rbp,%r14

	mulx    736+1*8(%rdi),%rbx,%rbp
	adcx    %rbx,%r14
	adox    %rbp,%r15
	adcx    zero(%rip),%r15

	// add
	xorq    %rdx,%rdx
	adcx	%r12,%r8
	adcx	%r13,%r9
	adcx	%r14,%r10
	adcx	%r15,%r11
	
	jmp	.L19
	
.L15:
	movq	1*8(%rsi),%rdx
	andq    mask56(%rip),%rdx	
	orq     c(%rip),%rdx
	addq	0*8(%rsi),%r8	
	adcq	%rdx,%r9		
	
	// tau^2
	xorq    %rdx,%rdx
	movq    %r8,%rdx

	mulx    736+2*8(%rdi),%r8,%r12
	mulx    736+3*8(%rdi),%rbx,%r13
	adcx    %rbx,%r12
	adcx    zero(%rip),%r13

	xorq    %r11,%r11
	movq    %r9,%rdx

	mulx    736+2*8(%rdi),%r9,%r10
	adcx    %r12,%r9
	adox    %r13,%r10

	mulx    736+3*8(%rdi),%rbx,%rbp
	adcx    %rbx,%r10
	adox    %rbp,%r11
	adcx    zero(%rip),%r11
	
	addq	$15,%rsi
	
	// tau
	xorq    %rdx,%rdx
	movq    0*8(%rsi),%rdx

	mulx    736+0*8(%rdi),%r12,%r13
	mulx    736+1*8(%rdi),%rbx,%r14
	adcx    %rbx,%r13
	adcx    zero(%rip),%r14

	xorq    %r15,%r15
	movq    1*8(%rsi),%rdx
	andq    mask56(%rip),%rdx
	
	cmp	$0,232(%rsp)
	je	.L16	
	orq     c(%rip),%rdx

.L16:
	mulx    736+0*8(%rdi),%rbx,%rbp
	adcx    %rbx,%r13
	adox    %rbp,%r14

	mulx    736+1*8(%rdi),%rbx,%rbp
	adcx    %rbx,%r14
	adox    %rbp,%r15
	adcx    zero(%rip),%r15

	// add
	xorq    %rdx,%rdx
	adcx	%r12,%r8
	adcx	%r13,%r9
	adcx	%r14,%r10
	adcx	%r15,%r11
	
	jmp	.L19
	
.L17:
	movq	1*8(%rsi),%rdx
	andq    mask56(%rip),%rdx
	
	cmp	$0,232(%rsp)
	je	.L18
	
	orq     c(%rip),%rdx	
.L18:	
	addq	0*8(%rsi),%r8
	adcq	%rdx,%r9

	// tau
	xorq    %rdx,%rdx
	movq    %r8,%rdx

	mulx    736+0*8(%rdi),%r8,%r12
	mulx    736+1*8(%rdi),%rbx,%r13
	adcx    %rbx,%r12
	adcx    zero(%rip),%r13

	xorq    %r11,%r11
	movq    %r9,%rdx

	mulx    736+0*8(%rdi),%r9,%r10
	adcx    %r12,%r9
	adox    %r13,%r10

	mulx    736+1*8(%rdi),%rbx,%rbp
	adcx    %rbx,%r10
	adox    %rbp,%r11
	adcx    zero(%rip),%r11
	
.L19:	
	// reduce 4-limb
	shld    $1,%r10,%r11
	shld    $1,%r9,%r10

	andq	mask63(%rip),%r9
	xorq	%rdx,%rdx
	adcx    %r10,%r8
	adcx    %r11,%r9
	
.L20:	
	// reduce 2-limb
	movq    %r9,%r10
	shrq    $63,%r10
	andq	mask63(%rip),%r9
	addq    %r10,%r8
	adcq    zero(%rip),%r9

	// normalize 
	movq    %r8,%r11
	movq    %r9,%r12

	subq    p0(%rip),%r8
	sbbq    p1(%rip),%r9

	movq    %r9,%r10
	shlq    $1,%r10

	cmovc   %r11,%r8
	cmovc   %r12,%r9

.LAST:	
	// store hash
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
