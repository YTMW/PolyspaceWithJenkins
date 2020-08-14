// square.cpp

#include <cstdlib>
#include <iostream>
#include "square.h"
#include "player.h"

square::square(const std::string & a_name)
{
	set_name(a_name);
    set_next_square(NULL);
}

void square::set_next_square(square* n_sq)
{
   next_square = n_sq;
}

square* square::get_next_square() const
{
    return next_square;
}

square::~square()
{
    /*
	std::cout
	<< "This instance of class square:"
	<< std::endl;
	output();
	std::cout
	<< "is being cleaned up."
	<< std::endl;
    */
}

void square::set_name(const std::string & a_name)
{
	if (a_name == "")
	{
		std::cerr
		<< "Invalid a_name."
		<< std::endl;
		std::exit(1);
	}
	my_name = a_name;
}

const std::string & square::get_name() const
{
	return my_name;
}

void square::output() const
{
	std::cout << get_name() << std::endl;
    /*
    if (get_next_square() == NULL)
    {
        std::cout << "I do not have a next square!" << std::
    } else
    {
        get_next_square()->output();
    }
    */
}

void square::passed_by(player & a_player)
{
    //std::cout << "Passed by ";
    //a_player.get_my_square()->output;
}

