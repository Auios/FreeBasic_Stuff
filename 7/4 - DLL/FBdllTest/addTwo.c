#include <stdlib.h>

int abc = 552;

typedef struct
{
	int ID;
	int x,y;
	char username[24];
} Player;

Player* playerStruct()
{
	Player *pl;
	pl = (Player *)malloc(sizeof(Player));
	return pl;
} 

int addTogether(int x, int y)
{
	return x+y;
}

int And(int x, int y)
{
	return x & y;
}

int increase(int x)
{
	return ++x;
}

int returnInput(int x)
{
	return x;
}