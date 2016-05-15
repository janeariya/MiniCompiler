.global main
.text
main:
	movq %rsp,%rbp
	sub $216,%rsp

	xor %rax, %rax
	movq %rax,-8(%rbp)

	xor %rax, %rax
	movq %rax,-16(%rbp)

	leaq .showstring, %rdi
	leaq .s0, %rsi
	xor %rax, %rax
	call printf

	movq $40,%rax
	push %rax

	leaq .show, %rdi
	pop %rsi
	xor %rax, %rax
	call printf

	movq $6,%rax
	push %rax

	movq $5,%rax
	push %rax

	pop %rbx
	pop %rax
	sub %rbx, %rax
	push %rax

	pop %rax
	movq %rax,-8(%rbp)

	movq $1,%rax
	push %rax

	pop %rax
	movq %rax,-16(%rbp)

	movq -16(%rbp), %rbx
	movq -8(%rbp), %rax
	cmp %rax,%rbx
	jnz IF0

	leaq .showstring, %rdi
	leaq .s1, %rsi
	xor %rax, %rax
	call printf

IF0 :

	add $216, %rsp
	ret
.data
	.show: .string " %d \n" 
	.showstring: .string " %s \n" 

	.s0: .string "HellothisismafirstProgram"

	.s1: .string "equal"

