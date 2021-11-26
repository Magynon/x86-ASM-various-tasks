;; defining constants, you can use these as immediate values in your code
CACHE_LINES  EQU 100
CACHE_LINE_SIZE EQU 8
OFFSET_BITS  EQU 3
TAG_BITS EQU 29 ; 32 - OFSSET_BITS

section .text
    global load

;; void load(char* reg, char** tags, char cache[CACHE_LINES][CACHE_LINE_SIZE], char* address, int to_replace);
load:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]  ; address of reg
    mov ebx, [ebp + 12] ; tags
    mov ecx, [ebp + 16] ; cache
    mov edx, [ebp + 20] ; address
    mov edi, [ebp + 24] ; to_replace (index of the cache line that needs to be replaced in case of a cache MISS)
    ;; DO NOT MODIFY

    ;; TODO: Implment load
    ;; FREESTYLE STARTS HERE

    mov     esi, edx                            ;; use esi for shifts
    shr     esi, OFFSET_BITS                    ;; shift right by offset
    shl     esi, OFFSET_BITS                    ;; shift left by offset

    sub     edx, esi
    shr     esi, OFFSET_BITS                    ;; shift right by offset

    ;; ESI holds TAG
    ;; EDX holds OFFSET

address_search:
    mov     eax, CACHE_LINES                    ;; initialize line counter
    sub     ecx, CACHE_LINE_SIZE                ;; prepare cache head pointer for first increment
    sub     ebx, 4                              ;; prepare cache head pointer for first increment

cache_loop:
    dec     eax                                 ;; decrement line counter
    test    eax, eax                            ;; if reached end of cache memory...
    jz      not_found                           ;; ...byte not found

    add     ebx, 4                              ;; increment current line address
    add     ecx, CACHE_LINE_SIZE

    cmp     [ebx], esi                          ;; compare current line address with TAG
    jne     cache_loop                          ;; if not the same, keep looking

    jmp     load_register                       ;; else proceed with loading the register
    jmp end

not_found:
    mov     ecx, [ebp + 16]                     ;; reset cache counter
    mov     eax, CACHE_LINE_SIZE
    mul     edi
    add     ecx, eax                            ;; find the right line's address where to write

    mov     eax, 4
    mul     edi
    mov     ebx, [ebp + 12]                     ;; reset tag count

    add     ebx, eax                            ;; calculate memory location to write at in tags array
    mov     [ebx], esi                          ;; write tag

    mov     eax, CACHE_LINE_SIZE                ;; intialize byte count on current line
    shl     esi, OFFSET_BITS                    ;; shift left by offset

write_line:
    mov     ebx, [esi]
    mov     [ecx], bl                           ;; write byte

    inc     ecx                                 ;; increment byte address and information to be written
    inc     esi

    dec     eax                                 ;; decrement byte count
    test    eax, eax                            ;; if at end of line...
    jz      reset_tag                           ;; proceed with loading register
    jmp     write_line

reset_tag:
    mov     ebx, [ebp + 12]                     ;; reset tag count
    sub     esi, CACHE_LINE_SIZE                ;; reset esi
    shr     esi, OFFSET_BITS

    mov     ecx, [ebp + 16]                     ;; reset cache head pointer
    jmp     address_search

load_register:
    shl     esi, OFFSET_BITS
    mov     edx, [ebp + 20]                     ;; restore value after mul
    sub     edx, esi

    add     ecx, edx                            ;; get address of wanted value

    mov     eax, [ebp + 8]                      ;; move value to register
    mov     ebx, 0
    mov     [eax], ebx                          ;; set whole reg to 0

    mov     ebx, [ecx]
    mov     [eax], bl                           ;; write only leftmost byte to reg

end:
    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY
