// player.h

#ifndef player_header
#define player_header

#include <string>
//removing cyclic dependencies - check player.h
//#include "square.h"
class square;
#include "die.h"

class player
{
public:
	player(const std::string & a_name);
	~player();

	void set_name(const std::string & a_name);
	const std::string & get_name() const;
	
    void set_my_square(square * n_sq);
    square * get_my_square() const;

    void output() const;

    void move(int a_num_of_squares);
    void take_a_turn(die & d1, die & d2);

    void collect(int a_amount);

private:
	std::string my_name;
    square* my_square;

    int my_cash;
    void set_cash(int a_cash);
    int get_cash() const;
};

#endif
