// die.cpp

#include <cstdlib>
#include <climits> // for INT_MAX
#include <iostream>
#include "die.h"

die::die()
{
	set_face_value(1);
}

die::~die()
{
    /*
	std::cout
	<< "This instance of class die:"
	<< std::endl;
	output();
	std::cout
	<< "is being cleaned up."
	<< std::endl;
    */
}

void die::roll()
{
    set_face_value(1 + rand()%6);
}

void die::set_face_value(int a_face_value)
{
	if (a_face_value < 1 || a_face_value > 6)
	{
		std::cerr
		<< "Invalid a_face_value."
		<< std::endl;
		std::exit(1);
	}
	my_face_value = a_face_value;
}

int die::get_face_value() const
{
	return my_face_value;
}

void die::output() const
{
	std::cout << get_face_value() << std::endl;
}
