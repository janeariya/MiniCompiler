.global main
.text
main:
	movq %rsp,%rbp
	sub $208,%rsp

	xor %rax, %rax
	movq %rax,-0(%rbp)

	movq $25,%rax
	push %rax

	movq $3,%rax
	push %rax

	pop %rbx
	pop %rax
	xor %rdx, %rdx
	idiv %rbx
	push %rdx

	pop %rax
	movq %rax,-8(%rbp)

	leaq .show, %rdi
	movq -8(%rbp),%rsi
	xor %rax, %rax
	call printf

	movq $6,%rax
	push %rax

	movq $5,%rax
	push %rax

	movq $3,%rax
	push %rax

	pop %rbx
	pop %rax
	imul %rbx
	push %rax

	pop %rbx
	pop %rax
	add %rbx, %rax
	push %rax

	movq $10,%rax
	push %rax

	pop %rbx
	pop %rax
	sub %rbx, %rax
	push %rax

	leaq .show, %rdi
	pop %rsi
	xor %rax, %rax
	call printf

	add $208, %rsp
	ret
.data
	.show: .string " %d \n" 

