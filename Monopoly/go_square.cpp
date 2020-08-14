//go_square.cpp

#include <iostream>
#include <cstdlib>
#include "go_square.h"
#include "player.h"

go_square::go_square(const std::string & a_square) : square(a_square)
{
}

go_square::~go_square()
{
    std::cout << "The instance of go_square : " <<std::endl;
    output();
    std::cout << "is being deleted." << std::endl;
}

void go_square::output() const
{

}

void go_square::passed_by(player & a_player)
{
    std::cout << "Passing GO - Collecting money." << std::endl;
    a_player.collect(200);
}

void go_square::landed_on_by(player & a_lander)
{
    std::cout << "Landed on GO - Collecting money." << std::endl;
    a_lander.collect(200);
}

