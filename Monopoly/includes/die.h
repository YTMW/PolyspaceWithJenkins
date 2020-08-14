// die.h

#ifndef die_header
#define die_header

class die
{
public:
	die();
	~die();
	
    void set_face_value(int a_face_value);
	int get_face_value() const;

	void output() const;
    void roll();

private:
	int my_face_value;
};

#endif
