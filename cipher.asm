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
    ; Calculate the current key character
    movzx eax, byte [edi + ebx]  
    sub eax, 'A'
    mov dl, al

    ; Calculate the current plaintext character
    movzx eax, byte [esi + ebx]  
    sub eax, 'A'

    ; Encrypt the current character using Vigenère cipher (arithmetic method)
    add al, dl
    and al, 0x1F
    add al, 'A'

    ; Store the encrypted character in ciphertext buffer
    mov [ciphertext + ebx], al

    ; Move to the next character of the keyword (cycling if necessary)
    inc ebx
    cmp ebx, keyword_len
    jl continue_loop
    mov ebx, 0  ; Reset keyword index

continue_loop:
    ; Check if there are more characters to encrypt
    cmp ebx, msglen
    jl encrypt_loop

print_ciphertext:
    ; Print the ciphertext
    mov eax, 4
    mov ebx, stdout
    mov ecx, ciphertext
    mov edx, msglen
    int 0x80

    ; Exit the program
    mov eax, 1
    xor ebx, ebx
    int 0x80
