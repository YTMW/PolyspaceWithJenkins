CC=g++
CPPFLAGS=-I ./includes
LDFLAGS=

OBJ=main.o board.o die.o \
	game.o player.o square.o go_square.o \
	property_square.o other_square.o \
	lot_square.o railroad_square.o \
	utility_square.o

all: $(OBJ)
	$(CC) $(CPPFLAGS) -o monopoly.exe $^  $(LDFLAGS)

%.o: %.cpp
	$(CC) -o $@ -c $< $(CPPFLAGS)
	
	
.PHONY: clean

clean:
	rm -f *.o monopoly.exe 
