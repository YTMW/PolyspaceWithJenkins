//utility_square.cpp

#include <cstdlib>
#include <iostream>
#include <string>
#include "die.h"
#include "property_square.h"
#include "utility_square.h"

utility_square::utility_square(const std::string & a_square, int a_price) : property_square(a_square, a_price)
{
}

utility_square::~utility_square()
{
    std::cout << "The instance of utility_square : " << std::endl;
    output();
    std::cout << "is being deleted." << std::endl;
}

void utility_square::output() const
{
}

int utility_square::get_rent() const
{
    int a_rent;

    die d1;
    die d2;


	if (&d1 == &d2)  
    {
        std::cerr << "The second DIE is a copy of first DIE!" << std::endl;
        std::exit(1);
    }
    d1.roll();
    d2.roll();
    int rollSum(0);
    rollSum = d1.get_face_value() + d2.get_face_value();

    a_rent = rollSum * 4;
    return a_rent;
}
