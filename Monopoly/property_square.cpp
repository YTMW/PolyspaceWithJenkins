//property_square.cpp

//#include <stdio.h>
#include <cstdlib>
#include <iostream>
#include <string>
#include "player.h"
#include "property_square.h"

property_square::property_square(const std::string & a_square, int a_price) : square(a_square)
{
    set_price(a_price);
}

property_square::~property_square()
{
    std::cout << "The instance of property_square : " << std::endl;
    output();
    std::cout << "is being deleted." << std::endl;
}

void property_square::output() const
{
    square::output();
    std::cout << "Price : " << get_price() << std::endl;
}

void property_square::set_price(int a_price)
{
    if (a_price < 0)
    {
        std::cerr << "ERROR: Invalid price." << std::endl;
        std::exit(1);
    }
    my_price = a_price;
}

int property_square::get_price() const
{
    return my_price;
}
void property_square::landed_on_by(player & a_lander)
{
    a_lander.collect(this->get_rent());
    std::cout << "About to collect rent." << std::endl;
    //getchar();
}

