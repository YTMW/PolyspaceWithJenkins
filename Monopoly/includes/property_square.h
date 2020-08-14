
//property_square.h

#ifndef property_square_header
#define property_square_header

#include <string>
#include "square.h"
class player;

class property_square : public square
{
    public:
        property_square(const std::string & a_square, int a_price);
        virtual ~property_square();

        virtual void output() const;

        int get_price() const;
        virtual int get_rent() const = 0;
        virtual void landed_on_by(player & a_lander);

    private:
        int my_price;
        void set_price(int a_price);

};

#endif //property_square_header
