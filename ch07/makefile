tst:
	yasm -f elf64 -g dwarf2 test.asm -l test.lst
	ld -o test test.o

lt:
	yasm -f elf64 -g dwarf2 labeltest.asm -l labeltest.lst
	ld -o labeltest labeltest.o

ex:
	yasm -f elf64 -g dwarf2 ex4.asm -l ex4.lst
	ld -o ex4 ex4.o

gcf:
	yasm -f elf64 -g dwarf2 -l gcf.lst gcf.asm
	ld -o gcf gcf.o

soe:
	yasm -f elf64 -g dwarf2 -l sieve_of_eratosthenes.lst sieve_of_eratosthenes.asm
	gcc -no-pie -fno-pie -o sieve_of_eratosthenes sieve_of_eratosthenes.o

bs:
	yasm -f elf64 -g dwarf2 -l bitstuff.lst bitstuff.asm
	ld bitstuff.o -o bitstuff
