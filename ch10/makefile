phony: 4

fill:
	yasm -f elf64 -g dwarf2 fillarray.asm -l fillarray.lst
	gcc -o fillarray fillarray.o

arr:
	yasm -f elf64 -g dwarf2 arrays.asm -l arrays.lst
	gcc -o arrays arrays.o

at:
	yasm -f elf64 -g dwarf2 argtest.asm -l argtest.lst
	gcc -o argtest argtest.o

1b:
	yasm -f elf64 -g dwarf2 ex1-bubble.asm
	gcc -o ex1-bubble ex1-bubble.o

1q:
	yasm -f elf64 -g dwarf2 ex1-qsort.asm
	#gcc -o ex1-qsort ex1-qsort.o
	gcc -no-pie -fno-pie -o ex1-qsort ex1-qsort.o

2:
	yasm -f elf64 -g dwarf2 ex2.asm -l ex2.lst
	#nasm -f elf64 -F dwarf -g ex2.asm
	gcc -o ex2 ex2.o

3:
	yasm -f elf64 -g dwarf2 ex3.asm -l ex3.lst
	#nasm -f elf64 -F dwarf -g ex2.asm
	gcc -o ex3 ex3.o

4:
	yasm -f elf64 -g dwarf2 ex4.asm -l ex4.lst
	#nasm -f elf64 -F dwarf -g ex2.asm
	gcc -o ex4 ex4.o

re:
	yasm -f elf64 -g dwarf2 readenv.asm 
	#gcc -o readenv readenv.o
	gcc -no-pie -fno-pie -o readenv readenv.o
