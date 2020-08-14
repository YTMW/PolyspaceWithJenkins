//other_square.cpp

#include <cstdlib>
#include <iostream>
#include <string>
#include "other_square.h"

other_square::other_square(const std::string & a_square) : square(a_square)
{
}

other_square::~other_square()
{
    std::cout << "The instance of other_square : " << std::endl;
    output();
    std::cout << "is being deleted." << std::endl;
}

void other_square::output() const
{
}

void other_square::landed_on_by(player & a_lander)
{
}
