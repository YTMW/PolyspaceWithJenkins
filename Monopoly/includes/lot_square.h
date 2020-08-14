//lot_square.h

#ifndef lot_square_header
#define lot_square_header

#include <string>
#include "property_square.h"

class lot_square : public property_square
{
    public:
        lot_square(const std::string & a_square, int a_price, int a_rent);
        virtual ~lot_square();

        virtual void output() const;

        virtual int get_rent() const;

    private:
        int my_rent;

        void set_rent(int a_rent);

};

#endif //lot_square_header


