section .data
    msglen equ 5
    stdout equ 1

    plaintext db "HELLO", 0
    keyword db "KEYKE", 0
    keyword_len equ $ - keyword
    ciphertext db msglen dup(0)

section .text
    global _start

_start:
    mov esi, plaintext
    mov edi, keyword 

    mov ecx, msglen     
    xor ebx, ebx        

encrypt_loop:
   
    movzx eax, byte [edi + ebx]  
    sub eax, 'A'
    mov dl, al

    movzx eax, byte [esi + ebx]  
    sub eax, 'A'

    add al, dl
    and al, 0x1F
    add al, 'A'

    mov [ciphertext + ebx], al

    inc ebx
    cmp ebx, keyword_len
    jl continue_loop
    mov ebx, 0  ; Reset keyword index

continue_loop:
    cmp ebx, msglen
    jl encrypt_loop

print_ciphertext:
    mov eax, 4
    mov ebx, stdout
    mov ecx, ciphertext
    mov edx, msglen
    int 0x80

    mov eax, 1
    xor ebx, ebx
    int 0x80
