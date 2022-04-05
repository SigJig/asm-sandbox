
DEST = ./dest
CDEST = $(DEST)/c

all: C.o main

C.o: main.c
	gcc -S -O0 -o $(CDEST)/csource.s main.c

main: main.o
	ld -o $(DEST)/main $(DEST)/main.o

main.o: main.S
	nasm -f elf64 -g -F stabs main.S -l $(DEST)/main.lst -o $(DEST)/main.o

.PHONY: clean

clean:
	rm -rf $(DEST)/*.o $(DEST)/*.lst $(DEST)/main