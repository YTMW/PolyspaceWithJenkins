// main.cpp

#include <iostream>
#include <stdio.h>
#include <cstdlib>
#include <time.h>
//#include "board.h"
//#include "die.h"
#include "game.h"
#include "player.h"
//#include "square.h"

int main()
{
    srand((unsigned)time(NULL));
	//board  a_board;

	//die    a_die_0;
	//die    a_die_1;

	game   a_game;

    //a_game.add_die(& a_die_0);
    //a_game.add_die(& a_die_1);



    //a_game.set_board(&a_board);


    // earlier I defined Square after players were defined.
    // Player -> destructure -> output -> standing square
    // By default the 'square destructure' was called before 'player destructure'
    // leading to a """"crash""""
    // hence moving the player definitions after squares.
	player a_player_0("Sand");
	player a_player_1("Vins");

    a_game.add_player(& a_player_0);
    a_game.add_player(& a_player_1);


    //a_player_0.take_a_turn(a_die_0, a_die_1);
    //a_player_1.take_a_turn(a_die_0, a_die_1);

    //a_game.play_one_round();
    a_game.play();

    
    std::cout << "\nGoing to run the destructures as exiting the main." << std::endl;
    //getchar();
    
	return 0;
}
