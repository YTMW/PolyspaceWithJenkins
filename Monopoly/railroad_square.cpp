//railroad_square.cpp

#include <cstdlib>
#include <iostream>
#include <string>
#include "property_square.h"
#include "railroad_square.h"

railroad_square::railroad_square(const std::string & a_square, int a_price) : property_square(a_square, a_price)
{
}

railroad_square::~railroad_square()
{
    std::cout << "The instance of railroad_square : " << std::endl;
    output();
    std::cout << "is being deleted." << std::endl;
}

void railroad_square::output() const
{
}

int railroad_square::get_rent() const
{
   return 25; //flat rate rent
   std::cout << "Collecting rent from RailRoad." << std::endl;
}
