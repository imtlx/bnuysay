format ELF64 executable 3

macro addch char {
	mov byte [rdi], char
	inc rdi
}

macro midl {
	addch '|'
	addch ' '
}

macro midr {
	addch ' '
	addch '|'
	addch 10
}

macro line {
	mov rcx, r8
	add rcx, 2
	mov al, '-'
	cld
	rep stosb
}

macro topline {
	addch '/'
	line
	addch '\'
	addch 10
}

macro botline {
	addch '\'
	line
	addch '/'
	addch 10
}

macro strlen reg {
	local .loop, .end
	xor reg, reg
	.loop:
		cmp byte [rsi+reg], 0
		je .end
		cmp byte [rsi+reg], 10
		je .end
		inc reg
		jmp .loop
	.end:
}

segment readable executable
entry $
	mov rax, [rsp]
	cmp rax, 2
	jne .stdin

	mov rsi, [rsp+16]
        lea rdi, [input]
	xor ecx, ecx
.copy:
	cmp ecx, 4096
	je .copy_end
        lodsb
        stosb
	inc ecx

        test al, al
        jnz .copy

.copy_end:
	mov byte [input+ecx], 0
        lea rsi, [input]
	jmp .main

.stdin:
	xor r12, r12
.read:
	xor eax, eax
	xor edi, edi
	lea rsi, [input+r12]
	mov edx, 4096
	sub edx, r12d
	syscall

	test rax, rax
	js .exit_fail
	jz .read_end

	add r12, rax
	cmp r12, 4096
	jb .read

.read_end:
	test r12, r12
	jz .exit_fail

	mov byte [input+r12], 0

	cmp byte [input+r12-1], 10
	jne .main
	mov byte [input+r12-1], 0

.main:
	lea rsi, [input]
	xor r8, r8
; get max len
.scan:
	strlen r9
	cmp r9, r8
	jle .next
	mov r8, r9
.next:
	add rsi, r9
	cmp byte [rsi], 0
	je .scan_end
	inc rsi
	jmp .scan
.scan_end:


; render
	lea rsi, [input]
	lea rdi, [buf]
	addch 10
	topline
.next_line:
	midl
	strlen r9
	mov rcx, r9
	rep movsb
	mov rcx, r8
	sub rcx, r9
	mov al, ' '
	rep stosb
	midr
	cmp byte [rsi], 0
	je .render_end
	inc rsi
	jmp .next_line

.render_end:
	botline

; bnuy
	lea rsi, [bnuy]
	mov rcx, bnuy_size
	cld
	rep movsb

; print
	mov r12, rdi
	sub r12, buf

	lea rsi, [buf]
	mov r13, r12

.write:
	test r13, r13
	jz .exit_succ

	mov eax, 1
	mov edi, 1
	mov rdx, r13
	syscall

	test rax, rax
	js .exit_fail
	jz .exit_fail

	add rsi, rax
	sub r13, rax
	jmp .write

.exit_succ:
	xor edi, edi
	jmp .exit

.exit_fail:
	mov rdi, 1

.exit:
	mov eax, 60
	syscall

segment writable executable
bnuy  db '    \', 10
      db '     \', 10
      db '       (\(\', 10
      db '       ( o.o)', 10
      db '       o_(")(")', 10
bnuy_size = $-bnuy

segment readable writable
input rb 4097
buf rb 32768
