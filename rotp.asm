section .text
    global rotp

;; void rotp(char *ciphertext, char *plaintext, char *key, int len);
rotp:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]  ; ciphertext
    mov     esi, [ebp + 12] ; plaintext
    mov     edi, [ebp + 16] ; key
    mov     ecx, [ebp + 20] ; len
    ;; DO NOT MODIFY

    ;; TODO: Implment rotp
    ;; FREESTYLE STARTS HERE

forLoop:
    sub     ecx, 3
    mov     ebx, [esi]                                  ;; move 4 char chunk of plaintext into ebx
    mov     eax, [edi + ecx-1]                          ;; move 4 char chunk of key into eax
    bswap   eax                                         ;; little-endianize eax

    xor     ebx, eax                                    ;; xor between plaintext and key chunks

    mov     [edx], ebx                                  ;; move result chunk to memory address found at edx

    add     edx, 4                                      ;; inc RESULT memory counter (edx) + 4 bytes
    add     esi, 4                                      ;; inc PLAINTEXT memory counter (esi) + 4 bytes
    sub     ecx, 1                                      ;; dec KEY memory counter (ecx) - 4 bytes (2 sub's)
    cmp     ecx, 0                                      ;; check if loop ended
    jg      forLoop                                     ;; exit loop

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY
