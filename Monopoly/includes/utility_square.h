//utility_square.h

#ifndef utility_square_header
#define utility_square_header

#include <string>
#include "property_square.h"

class utility_square : public property_square
{
    public:
        utility_square(const std::string & a_square, int a_price);
        virtual ~utility_square();

		virtual void output() const;

        virtual int get_rent() const;
    private:

};

#endif //utility_square_header


