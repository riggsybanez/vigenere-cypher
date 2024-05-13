section .data
    msg_len equ 5                
    key_len equ 3                

    input_msg db "HELLO",0       
    input_key db "KEY",0          
    cipher_text db msg_len dup(0) 

    ; Define the Vigenère square
    vigenere_square db 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

section .text
    global _start

_start:
    
    mov esi, input_msg            
    mov edi, cipher_text          
    mov ebx, input_key            
    mov ecx, msg_len              

encrypt_loop:
    cmp ecx, 0                    
    je  print_encrypted_message   
    mov al, byte [esi]            
    mov dl, byte [ebx]            
    sub al, 'A'                   
    sub dl, 'A'                   
    movzx edx, dl                 
    add al, dl                    
    and al, 0x1F                  
    add al, 'A'                   
    mov byte [edi], al            
    inc esi                       
    inc ebx                       
    inc edi                       
    dec ecx                       
    jmp encrypt_loop              

print_encrypted_message:
    ; Print the encrypted message
    mov eax, 4                     
    mov ebx, 1                     
    mov ecx, cipher_text           
    mov edx, msg_len               
    int 0x80                       

    ; Exit the program
    mov eax, 1                    
    xor ebx, ebx                  
    int 0x80                      
