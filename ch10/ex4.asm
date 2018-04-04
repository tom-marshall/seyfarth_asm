;
; Ex 4
;
; Write a test program t o evaluate how well the hashing function
; below works.
;
;   int multipliers[] = {
;       123456789,
;       234567891,
;       345678912,
;       456789123,
;       567891234,
;       678912345,
;       789123456,
;       891234567
;   };
;   
;   int hash (unsigned char *s)
;   {
;       unsigned long h = 0;
;       int i = 0;
;
;       while (s[i]) {
;           h + s[i] * multipliers[i % 8];
;           i++;
;       }
;
;       return h % 99991;
;   }
;
;
; Your test program should read a collection of strings using scan£
; with the format string "%79s" where you are reading into a charac­
; ter array of 80 bytes. Your program should read until scan£ fails
; to return 1 . As it reads each string it should call hash (written in
; assembly) to get a number h from 0 to 99990. It should increment
; location h of an array of integers of size 9999 1 . After entering all
; the data, this array contains a count of how many words mapped
; to a particular location in the array. What we want to know is how
; many of these array entries have 0 entries, how many have 1 entry,
; how many have 2 entries, etc. When multiple words map to the
; same location, it is called a "collision" . So the next step is to go
; through the array collision counts and increment another array by
; the index there. There should be no more than 1000 collisions, so
; this could be done using
;
;    for (i = 0; i < 99991; i++) {
;        k = collisions[i] ;
;        if (k > 999) k = 999;
;        count[k] ++;
;
; After the previous loop the count array has interesting data. Use a
; loop to step through this array and print the index and the value
; for all non-zero locations.
;
; An interesting file to test is "/usr /share/diet/words" .
;


section .rodata
    multipliers: dd 123456789, 234567891, 345678912, 456789123,
                 dd 567891234, 678912345, 789123456, 891234567


section .text
    global main

main:
    xor eax, eax
    ret

