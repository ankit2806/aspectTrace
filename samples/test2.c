#include<stdio.h>
#include<stdlib.h>
#include <string.h>

void insert(int *,int,int);
void display(int *,int,int);
void prod(int *,int *,int *,int,int);

int main()
{
	int *a,*b,*c,row1,col1,row2,col2,displayed;
	char *ss;

	printf("Enter rows of 1st matrix");
	scanf("%d",&row1);
	printf("Enter columns of 1st matrix");
	scanf("%d",&col1);
	printf("Enter rows of 2nd matrix");
	scanf("%d",&row2);
	printf("Enter columns of 2nd matrix");
	scanf("%d",&col2);
	if(col1!=row2)
	{
		printf("\nInvalid Matrix sizes!!\n");
	}
	else
	{
		a = (int *) malloc((sizeof(int))*row1*col1 * 2);
		b = (int *) malloc((sizeof(int))*row2*col2 * 2);
		c = (int *) malloc((sizeof(int))*col1*row2 * 2);
		
		printf("enter 1st matrix \n");
		insert(a,row1,col1);

		printf("enter 2st matrix \n");
		insert(b,row2,col2);
		
		prod(a,b,c,row1,col2);
		
		free(a);
		free(b);
		display(c,row1,col2);
		//free(c);
	}
	return 0;
}

void insert(int *q,int r,int c)
{
	int i,j,displayed;
	for(i=0;i<r;i++)
	{
		for(j=0;j<c;j++)
		{ 
			printf("\nEnter [%d][%d] element-- ",i,j);
			scanf("%d",(q+i*c+j));
		}
	}

        printf(" matrix is\n");
	display(q,r,c);
}

void display(int *q,int r,int c)
{
	int i,j;
	int *d;
	d = (int*)malloc(sizeof(int)*40000);
	
	for(i=0;i<r;i++)
	{
		printf("\n");
		for(j=0;j<c;j++)
			printf("%d\t",*(q+r*j+i));
	}
	free(d);
	printf("\n");
}

void prod(int *p,int *q,int *z,int r1,int c2)
{
	int i,j,k;
	for(i=0;i<r1;i++)
	{
		for(j=0;j<c2;j++)
		{
			*(z+i*c2+j)=0;
			for(k=0;k<r1;k++)
			{
				*(z+i*c2+j)+=*(p+k*2+j)*(*(q+i*c2+k));
			}
		}
	}
}
