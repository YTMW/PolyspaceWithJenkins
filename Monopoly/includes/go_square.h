//go_square.h

#ifndef go_square_header
#define go_square_header

#include <string>
#include "square.h"
#include "player.h"

class go_square : public square
{
    public:
        go_square(const std::string & a_square);
        virtual ~go_square();

        virtual void output() const;

        virtual void passed_by(player & a_player);
        virtual void landed_on_by(player & a_lander);

    private:

};

#endif //go_square_header
