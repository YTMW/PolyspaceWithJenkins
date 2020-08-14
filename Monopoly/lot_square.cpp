//lot_square.cpp

#include <cstdlib>
#include <iostream>
#include <string>
#include "property_square.h"
#include "lot_square.h"

lot_square::lot_square(const std::string & a_square, int a_price, int a_rent) : property_square(a_square, a_price)
{
    set_rent(a_rent);
}

lot_square::~lot_square()
{
    std::cout << "The instance of lot_square : " << std::endl;
    output(); 
    std::cout << "is being deleted." << std::endl;
}

void lot_square::output() const
{
    property_square::output();
    std::cout << "Rent: " << get_rent() << std::endl;
}

int lot_square::get_rent() const
{
    return my_rent;
}

void lot_square::set_rent(int a_rent)
{
    if (a_rent < 0)
    {
        std::cerr << "ERROR: Invalid rent." << std::endl;
        std::exit(1);
    }
    my_rent = a_rent;
}

