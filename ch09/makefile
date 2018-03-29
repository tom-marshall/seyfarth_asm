phony: 4

rt:
	yasm -f elf64 -g dwarf2 riptest.asm -l riptest.lst
	ld -o riptest riptest.o

pt:
	yasm -f elf64 -g dwarf2 pytharean-triples.asm -l pytharean-triples.lst
	gcc -o pytharean-triples pytharean-triples.o

1:
	yasm -f elf64 -g dwarf2 ex1.asm -l ex1.lst
	gcc -o ex1 ex1.o

3:
	yasm -f elf64 -g dwarf2 ex3.asm -l ex3.lst
	gcc -o ex3 ex3.o

4:
	yasm -f elf64 -g dwarf2 ex4.asm -l ex4.lst
	# gcc -o ex4 ex4.o
	gcc -no-pie -fno-pie -o ex4 ex4.o

7:
	yasm -f elf64 -g dwarf2 ex7.asm -l ex7.lst
	#gcc -o ex7 ex7.o
	gcc -no-pie -fno-pie -o ex4 ex4.o

