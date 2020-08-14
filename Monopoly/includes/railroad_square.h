//railroad_square.h

#ifndef railroad_square_header
#define railroad_square_header

#include <string>
#include "property_square.h"

class railroad_square : public property_square
{
    public:
        railroad_square(const std::string & a_square, int a_price);
        virtual ~railroad_square();

        virtual void output() const;
        virtual int get_rent() const;

    private:

};

#endif //railroad_square_header


