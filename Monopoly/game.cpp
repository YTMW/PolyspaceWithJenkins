// game.cpp

#include <cstdlib>
#include <iostream>
#include "game.h"
#include "board.h"
#include "player.h"
#include "die.h"

game::game()
{
    set_board(new board());

    set_numberOfPlayers(0);
    for (int i=0; i < 8; i++)
    {
        set_player(i, NULL);
    }
    set_numberOfDies(0);
    for (int i=0; i < 2; i++)
    {
        set_die(i, NULL);
    }

    add_die(new die());
    add_die(new die());

}

game::~game()
{
    /*
    std::cout
	<< "This instance of class game:"
	<< std::endl;
	output();
	std::cout
	<< "is being cleaned up."
	<< std::endl;
    */

    for (int count = get_numberOfDies()-1; count >= 0; count --)
    {
        delete get_die(count);
        set_die(count, NULL);
    }
    set_numberOfDies(0);

    delete get_board();
    set_board(NULL);
}

void game::output() const
{
    if (get_board() == NULL)
    {
        std::cout << "ERROR: Board is NULL, i.e., there is no board associated to the game!" << std::endl;
        std::exit(1);
    }
    get_board()->output();
}

void game::add_die(die *a_die)
{
    if (a_die == NULL)
    {
        std::cerr << "ERROR: Adding invalid die." << std::endl;
        std::exit(1);
    }
    if (get_numberOfDies() == 2)
    {
        std::cerr << "ERROR: Number of dies reached its limit. Cannot add anymore." << std::endl;
        std::exit(1);
    }
    set_die(get_numberOfDies(), a_die);
    set_numberOfDies(get_numberOfDies() + 1);
}

void game::set_die(int which, die * a_die)
{
    if (which < 0 || which >= 2)
    {
        std::cerr << "ERROR: Setting invalid die. The number of die should be between 1-2. " << std::endl;
        std::exit(1);
    } else
    {
        gameDies[which] = a_die;
    }
}

die * game::get_die(int which) const
{
    if (which < 0 || which >= 2)
    {
        std::cerr << "ERROR: Invalid query for die. The number of dies should be between 1-2. " << std::endl;
        std::exit(1);
    } else
    {
        return gameDies[which];
    }
}

void game::set_numberOfDies(int a_num)
{
    if (a_num < 0 || a_num > 8)
    {
        std::cerr << "ERROR: Invalid number of Dies. The number of dies should be between 0-2. " << std::endl;
        std::exit(1);
    } else
    {
        numberOfDiesInGame = a_num;
    }
}

int game::get_numberOfDies() const
{
    return numberOfDiesInGame;
}

void game::add_player(player *a_player)
{
    if (a_player == NULL)
    {
        std::cerr << "ERROR: Adding invalid player." << std::endl;
        std::exit(1);
    }
    if (get_numberOfPlayers() == 8)
    {
        std::cerr << "ERROR: Number of players reached its limit. Cannot add anymore." << std::endl;
        std::exit(1);
    }
    set_player(get_numberOfPlayers(), a_player);
    set_numberOfPlayers(get_numberOfPlayers() + 1);

    //setting the player to the GO 
    a_player->set_my_square(get_board()->get_starting_square());
}

void game::set_player(int which, player * a_player)
{
    if (which < 0 || which >= 8)
    {
        std::cerr << "ERROR: Setting invalid player. The number of players should be between 0-8. " << std::endl;
        std::exit(1);
    } else
    {
        gamePlayers[which] = a_player;
    }
}

player * game::get_player(int which)
{
    if (which < 0 || which >= get_numberOfPlayers())
    {
        std::cerr << "ERROR: Invalid query for player. The number of players should be between 0-8. " << std::endl;
        std::exit(1);
    } else
    {
        return gamePlayers[which];
    }
}

void game::set_numberOfPlayers(int a_num)
{
    if (a_num < 0 || a_num > 8)
    {
        std::cerr << "ERROR: Invalid number of players. The number of players should be between 0-8. " << std::endl;
        std::exit(1);
    } else
    {
        numberOfPlayersInGame = a_num;
    }
}

int game::get_numberOfPlayers() const
{
    return numberOfPlayersInGame;
}

board* game::get_board() const
{
    return gameBoard;
}

void game::set_board(board* a_board)
{
    gameBoard = a_board;
}

void game::play_one_round()
{
    //check for null pointers for DIE here..
    for (int i = 0; i < get_numberOfPlayers(); i++)
    {
        //notice the *get_die (): because get_die returns a pointer
        //and take_a_turn accepts a reference die(not a pointer)
        get_player(i)->take_a_turn(* get_die(0), *get_die(1));
    }
}

void game::play()
{
    for (int i = 0; i < 50; i++)
    {
        std::cout << " --------------- Playing round " << i << "---------------" << std::endl;
        play_one_round();
    }
}
