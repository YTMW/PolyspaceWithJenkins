// game.h

#ifndef game_header
#define game_header

#include "board.h"
#include "player.h"
#include "die.h"

class game
{
public:
	game();
	~game();
	void output() const;

    void set_board(board* a_board);
    board* get_board() const;

    void add_die(die *a_die);
    int get_numberOfDies() const;
    die * get_die(int which) const;

    void add_player(player *a_player);
    player * get_player(int which);
    int get_numberOfPlayers() const;
    
    void play();

private:
    //data members
    board * gameBoard;

    player * gamePlayers[8];
    int numberOfPlayersInGame;
    
    die *gameDies[2];
    int numberOfDiesInGame;

    //private functions
    void play_one_round();

    void set_player(int which, player * a_player);
    void set_numberOfPlayers(int a_num);

    void set_die(int which, die * a_die);
    void set_numberOfDies(int a_num);
};

#endif
