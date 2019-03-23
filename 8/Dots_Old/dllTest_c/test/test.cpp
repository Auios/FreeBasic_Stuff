#include "stdio.h"

#define EXPORT __declspec(dllexport)

extern "C"
{
	struct EXPORT testStruct
	{
		int data;
	};

	EXPORT testStruct* modifyStruct(testStruct* test)
	{
		test->data = test->data * 2;
		return test;
	}

	EXPORT void sayHello()
	{
		printf("Hello!\n");
	}

	EXPORT int add(int a, int b)
	{
		return a + b;
	}
}

