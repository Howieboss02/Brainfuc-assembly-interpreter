
.data
buffer: .skip 1024 # reserve 1024 bytes o memmory
.text
input:	.asciz "%c"; 
output: .asciz "%c";

.global brainfuck

/*
char code[];
char memory[1024];
int mem = 0, code_pointer = 0; //memory pointer,

int main() {
    while (code[code_pointer] != 0) {

        char c = code[code_pointer];

        if (c == '>') mem++;
        else if (c == '<') mem--;
        else if (c == '.') printf("%c", memory[mem]);
        else if (c == ',') scanf("%c", memory[mem]);
        else if (c == '+') memory[mem]++;
        else if (c == '-') memory[mem]--;
        else if (c == '[' && memory[mem] == 0) {   
            char open = 1;
            while (open) {
                code_pointer++;
                if (code[code_pointer] == '[')
                    open++;
                if (code[code_pointer] == ']')
                    open--;
            }
        }
        else if (c == ']' && memory[mem] > 0) {
            char close = 1;
            while (close) {   
                code_pointer--;
                if (code[code_pointer] == ']')
                    close++;
                if (code[code_pointer] == '[')
                    close--;
            }
        }
        code_pointer++;
    }
    printf("\n");
}
*/

# Your brainfuck subroutine will receive one argument:
# a zero termianted string containing the code to execute.
brainfuck:
	
	# prologue
	pushq 	%rbp
	movq 	%rsp, %rbp

	# rdi stores the address to the begining of brainfuck code
	call 	interpret
	
	movq	$0, %rax					# no errors in code
	# epilogue
	movq 	%rbp, %rsp
	popq 	%rbp
	ret

interpret:

	# prologue
	pushq 	%rbp
	movq 	%rsp, %rbp

	# save callee-saved registers on the stack
    pushq   %r12
    pushq   %r13
    pushq   %r14
    pushq   %r15

	# loop code
	movq 	%rdi, %r15 					# store the brainfuck code iterator in r15 
	movq 	$buffer, %r14				# store the pointer to the arraylist

loopoverbrainfuckcode:
	
	# >
	incq  	%r14						# shift the pointer to next cell
	cmpb	$62, (%r15)				    # compare the char to >
	je      endOfLoop					# if equal jump to end of loop
	decq	%r14						# revoke the change if not equal 


	# < 
	decq	%r14						# shift the poointer to previos cell
	cmpb	$60, (%r15)					# compare the char to < 
	je 		endOfLoop					# if equal jump to end of loop
	incq 	%r14						# revoke the change if not equal 	


	# + 
	incb 	(%r14)						# add 1 to the cell to which the pointer is pointing
	cmpb	$43, (%r15)					# compare the char to +
	je 		endOfLoop					# if equal jump to end of loop
	decb	(%r14)						# revoke the change if not equal


	# - 
	decb	(%r14)						# subtract 1 from the cell to which the pointer is pointing
	cmpb	$45, (%r15) 				# compare the char to -
	je 		endOfLoop					# if equal jump to end of loop
	incb	(%r14)						# revoke the change if not equal
	

	# .		
	cmpb	$46, (%r15)					# compare the char to .
	je 		printing					# if equal jump to the printing subroutine


	# ,
	cmpb	$44, (%r15)					# compare the char to ,
	je 		scanning					# if equal jump to the printing subroutine


	# [
	cmpb	$91, (%r15)					# compare the char to [
	jne		tryCloseLoop				# jump to check for next char

	cmpb	$0, (%r14)					# is current cell equal to 0
	jne		endOfLoop					# continue code if not

	movq 	$1, %rcx					# rcx will be a counter (difference between num( [ ) and num( ] ))

findEndOfLoop:
	incq	%r15						# go to next char
	incq	%rcx						# increment the number 

	cmpb	$91, (%r15)					# compare the char to [
	je		end_findEndOfLoop			# if equal go to end of the small loop
	decq	%rcx						# revoke the changes

	decq	%rcx						# decrement the counter
	cmpb	$93, (%r15)					# compare the char to }
	je		end_findEndOfLoop			# if equal go to end of the small loop
	incq	%rcx						# revoke changes

end_findEndOfLoop:
	cmpq	$0, %rcx					# should we stop the small loop
	jne 	findEndOfLoop				# if not jump to begin of loop
	jmp 	endOfLoop					#after the execution go to next character


	# ]
tryCloseLoop:
	
	cmpb	$93, (%r15)					# compare the char to ]
	jne 	endOfLoop					# condition not satisfied go to end of loop
	cmpb	$0, (%r14)					# should i repeat the loop				
	je		endOfLoop					# go to end of main loop 

	movq 	$1, %rcx					# rcx will be a counter (difference between num( [ ) and num( ] ))

findBeginOfLoop:
	decq 	%r15						# go to prevoius char
	
	incq	%rcx						# increment the number 
	cmpb	$93, (%r15)					# compare the char to ]
	je		end_findBeginOfLoop			# go to end of the small loop
	decq	%rcx						# revoke the changes

	decq	%rcx						# decrement the counter
	cmpb	$91, (%r15)					# compare the char to [
	je		end_findBeginOfLoop			# if equal jump to end of small loop
	incq	%rcx						# revoke changes

end_findBeginOfLoop:
	cmpq	$0, %rcx					# should i stop the small loop execution
	jne 	findBeginOfLoop				

	jmp 	endOfLoop					# next char


printing:
	movq	$output, %rdi				# parse what should be printed
	movq 	(%r14), %rsi				# parsing what should be printed
	movq    $0, %rax 					# no vector arguments 
	call 	printf				

	jmp 	endOfLoop 					# jump to end of big loop

scanning:
    movq    $input, %rdi            	# copy the base address to rdi
    leaq    (%r14), %rsi          		# load the address where the value will be stored 
	movq    $0, %rax                	# no vector arguments
    call    scanf                   	# Scan input

endOfLoop:

	incq	%r15						# increment the iterator

	cmpq	$0, (%r15)					# is end of file
	jne		loopoverbrainfuckcode

	# restore callee-saved registers
    popq    %r15
    popq    %r14
    popq    %r13
    popq    %r12

	# epilogue
	movq 	%rbp, %rsp
	popq 	%rbp
	ret
