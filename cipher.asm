section .data
  msg_len equ 5        ; Length of the input message (including null terminator)
  key_len equ 3        ; Length of the encryption key (including null terminator)

  input_msg db "HELLO",0    ; Message (ensure null termination with '0')
  input_key db "KEY",0     ; Encryption key (ensure null termination with '0')
  cipher_text db msg_len dup(0); Buffer for the ciphertext (allocate enough space)

section .text
  global _start

_start:
  ; Encrypt the message using the Vigenère cipher
  mov esi, input_msg      ; Load the address of the message into esi
  mov edi, cipher_text     ; Load the address of the ciphertext buffer into edi
  mov ebx, input_key      ; Load the address of the key into ebx
  mov ecx, msg_len       ; Load the length of the input message (including null)
  mov edx, key_len       ; Load the length of the key into edx
  mov ecx, 0  ; Initialize counter for processed characters

encrypt_loop:
  cmp ecx, msg_len-1  ; Check if processed all characters (excluding null)
  je print_encrypted_message  ; If processed all, jump to print

  mov al, byte [esi]      ; Load the current character from the message
   ; ... (rest of the encryption logic) ...
   inc ecx  ; Increment counter for processed characters

  inc esi            ; Move to the next character in the message
  inc edi            ; Move to the next character in the ciphertext
  dec ecx            ; Decrement message length (not used in loop anymore)

  ; Fix for lea instruction error (as discussed previously):
  mov ecx, ebx  ; Copy current key position to temporary register
  add ecx, edx  ; Calculate end of key address in ecx

  cmp ebx, ecx  ; Compare current key position with end address
  jb continue_encrypting    ; If not at the end of the key, continue encrypting
  sub ebx, edx         ; Wrap around to the beginning of the key
continue_encrypting:
  jmp encrypt_loop       ; Continue encrypting

print_encrypted_message:
  ; Print the encrypted message using system call (assuming Linux/x86)
  mov eax, 4           ; syscall number for write
  mov ebx, 1           ; file descriptor 1 (stdout)
  mov ecx, cipher_text      ; address of the ciphertext buffer
  mov edx, ecx  ; Use counter (ecount) for actual processed characters
  sub edx, 1  ; Exclude the null terminator from printing
  int 0x80            ; make syscall

  ; Exit the program
  mov eax, 1          ; syscall number for exit
  xor ebx, ebx         ; exit status 0
  int 0x80           ; make syscall
