D			[0-9]
L			[a-zA-Z_]
H			[a-fA-F0-9]
E			[Ee][+-]?{D}+
FS			(f|F|l|L)
IS			(u|U|l|L)*

%{
#include <stdio.h>
#include "y.tab.h"

void count();
%}

%%
"/*"			{ comment(); }
"//"			{ comment(); }
"#include <"{L}+".h>"	{ comment(); }
"#include<"{L}+".h>"	{ comment(); }

"auto"			{ count(); yylval.id = strdup(yytext); return(AUTO); }
"break"			{ count(); yylval.id = strdup(yytext); return(BREAK); }
"case"			{ count(); yylval.id = strdup(yytext); return(CASE); }
"char"			{ count(); yylval.id = strdup(yytext); return(CHAR); }
"const"			{ count(); yylval.id = strdup(yytext); return(CONST); }
"continue"		{ count(); yylval.id = strdup(yytext); return(CONTINUE); }
"default"		{ count(); yylval.id = strdup(yytext); return(DEFAULT); }
"do"			{ count(); yylval.id = strdup(yytext); return(DO); }
"double"		{ count(); yylval.id = strdup(yytext); return(DOUBLE); }
"else"			{ count(); yylval.id = strdup(yytext); return(ELSE); }
"enum"			{ count(); yylval.id = strdup(yytext); return(ENUM); }
"extern"		{ count(); yylval.id = strdup(yytext); return(EXTERN); }
"float"			{ count(); yylval.id = strdup(yytext); return(FLOAT); }
"for"			{ count(); yylval.id = strdup(yytext); return(FOR); }
"goto"			{ count(); yylval.id = strdup(yytext); return(GOTO); }
"if"			{ count(); yylval.id = strdup(yytext); return(IF); }
"int"			{ count(); yylval.id = strdup(yytext); return(INT); }
"long"			{ count(); yylval.id = strdup(yytext); return(LONG); }
"register"		{ count(); yylval.id = strdup(yytext); return(REGISTER); }
"return"		{ count(); yylval.id = strdup(yytext); return(RETURN); }
"short"			{ count(); yylval.id = strdup(yytext); return(SHORT); }
"signed"		{ count(); yylval.id = strdup(yytext); return(SIGNED); }
"sizeof"		{ count(); yylval.id = strdup(yytext); return(SIZEOF); }
"static"		{ count(); yylval.id = strdup(yytext); return(STATIC); }
"struct"		{ count(); yylval.id = strdup(yytext); return(STRUCT); }
"switch"		{ count(); yylval.id = strdup(yytext); return(SWITCH); }
"typedef"		{ count(); yylval.id = strdup(yytext); return(TYPEDEF); }
"union"			{ count(); yylval.id = strdup(yytext); return(UNION); }
"unsigned"		{ count(); yylval.id = strdup(yytext); return(UNSIGNED); }
"void"			{ count(); yylval.id = strdup(yytext); return(VOID); }
"volatile"		{ count(); yylval.id = strdup(yytext); return(VOLATILE); }
"while"			{ count(); yylval.id = strdup(yytext); return(WHILE); }

{L}({L}|{D})*		{ count(); yylval.id = strdup(yytext); return(IDENTIFIER); }

0[xX]{H}+{IS}?		{ count(); return(CONSTANT); }
0{D}+{IS}?		{ count(); return(CONSTANT); }
{D}+{IS}?		{ count(); return(CONSTANT); }
L?'(\\.|[^\\'])+'	{ count(); return(CONSTANT); }

{D}+{E}{FS}?		{ count(); return(CONSTANT); }
{D}*"."{D}+({E})?{FS}?	{ count(); return(CONSTANT); }
{D}+"."{D}*({E})?{FS}?	{ count(); return(CONSTANT); }

L?\"(\\.|[^\\"])*\"	{ count(); return(STRING_LITERAL); }

