.global main
.text
main:
	movq %rsp,%rbp
	sub $216,%rsp

	xor %rax, %rax
	movq %rax,-208(%rbp)

	xor %rax, %rax
	movq %rax,-16(%rbp)

	xor %rax, %rax
	movq %rax,-32(%rbp)

	movq $25,%rax
	push %rax

	pop %rax
	movq %rax,-208(%rbp)

	movq $20,%rax
	push %rax

	movq $2,%rax
	push %rax

	pop %rbx
	pop %rax
	xor %rdx, %rdx
	idiv %rbx
	push %rdx

	pop %rax
	movq %rax,-16(%rbp)

	movq $3,%rax
	push %rax

	movq $5,%rax
	push %rax

	pop %rbx
	pop %rax
	imul %rbx
	push %rax

	pop %rax
	movq %rax,-32(%rbp)

	movq $25,%rax
	push %rax

	pop %rbx
	movq -208(%rbp), %rax
	cmp %rax,%rbx
	jnz IF0

	leaq .show, %rdi
	movq -208(%rbp),%rsi
	xor %rax, %rax
	call printf

IF0 :

	add $216, %rsp
	ret
.data
	.show: .string " %d \n" 

