// player.cpp

#include <stdio.h>
#include <cstdlib>
#include <iostream>
#include "player.h"
#include "square.h"
#include "die.h"

player::player(const std::string & a_name)
{
	set_name(a_name);
    set_my_square(NULL);
    set_cash(1500);
}

player::~player()
{
    /*
	std::cout
	<< "This instance of class player:"
	<< std::endl;
	output();
	std::cout
	<< "is being cleaned up."
	<< std::endl;
    */
}

void player::set_my_square (square* n_sq)
{
    my_square = n_sq;
}

square* player::get_my_square() const
{
    return my_square;
}


void player::set_name(const std::string & a_name)
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

const std::string & player::get_name() const
{
	return my_name;
}

void player::take_a_turn(die & d1, die & d2)
{
    if (&d1 == &d2)
    {
        std::cerr << "The second DIE is a copy of first DIE!" << std::endl;
        std::exit(1);
    }
    d1.roll();
    d2.roll();
    int rollSum(0);
    rollSum = d1.get_face_value() + d2.get_face_value();
    output();
    //std::cout << "Standing @ ->" <<std::endl;
    //get_my_square()->output();
    std::cout << "The sum of die rolls are: " << rollSum << std::endl;
    move(rollSum);
    output();
    //std::cout << " | Moving to ->" <<std::endl;
    //get_my_square()->output();
}


void player::move(int a_num_of_squares)
{
    int i_num(0);
    square* a_square(NULL);
    a_square = get_my_square();
    for (i_num=0; i_num < a_num_of_squares; i_num++)// notice the < as if 3 is rolled..1->2->3->4
    {
        if (a_square->get_next_square() == NULL)
        {
            a_square = NULL;
            break;
        } else
        {
            a_square = a_square->get_next_square();
            if (i_num < a_num_of_squares - 1)
            {
                a_square->passed_by(*this);
            }else // going into the i_num == a_num_of_squares - 1
            {
                a_square->landed_on_by(*this);
            }
        }
    }
    set_my_square(a_square);
}

void player::set_cash(int a_cash)
{
	if (a_cash < 0)
	{
		std::cerr
		<< "Invalid a_cash."
		<< std::endl;
		std::exit(1);
	}
	my_cash = a_cash;
}

int player::get_cash() const
{
	return my_cash;
}

void player::collect(int a_amount)
{
	if (a_amount <= 0)
	{
		std::cerr
		<< "Invalid a_amount."
		<< std::endl;
		std::exit(1);
	}
	set_cash(get_cash() + a_amount);
}

void player::output() const
{
	std::cout << "Player Name: " << get_name() << " | Standing @ ";
    
    if (get_my_square() == NULL)
    {
        std::cout << "I do not have a square location!" << std::endl;
    } else
    {
        get_my_square()->output();
    }
    std::cout << "Cash I have: $" << get_cash() << std::endl;
}
