format_str: .string "%c"


.global brainfuck
brainfuck:
	pushq %rbp
	movq 	%rsp, %rbp

	// movq %rdi, %rsi
	// movq $format_str, %rdi
	// movq $0, %rax
	// call printf

	pushq	%r12
	pushq	%r13

	movq	%rdi, %r12					# Instruction pointer
	movq	$0, %r13					# Array pointer
	decq	%r12

	movq	$1024, %rdi
	call 	malloc
	pushq	%rax
	subq	$8, %rsp

	movq	%rax, %r13

	movq  $127, %r8
clear_loop:
	movq  $0, (%r13, %r8, 8)
	decq  %r8
	jns   clear_loop

mainloop:
	incq	%r12
	movb	(%r12), %cl

	cmpb	$43, %cl
	je		plusinstruction

	cmpb	$45, %cl
	je		minusinstruction

	cmpb	$62, %cl
	je		rightinstrution

	cmpb	$60, %cl
	je		leftinstrution

	cmpb	$46, %cl
	je		dotinstruction

	cmpb	$44, %cl
	je		commainstrution

	cmpb	$91, %cl
	je		openbracketinstruction

	cmpb	$93, %cl
	je		closingbracketinstruction

	cmpb	$0, %cl
	je 		end

	jmp 	mainloop

plusinstruction:
	incb 	(%r13)
	jmp 	mainloop

minusinstruction:
	decb 	(%r13)
	jmp 	mainloop

rightinstrution:
	incq	%r13
	jmp		mainloop

leftinstrution:
	decq	%r13
	jmp		mainloop

dotinstruction:
	movq	$format_str, %rdi
	xorq	%rsi, %rsi
	movb	(%r13), %sil
	movq	$0, %rax
	call 	printf
	jmp 	mainloop

commainstrution:
	movq	$format_str, %rdi
	movq	%r13, %rsi
	movq	$0, %rax
	call	scanf
	jmp		mainloop

openbracketinstruction:
	pushq	%r12

	#Find closing bracket
	movq	$1, %rcx #nesting depth
	movq	%r12, %rdi

findclosingbracket:
	incq	%rdi

	# First test for opening bracket
	cmpb	$91, (%rdi)
	jne		notopeningbracket
	incq	%rcx
	jmp 	findclosingbracket

notopeningbracket:
	# Test for closing bracket
	cmpb	$93, (%rdi)
	jne		findclosingbracket
	decq	%rcx
	jnz		findclosingbracket
	pushq	%rdi

	# Check if the value is immediately 0
	cmpb	$0, (%r13)
	jnz		mainloop
	popq  %r12
	addq  $8, %rsp
	
	jmp 	mainloop

closingbracketinstruction:
	cmpb	$0, (%r13)
	jnz		bracketloop
	addq	$16, %rsp
	jmp		mainloop

bracketloop:
	movq	8(%rsp), %r12
	jmp 	mainloop

end:
	addq	$8, %rsp
	popq	%rdi
	call 	free

	popq	%r13
	popq	%r12

	movq 	%rbp, %rsp
	popq 	%rbp
	ret
