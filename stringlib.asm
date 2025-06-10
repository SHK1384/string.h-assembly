nl = 10
maxLen = 256

.data
    s1 byte "hello world!", 0
    s2 byte "hello home!", 0
    s_copy byte maxLen dup (?)
    fmtStr byte "out: %d", nl, 0

.code
    externdef printf:proc
    externdef readLine:proc

; wants the address of the a variable in the RCX register
; strlen(char *a)
; returns the lenght of the string a in the RAX regsiter
strlen proc
    push rbp
    mov rbp, rsp
    sub rsp, 32

    mov rax, -1
    begloop:
    inc rax
    cmp byte ptr [rcx+rax], 0
    jne begloop

    add rsp, 32
    leave
    ret
strlen endp

; wants the address of source in the RCX register and the
; address of dest in the RDX register
; strcpy(char *source, char *dest)
; fills the dest variable with the characters of the source variable
strcpy proc
    push rbp
    mov rbp, rsp
    sub rsp, 40
    push r12

    mov rax, -1
    begloop:
    inc rax
    mov r12, [rcx+rax]
    mov [rdx+rax], r12
    cmp byte ptr [rcx+rax], 0
    jne begloop

    pop r12
    add rsp, 40
    leave
    ret
strcpy endp

; wants the address of a variable in the RCX register and the
; address of the b variable in the RDX register
; strcmp(char *a, char *b)
; returns 1 in the RAX register if the two strings are equal
strcmp proc
    push rbp
    mov rbp, rsp
    sub rsp, 32
    push r12
    push r13

    mov rax, 1
    mov r12, -1
    begloop:
    inc r12
    mov r13b, [rcx+r12]
    cmp r13b, byte ptr [rdx+r12]
    jne endloopfalse
    cmp byte ptr [rcx+r12], 0
    je endlooptrue
    jmp begloop

    endloopfalse:
    mov rax, 0
    endlooptrue:
    pop r13
    pop r12
    add rsp, 32
    leave
    ret
strcmp endp

memcpyasm proc
    push rbp
    mov rbp, rsp
    sub rsp, 40
    push r12

    ; RCX = source pointer
    ; RDX = destination pointer
    ; R8 = number of bytes
    cmp r8, 0
    jna done
    begloop:
    dec r8
    mov r12b, byte ptr [rcx+r8]
    mov byte ptr [rdx+r8], r12b
    cmp r8, 0
    jne begloop

    done:
    pop r12
    add rsp, 40
    leave
    ret
memcpyasm endp

memsetasm proc
    push rbp
    mov rbp, rsp
    sub rsp, 32

    ; RCX = destination pointer
    ; RDX = value to fill 
    ; R8 = number of bytes
    cmp r8, 0
    jna done
    begloop:
    dec r8
    mov byte ptr [rcx+r8], dl
    cmp r8, 0
    jne begloop

    done:
    add rsp, 32
    leave
    ret
memsetasm endp

memcmpasm proc
    push rbp
    mov rbp, rsp
    sub rsp, 40
    push r12

    ; RCX = first pointer
    ; RDX = second pointer
    ; R8 = number of bytes
    mov rax, 1
    begloop:
    cmp r8, 0
    jna done
    dec r8
    mov r12b, byte ptr [rdx+r8]
    cmp byte ptr [rcx+r8], r12b
    je begloop
    mov rax, 0

    done:
    pop r12
    add rsp, 40
    leave
    ret
memcmpasm endp


public asmMain
asmMain proc
    sub rsp, 40

    lea rcx, s1
    lea rdx, s2
    mov r8, 7
    call memcmpasm

    lea rcx, fmtStr
    mov rdx, rax
    call printf

    add rsp, 40
    ret
asmMain endp
end