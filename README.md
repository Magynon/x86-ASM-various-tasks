# Ștefan MĂGIRESCU

## x86 ASM

</br>
Most of the instructions are well documented in the comments so here I will only do a broad description of the thought process.
</br></br>


## **Task no. 1**:

</br>

- in **for_loop** *ecx* is the counter which moves 4 bytes at a time (the program encodes the message 4 bytes at a time - one register at a time)
- next, xor happens (4 bytes of plaintext with 4 bytes of reversed key) and after that, all the indexes are updated for the next write
- the key is byte-swapped, because reversing the key also changes the endian

</br>

## **Task no. 2**:

</br>

- first, the present date is copied in variables
- the **read_loop** goes reads all the birth dates and copies the data to structs
- inside the **for_loop** the age is calculated
- *quota_month* and *quota_year* start as being equal to *present_month* and *present_year*, but then change their values as to suit the algorithm
- the algorithm first checks if the birth day is greater than the present day, if so the quota_month is decremented. Then it checks if the birth month is greater than the now updated quota_month. If so, it decrements the quota_year. Finally, it substracts the birth year from the quota_year
- after the algorithm ends, the age is written to the output int array stored in *ecx*

</br>

## **Task no. 3**:

</br>

- inside **column_setter** the column index *(ecx reg)* is setup (= offset of current column) and the column counter *(eax reg)* is incremented at each iteration
- inside **write**, ecx jumps *len_cheie* bytes at a time (to remain on the same column, but to iterate the lines) until on the last line
- copy only the right-most byte of the register value (to not overflow over other addresses) in *ebx* (which is incremented on every write operation)

</br>

## **Task no. 4**:

</br>

- stores the TAG in *esi* by doing two consecutive 3 bit shifts in the address (ab cd ef gh -> ab cd ef 00, something like this but in bits)
- stores the OFFSET in *edx* by substracting the TAG from the ADDRESS (00 00 00 gh)
- shifts *esi* right by 3 bits, to get the real TAG (00 ab cd ef)
- in **address_search** counters and address pointers are initialized
- in **cache_loop** the byte in question is queried. If not found, proceed to writing its line in **not_found**. If found, proceed to retrieving its content in **load_register**
- in **not_found** the preparations prior to the write operations are made: find head of line to write on, initialize counters, turn TAG to entry address (ab cd ef 00)
- in **write_line** the 8 bytes are written, one at a time (loop)
- in **reset_tag** the tag is brought back to its real shape (ab cd ef)
- jumps back to **address_search** where the byte is searched again (could've just remembered the value at write, i know)
- in **load_register** compute the address of the byte in question, retrieve its value and write it to the output register

</br>

_For more on how the operations work, check code comments._

