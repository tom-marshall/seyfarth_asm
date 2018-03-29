phony: sl

fa:
	yasm -f elf64 -g dwarf2 fillarrays.asm -l fillarrays.lst
	ld -o fillarrays fillarrays.o

t:
	yasm -f elf64 -g dwarf2 test.asm -l test.lst
	ld -o test test.o

1:
	yasm -f elf64 -g dwarf2 ex1.asm -l ex1.lst
	gcc -o ex1 ex1.o

3:
	yasm -f elf64 -g dwarf2 ex3.asm -l ex3.lst
	ld -o ex3 ex3.o

4:
	yasm -f elf64 -g dwarf2 ex4.asm -l ex4.lst
	ld -o ex4 ex4.o

pal:
	yasm -f elf64 -g dwarf2 palindrome.asm -l palindrome.lst
	ld -o palindrome palindrome.o

5:
	yasm -f elf64 -g dwarf2 ex5.asm -l ex5.lst
	gcc -o ex5 ex5.o

fn:
	yasm -f elf64 -g dwarf2 findnull.asm -l findnull.lst
	gcc -o findnull findnull.o

sl:
	yasm -f elf64 -g dwarf2 strlen.asm -l strlen.lst
	ld -o strlen strlen.o

