// square.h

#ifndef square_header
#define square_header

#include <string>

//problem: cyclic dependencies with square.h and player.h
//this header inclusion - says you can know about all members along with class
//#include "player.h"

//resolve the issue: just mention player is a class
class player;

class square
{
public:
	square(const std::string & a_name);
	virtual ~square();
	void set_name(const std::string & a_name);
	const std::string & get_name() const;
	virtual void output() const;

    void set_next_square(square* next_square);
    square* get_next_square() const;

    virtual void passed_by(player & a_player);
    //landed_on_by is unique for everyone.
    virtual void landed_on_by(player & a_lander) = 0;

private:
	std::string my_name;
    square* next_square;
};

#endif
