#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main(int args, char **argv)
{

	char *a,fn[100];
	int i,j,k,l;

	FILE *infp,*outfp;

	outfp = fopen ("aspect.ah","w+") ;
	infp = fopen ("aspect/aspectSlice.ah","r") ;
	
	while(1)
	{
		char c = getc(infp);
		if(c==EOF)
			break;
		fprintf(outfp,"%c",c);
	}
		
	fclose(infp);
		
	infp = fopen("func_list.txt","r");
	fseek(infp,0,SEEK_SET);
		
	int seek_cnt = 0, var_cnt = 0, cnt = 0, flg = 0;
	char tmp[] = "main\n";
	while(!feof(infp))
	{
		char str[100];
		
		fgets(str,100,infp);
		
		if(str[0] >= 48 && str[0] <= 57)
		{
			cnt = atoi(str);
			flg++;
		}
		
		if(flg==1)
		{
			flg = 0;
			fgets(str,100,infp);
			
			if(!strcmp(str,tmp))
				continue;
			str[strlen(str)-1] = '\0';
			
			//before advice
			fprintf(outfp,"\tadvice execution(\"%% %s(...)\") : before()\n\t{\n\t\t",str);
			fprintf(outfp,"printf(\"\\nEntered function: %s()\\n\");\n\t\tFILE *fp;\n\t\tfp = fopen(\"/proc/func\",\"w+\");\n\t\tfprintf(fp,\"%%d\",getpid());\n\t\tfclose(fp);\n\t\t",str);
			fprintf(outfp,"cnt++;\n\t\tgettimeofday(&tim,NULL);\n\t\ttick1[cnt] = tim.tv_sec+(tim.tv_usec/1000000.0);\n\t\tt2_asp[cnt] = tick1[cnt];\n\t}\n\n");

			//after advice
			fprintf(outfp,"\tadvice execution(\"%% %s(...)\") : after()\n\t{\n\t\t",str);
			fprintf(outfp,"gettimeofday(&tim,NULL);\n\t\ttick2[cnt] = tim.tv_sec+(tim.tv_usec/1000000.0);\n\t\t");
			fprintf(outfp,"printf(\"Exits function: %s()\\n\");\n\t\tFILE *fp;\n\t\tfp = fopen(\"/proc/func\",\"w+\");\n\t\tfprintf(fp,\"%%d\",getpid());\n\t\tfclose(fp);\n\t\t",str);
			fprintf(outfp,"fp=fopen(\"func_analysis.txt\",\"a+\");\n\t\tfprintf(fp,\"\\n%s %%lf\",(tick2[cnt]-tick1[cnt]));\n\t\tfclose(fp);\n\t\t",str);
			fprintf(outfp,"printf(\"Execution time of %s() : %%lf\\n\",(tick2[cnt]-tick1[cnt]));\n\t\t",str);
			fprintf(outfp,"printf(\"Execution time of %s() with aspects : %%lf\\n\",(tick2[cnt]-t2_asp[cnt]));\n\t\tcnt--;\n\t}\n\n",str);
			/*fprintf(outfp,"printf(\"Aspects Overhead : %%lf\\n\",(tick1[cnt]-t2_asp[cnt]));\n\t\t",str);
			fprintf(outfp,"printf(\"Percentage Overhead : %%lf%\\n\",(tick1[cnt]-t2_asp[cnt])/(tick2[cnt]-t2_asp[cnt])*100);\n\t\tcnt--;\n\t}\n\n",str);*/
		}
	}
	
	fprintf(outfp,"\n\n};");
	fclose(infp);
	fclose(outfp);
}
