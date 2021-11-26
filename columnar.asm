section .data
    extern len_cheie, len_haystack

section .text
    global columnar_transposition

;; void columnar_transposition(int key[], char *haystack, char *ciphertext);
columnar_transposition:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha 

    mov     edi, [ebp + 8]   ;key
    mov     esi, [ebp + 12]  ;haystack
    mov     ebx, [ebp + 16]  ;ciphertext
    ;; DO NOT MODIFY

    ;; TODO: Implment columnar_transposition
    ;; FREESTYLE STARTS HERE

    mov     eax, 0                          ;; initialize column counter
    
column_setter:
    mov     ecx, 0                          ;; ecx = lenght counter
    add     ecx, [edi + eax*4]              ;; ecx becomes OFFSET
    sub     ecx, [len_cheie]                ;; prepares ecx for first increment

    inc     eax                             ;; increment column counter (curr. column no.)    

write:     
    add     ecx, [len_cheie]                ;; ecx = OFFSET + len_cheie * i
    cmp     ecx, [len_haystack]             ;; check if currently on the last line
    jge     end                             ;; if so exit loop

    add     esi, ecx                        ;; if not, go to next line

    movzx   edx, byte [esi]                 ;; edx = esi[i][j]
    mov     [ebx], dl                       ;; copy char to cipher address

    inc     ebx                             ;; increment cipher array address

    mov     esi, [ebp + 12]                 ;; reset haystack entry value
    jmp     write

end:
    cmp     eax, [len_cheie]
    jl      column_setter

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY
