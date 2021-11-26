; This is your structure
struc  my_date
    .day: resw 1
    .month: resw 1
    .year: resd 1
endstruc

section .text
    global ages

section .data
    present_day:    dd  0
    present_month:    dd  0
    present_year:    dd  0
    quota_month:    dd 0                    ;; used for calculations
    quota_year:    dd  0                    ;; used for calculations
    datesArr:   times my_date_size * 100    dd 0

; void ages(int len, struct my_date* present, struct my_date* dates, int* all_ages);
ages:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]  ; len
    mov     esi, [ebp + 12] ; present
    mov     edi, [ebp + 16] ; dates
    mov     ecx, [ebp + 20] ; all_ages
    ;; DO NOT MODIFY

    ;; TODO: Implement ages
    ;; FREESTYLE STARTS HERE

    ;; copy data from esi memory location to PRESENT struct
    mov     al, byte [esi]
    mov     [present_day], eax

    add     esi, 2
    mov     al, [esi]
    mov     [present_month], eax
    mov     [quota_month], eax

    add     esi, 2
    mov     eax, [esi]
    mov     [present_year], eax
    mov     [quota_year], eax

    mov     ebx, 0

read_loop:
    ;; move all data from memory to struct array
    
    mov     eax, 0
    mov     al, [edi + ebx + my_date.day]
    mov     [datesArr + ebx + my_date.day], al

    mov     al, [edi + ebx + my_date.month]
    mov     [datesArr + ebx + my_date.month], al

    mov     eax, [edi + ebx + my_date.year]
    mov     [datesArr + ebx + my_date.year], eax

    add     ebx, my_date_size

    dec     edx                                     ;; decrement loop counter
    test    edx, edx                                ;; check for end loop
    jnz     read_loop
    
    mov     edx, [ebp + 8]                          ;; reset array length
    mov     edi, 0                                  ;; repurpose edi to index

for_loop:
    mov     al, [datesArr + edi + my_date.day]      ;; al <- birth day
    mov     bl, [datesArr + edi + my_date.month]    ;; bl <- birth month
    
    cmp     al, [present_day]                       ;; check if birth day is greater than present day
    jle     continue_loop_1                         ;; if so, do the according operations

day_ops:
    mov     al, [present_month]                     ;; decrement present_month
    dec     al
    mov     [quota_month], al

continue_loop_1:
    cmp     bl, [quota_month]                       ;; check if birth month is greater than present month
    jle     continue_loop_2                         ;; if so, do the according operations

month_ops:
    mov     ax, [present_year]                      ;; decrement present year
    dec     ax
    mov     [quota_year], ax

continue_loop_2:
    mov     ax, [datesArr + edi + my_date.year]     ;; eax <- birth year

    mov     bx, [quota_year]                        ;; proceed to calculate diff (real age)
    sub     bx, ax

    cmp     bx, 0                                   ;; check if age is negative
    jge     continue_loop_3
    mov     bx, 0                                   ;; if so, make it 0

continue_loop_3:
    mov     [ecx], ebx                              ;; move result to int array
    add     ecx, 4

    mov     ax, [present_year]                      ;; reset quota year
    mov     [quota_year], ax

    mov     ax, [present_month]                     ;; reset quota month
    mov     [quota_month], ax

    add     edi, my_date_size                       ;; increment index

    dec     edx                                     ;; decrement loop counter
    test    edx, edx                                ;; check for end loop
    jnz     for_loop
    jmp     end

end:
    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY

