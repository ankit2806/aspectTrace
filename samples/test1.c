#include <stdio.h>
#include <stdlib.h>

void run(int* );
void stop(int* );

int main()
{
	int *a,i,j,k;
	
	i=0;
	a = (int *)malloc(10);
	a = (int *)malloc(5);
	free(a);
	
	run(&i);
	stop(&i);
	run(&i);
	run(&i);
	stop(&i);
	
	return 0;
}
