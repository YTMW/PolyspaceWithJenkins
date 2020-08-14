// board.h

#ifndef board_header
#define board_header

#include "square.h"

class board
{
public:
	board();
	~board();
	void output() const;

    void add_square(square *a_square);
    square * get_square(int which);
    int get_numberOfSquares() const;

    square * get_starting_square();
private:
    square *boardSquares[40];
    int numberOfSquaresInGame;

    void set_square(int which, square * a_square);
    void set_numberOfSquares(int a_num);
};

#endif
