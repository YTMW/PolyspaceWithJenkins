// board.cpp

#include <cstdlib>
#include <iostream>
#include "board.h"
#include "square.h"

#include "go_square.h"
#include "property_square.h"
#include "other_square.h"
#include "lot_square.h"
#include "railroad_square.h"
#include "utility_square.h"
/* test2 */
board::board()
{
    /*
    char *location[] = {"Go", "Mediterranean Avenue", "Community Chest",
        "Baltic Avenue", "Income Tax", "Reading Railroad", "Oriental Avenue",
        "Chance", "Vermont Avenue", "Connecticut Avenue", "Just Visiting/Jail",
        "St. Charles Place", "Electric Company", "States Avenue", 
        "Virginia Avenue", "Pennsylvania Railroad", "St. James Place", 
        "Community Chest", "Tennessee Avenue", "New York Avenue", "Free Parking",
        "Kentucky Avenue", "Chance", "Indiana Avenue", "Illinois Avenue", 
        "B & O Railroad", "Atlantic Avenue", "Ventnor Avenue", "Water Works",
        "Marvin Gardens", "Go To Jail!", "Pacific Avenue", 
        "North Carolina Avenue", "Community Chest", "Pennsylvania Avenue", 
        "Short Line Railroad", "Chance", "Park Place", "Luxury Tax", "Boardwalk"};
    */
    for (int i = 0; i < 40; i++)
    {
        set_square(i, NULL);
    }
    set_numberOfSquares(0);
    /*
	add_square(new square("Go"));
	add_square(new square("Mediterranean Avenue"));
	add_square(new square("Community Chest"));
	add_square(new square("Baltic Avenue"));
	add_square(new square("Income Tax"));
	add_square(new square("Reading Railroad"));
	add_square(new square("Oriental Avenue"));
	add_square(new square("Chance"));
	add_square(new square("Vermont Avenue"));
	add_square(new square("Connecticut Avenue"));
	add_square(new square("Just Visiting/Jail"));
	add_square(new square("St. Charles Place"));
	add_square(new square("Electric Company"));
	add_square(new square("States Avenue"));
	add_square(new square("Virginia Avenue"));
	add_square(new square("Pennsylvania Railroad"));
	add_square(new square("St. James Place"));
	add_square(new square("Community Chest"));
	add_square(new square("Tennessee Avenue"));
	add_square(new square("New York Avenue"));
	add_square(new square("Free Parking"));
	add_square(new square("Kentucky Avenue"));
	add_square(new square("Chance"));
	add_square(new square("Indiana Avenue"));
	add_square(new square("Illinois Avenue"));
	add_square(new square("B & O Railroad"));
	add_square(new square("Atlantic Avenue"));
	add_square(new square("Ventnor Avenue"));
	add_square(new square("Water Works"));
	add_square(new square("Marvin Gardens"));
	add_square(new square("Go To Jail!"));
	add_square(new square("Pacific Avenue"));
	add_square(new square("North Carolina Avenue"));
	add_square(new square("Community Chest"));
	add_square(new square("Pennsylvania Avenue"));
	add_square(new square("Short Line Railroad"));
	add_square(new square("Chance"));
	add_square(new square("Park Place"));
	add_square(new square("Luxury Tax"));
	add_square(new square("Boardwalk"));
    */

	add_square(new go_square("Go"));
	add_square(new lot_square("Mediterranean Avenue", 60, 2));
	add_square(new other_square("Community Chest"));
	add_square(new lot_square("Baltic Avenue", 60, 4));
	add_square(new other_square("Income Tax"));
	add_square(new railroad_square("Reading Railroad", 200));
	add_square(new lot_square("Oriental Avenue", 100, 6));
	add_square(new other_square("Chance"));
	add_square(new lot_square("Vermont Avenue", 100, 6));
	add_square(new lot_square("Connecticut Avenue", 120, 8));
	add_square(new other_square("Just Visiting"));
	add_square(new lot_square("St. Charles Place", 140, 10));
	add_square(new utility_square("Electric Company", 150));
	add_square(new lot_square("States Avenue", 140, 10));
	add_square(new lot_square("Virginia Avenue", 160, 12));
	add_square(new railroad_square("Pennsylvania Railroad", 200));
	add_square(new lot_square("St. James Place", 180, 14));
	add_square(new other_square("Community Chest"));
	add_square(new lot_square("Tennessee Avenue", 180, 14));
	add_square(new lot_square("New York Avenue", 200, 16));
	add_square(new other_square("Free Parking"));
	add_square(new lot_square("Kentucky Avenue", 220, 18));
	add_square(new other_square("Chance"));
	add_square(new lot_square("Indiana Avenue", 220, 18));
	add_square(new lot_square("Illinois Avenue", 240, 20));
	add_square(new railroad_square("B & O Railroad", 200));
	add_square(new lot_square("Atlantic Avenue", 260, 22));
	add_square(new lot_square("Ventnor Avenue", 260, 22));
	add_square(new utility_square("Water Works", 150));
	add_square(new lot_square("Marvin Gardens", 280, 24));
	add_square(new other_square("Go To Jail"));
	add_square(new lot_square("Pacific Avenue", 300, 26));
	add_square(new lot_square("North Carolina Avenue", 300, 26));
	add_square(new other_square("Community Chest"));
	add_square(new lot_square("Pennsylvania Avenue", 320, 28));
	add_square(new railroad_square("Short Line Railroad", 200));
	add_square(new other_square("Chance"));
	add_square(new lot_square("Park Place", 350, 35));
	add_square(new other_square("Luxury Tax"));
	add_square(new lot_square("Boardwalk", 400, 50));
    
    //assigning next Squares
    for (int i=0; i < get_numberOfSquares() - 1; i++)
    {
        get_square(i)->set_next_square(get_square(i+1));
    }
    get_square(get_numberOfSquares()-1)->set_next_square(get_square(0));
}