"..."			{ count(); yylval.id = strdup(yytext); return(ELLIPSIS); }
">>="			{ count(); yylval.id = strdup(yytext); return(RIGHT_ASSIGN); }
"<<="			{ count(); yylval.id = strdup(yytext); return(LEFT_ASSIGN); }
"+="			{ count(); yylval.id = strdup(yytext); return(ADD_ASSIGN); }
"-="			{ count(); yylval.id = strdup(yytext); return(SUB_ASSIGN); }
"*="			{ count(); yylval.id = strdup(yytext); return(MUL_ASSIGN); }
"/="			{ count(); yylval.id = strdup(yytext); return(DIV_ASSIGN); }
"%="			{ count(); yylval.id = strdup(yytext); return(MOD_ASSIGN); }
"&="			{ count(); yylval.id = strdup(yytext); return(AND_ASSIGN); }
"^="			{ count(); yylval.id = strdup(yytext); return(XOR_ASSIGN); }
"|="			{ count(); yylval.id = strdup(yytext); return(OR_ASSIGN); }
">>"			{ count(); yylval.id = strdup(yytext); return(RIGHT_OP); }
"<<"			{ count(); yylval.id = strdup(yytext); return(LEFT_OP); }
"++"			{ count(); yylval.id = strdup(yytext); return(INC_OP); }
"--"			{ count(); yylval.id = strdup(yytext); return(DEC_OP); }
"->"			{ count(); yylval.id = strdup(yytext); return(PTR_OP); }
"&&"			{ count(); yylval.id = strdup(yytext); return(AND_OP); }
"||"			{ count(); yylval.id = strdup(yytext); return(OR_OP); }
"<="			{ count(); yylval.id = strdup(yytext); return(LE_OP); }
">="			{ count(); yylval.id = strdup(yytext); return(GE_OP); }
"=="			{ count(); yylval.id = strdup(yytext); return(EQ_OP); }
"!="			{ count(); yylval.id = strdup(yytext); return(NE_OP); }
";"			{ count(); yylval.id = strdup(yytext); return(';'); }
("{"|"<%")		{ count(); yylval.id = strdup(yytext); return('{'); }
("}"|"%>")		{ count(); yylval.id = strdup(yytext); return('}'); }
","			{ count(); yylval.id = strdup(yytext); return(','); }
":"			{ count(); yylval.id = strdup(yytext); return(':'); }
"="			{ count(); yylval.id = strdup(yytext); return('='); }
"("			{ count(); yylval.id = strdup(yytext); return('('); }
")"			{ count(); yylval.id = strdup(yytext); return(')'); }
("["|"<:")		{ count(); yylval.id = strdup(yytext); return('['); }
("]"|":>")		{ count(); yylval.id = strdup(yytext); return(']'); }
"."			{ count(); yylval.id = strdup(yytext); return('.'); }
"&"			{ count(); yylval.id = strdup(yytext); return('&'); }
"!"			{ count(); yylval.id = strdup(yytext); return('!'); }
"~"			{ count(); yylval.id = strdup(yytext); return('~'); }
"-"			{ count(); yylval.id = strdup(yytext); return('-'); }
"+"			{ count(); yylval.id = strdup(yytext); return('+'); }
"*"			{ count(); yylval.id = strdup(yytext); return('*'); }
"/"			{ count(); yylval.id = strdup(yytext); return('/'); }
"%"			{ count(); yylval.id = strdup(yytext); return('%'); }
"<"			{ count(); yylval.id = strdup(yytext); return('<'); }
">"			{ count(); yylval.id = strdup(yytext); return('>'); }
"^"			{ count(); yylval.id = strdup(yytext); return('^'); }
"|"			{ count(); yylval.id = strdup(yytext); return('|'); }
"?"			{ count(); yylval.id = strdup(yytext); return('?'); }

[ \t\v\n\f]		{ count(); }


%%

int yywrap(void)
{
	return(1);
}


comment()
{
	char c, c1;
/*
loop:
	/while ((c = input()) > 0)
		putchar(c);

	if ((c1 = input()) != '/' && c != 0)
	{
		unput(c1);
		goto loop;
	}

	if (c > 0)
		putchar(c1);*/
}


int column = 0;

void count()
{
	int i;

	for (i = 0; yytext[i] != '\0'; i++)
		if (yytext[i] == '\n')
			column = 0;
		else if (yytext[i] == '\t')
			column += 8 - (column % 8);
		else
			column++;

	//ECHO;
}


int check_type()
{
/*
* pseudo code --- this is what it should check
*
*	if (yytext == type_name)
*		return(TYPE_NAME);
*
*	return(IDENTIFIER);
*/

/*
*	it actually will only return IDENTIFIER
*/

	return(IDENTIFIER);
}

