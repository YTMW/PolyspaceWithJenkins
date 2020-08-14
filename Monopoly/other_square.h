//other_square.h

#ifndef other_square_header
#define other_square_header

#include <string>
#include "square.h"

class other_square : public square
{
    public:
        other_square(const std::string & a_square);
        virtual ~other_square();

        virtual void output() const;

        virtual void landed_on_by(player & a_lander);
    private:

};

#endif //other_square_header