board::~board()
{
    /*
	std::cout
	<< "This instance of class board:"
	<< std::endl;
	output();
	std::cout
	<< "is being cleaned up."
	<< std::endl;
    */

    for (int count=get_numberOfSquares()-1; count >= 0; count--)
    {
        delete get_square(count);
        set_square(count, NULL);
    }
    set_numberOfSquares(0);
}

void board::output() const
{
}

void board::add_square(square *a_square)
{
    if (a_square == NULL)
    {
        std::cerr << "ERROR: Adding invalid square." << std::endl;
        std::exit(1);
    }
    if (get_numberOfSquares() == 40)
    {
        std::cerr << "ERROR: Number of squares reached its limit. Cannot add anymore." << std::endl;
        std::exit(1);
    }
    set_square(get_numberOfSquares(), a_square);
    set_numberOfSquares(get_numberOfSquares() + 1);
}

void board::set_square(int which, square * a_square)
{
    if (which < 0 || which >= 40)
    {
        std::cerr << "ERROR: Setting invalid square. The number of squares should be between 0-40. " << std::endl;
        std::exit(1);
    } else
    {
        boardSquares[which] = a_square;
    }
}

square * board::get_square(int which)
{
    if (which < 0 || which >= get_numberOfSquares())
    {
        std::cerr << "ERROR: Invalid query for square. The number of squares should be between 0-40. " << std::endl;
        std::exit(1);
    } else
    {
        return boardSquares[which];
    }
}

void board::set_numberOfSquares(int a_num)
{
    if (a_num < 0 || a_num > 40)
    {
        std::cerr << "ERROR: Invalid number of squares. The number of squares should be between 0-8. " << std::endl;
        std::exit(1);
    } else
    {
        numberOfSquaresInGame = a_num;
    }
}

int board::get_numberOfSquares() const
{
    return numberOfSquaresInGame;
}

square * board::get_starting_square()
{
    return get_square(0);
}
