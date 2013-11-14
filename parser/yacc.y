%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

int yydebug=1;

int cnt = 0;

FILE *fp;
	
%}

%union{
	char *id;
	int num;
	struct decl{
		char *c;
		char *typ;
		}myst;
}

%token <id> IDENTIFIER CONSTANT STRING_LITERAL SIZEOF
%token PTR_OP INC_OP DEC_OP LEFT_OP RIGHT_OP LE_OP GE_OP EQ_OP NE_OP
%token AND_OP OR_OP MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN
%token SUB_ASSIGN LEFT_ASSIGN RIGHT_ASSIGN AND_ASSIGN
%token XOR_ASSIGN OR_ASSIGN TYPE_NAME

%token TYPEDEF EXTERN STATIC AUTO REGISTER
%token <id> CHAR SHORT INT LONG SIGNED UNSIGNED FLOAT DOUBLE CONST VOLATILE VOID
%token STRUCT UNION ENUM ELLIPSIS

%token CASE DEFAULT IF ELSE SWITCH WHILE DO FOR GOTO CONTINUE BREAK RETURN

%type <myst> declarator direct_declarator declaration declaration_specifiers type_specifier declaration_list storage_class_specifier type_qualifier pointer type_qualifier_list

%start translation_unit
%%


primary_expression
	: IDENTIFIER
	| CONSTANT		
	| STRING_LITERAL
	| '(' expression ')'
	;

postfix_expression
	: primary_expression
	| postfix_expression '[' expression ']'
	| postfix_expression '(' ')'
	| postfix_expression '(' argument_expression_list ')'
	| postfix_expression '.' IDENTIFIER
	| postfix_expression PTR_OP IDENTIFIER
	| postfix_expression INC_OP
	| postfix_expression DEC_OP
	;

argument_expression_list
	: assignment_expression
	| argument_expression_list ',' assignment_expression
	;

unary_expression
	: postfix_expression
	| INC_OP unary_expression
	| DEC_OP unary_expression
	| unary_operator cast_expression
	| SIZEOF unary_expression
	| SIZEOF '(' type_name ')'
	;

unary_operator
	: '&'
	| '*'
	| '+'
	| '-'
	| '~'
	| '!'
	;

cast_expression
	: unary_expression
	| '(' type_name ')' cast_expression
	;

multiplicative_expression
	: cast_expression
	| multiplicative_expression '*' cast_expression
	| multiplicative_expression '/' cast_expression
	| multiplicative_expression '%' cast_expression
	;

additive_expression
	: multiplicative_expression
	| additive_expression '+' multiplicative_expression
	| additive_expression '-' multiplicative_expression
	;

shift_expression
	: additive_expression
	| shift_expression LEFT_OP additive_expression
	| shift_expression RIGHT_OP additive_expression
	;

relational_expression
	: shift_expression
	| relational_expression '<' shift_expression
	| relational_expression '>' shift_expression
	| relational_expression LE_OP shift_expression
	| relational_expression GE_OP shift_expression
	;

equality_expression
	: relational_expression
	| equality_expression EQ_OP relational_expression
	| equality_expression NE_OP relational_expression
	;

and_expression
	: equality_expression
	| and_expression '&' equality_expression
	;

exclusive_or_expression
	: and_expression
	| exclusive_or_expression '^' and_expression
	;

inclusive_or_expression
	: exclusive_or_expression
	| inclusive_or_expression '|' exclusive_or_expression
	;

logical_and_expression
	: inclusive_or_expression
	| logical_and_expression AND_OP inclusive_or_expression
	;

logical_or_expression
	: logical_and_expression
	| logical_or_expression OR_OP logical_and_expression
	;

conditional_expression
	: logical_or_expression
	| logical_or_expression '?' expression ':' conditional_expression
	;

assignment_expression
	: conditional_expression
	| unary_expression assignment_operator assignment_expression
	;

assignment_operator
	: '='
	| MUL_ASSIGN
	| DIV_ASSIGN
	| MOD_ASSIGN
	| ADD_ASSIGN
	| SUB_ASSIGN
	| LEFT_ASSIGN
	| RIGHT_ASSIGN
	| AND_ASSIGN
	| XOR_ASSIGN
	| OR_ASSIGN
	;

expression
	: assignment_expression
	| expression ',' assignment_expression
	;

constant_expression
	: conditional_expression
	;

declaration
	: declaration_specifiers ';'				{ $$.c = $1.c; }
	| declaration_specifiers init_declarator_list ';'	{ $$.c = $1.c; }
	;

declaration_specifiers
	: storage_class_specifier				{ $$.c = $1.c; }
	| storage_class_specifier declaration_specifiers	{ $$.c = $1.c; }
	| type_specifier					{ $$.c = $1.c; }
	| type_specifier declaration_specifiers			{ $$.c = $1.c; }
	| type_qualifier					{ $$.c = $1.c; }
	| type_qualifier declaration_specifiers			{ $$.c = $1.c; }
	;

init_declarator_list
	: init_declarator
	| init_declarator_list ',' init_declarator
	;

init_declarator
	: declarator
	| declarator '=' initializer
	;

storage_class_specifier
	: TYPEDEF				{$$.c = $<id>1;}	
	| EXTERN				{$$.c = $<id>1;}
	| STATIC				{$$.c = $<id>1;}
	| AUTO					{$$.c = $<id>1;}
	| REGISTER				{$$.c = $<id>1;}
	;

type_specifier
	: VOID				{$$.c = $<id>1;}
	| CHAR				{$$.c = $<id>1;}
	| SHORT				{$$.c = $<id>1;}
	| INT				{$$.c = $<id>1;}
	| LONG				{$$.c = $<id>1;}
	| FLOAT				{$$.c = $<id>1;}
	| DOUBLE			{$$.c = $<id>1;}
	| SIGNED			{$$.c = $<id>1;}
	| UNSIGNED			{$$.c = $<id>1;}
	| struct_or_union_specifier	{$$.c = $<id>1;}
	| enum_specifier		{$$.c = $<id>1;}
	| TYPE_NAME			{$$.c = $<id>1;}
	;

struct_or_union_specifier
	: struct_or_union IDENTIFIER '{' struct_declaration_list '}'
	| struct_or_union '{' struct_declaration_list '}'
	| struct_or_union IDENTIFIER
	;

struct_or_union
	: STRUCT
	| UNION
	;

struct_declaration_list
	: struct_declaration
	| struct_declaration_list struct_declaration
	;

struct_declaration
	: specifier_qualifier_list struct_declarator_list ';'
	;

specifier_qualifier_list
	: type_specifier specifier_qualifier_list
	| type_specifier
	| type_qualifier specifier_qualifier_list
	| type_qualifier
	;

struct_declarator_list
	: struct_declarator
	| struct_declarator_list ',' struct_declarator
	;

struct_declarator
	: declarator
	| ':' constant_expression
	| declarator ':' constant_expression
	;

enum_specifier
	: ENUM '{' enumerator_list '}'
	| ENUM IDENTIFIER '{' enumerator_list '}'
	| ENUM IDENTIFIER
	;

enumerator_list
	: enumerator
	| enumerator_list ',' enumerator
	;

enumerator
	: IDENTIFIER
	| IDENTIFIER '=' constant_expression
	;

type_qualifier
	: CONST					{ $$.c = $<id>1; }
	| VOLATILE				{ $$.c = $<id>1; }
	;

declarator
	: pointer direct_declarator		{$$.c = $2.c;}
	| direct_declarator			{$$.c = $1.c;}
	;

direct_declarator
	: IDENTIFIER				{ $$.c = $<id>1;}//printf("declarator=====%s\n",$<id>1);}
	| '(' declarator ')'			{$$.c = $2.c;}
	| direct_declarator '[' constant_expression ']'
	| direct_declarator '[' ']'
	| direct_declarator '(' parameter_type_list ')'
	| direct_declarator '(' identifier_list ')'
	| direct_declarator '(' ')'
	;

pointer
	: '*'					{ $$.c = "*"; }
	| '*' type_qualifier_list		{ $$.c = "*"; }
	| '*' pointer				{ $$.c = "*"; }
	| '*' type_qualifier_list pointer	{ $$.c = "*"; }
	;

type_qualifier_list
	: type_qualifier			{ $$.c = $1.c; }
	| type_qualifier_list type_qualifier	{ $$.c = $2.c; }
	;


parameter_type_list
	: parameter_list
	| parameter_list ',' ELLIPSIS
	;

parameter_list
	: parameter_declaration
	| parameter_list ',' parameter_declaration
	;

parameter_declaration
	: declaration_specifiers declarator		{ fprintf(fp,"%s %s\n",$1.c,$2.c); cnt++; }
	| declaration_specifiers abstract_declarator
	| declaration_specifiers
	;

identifier_list
	: IDENTIFIER
	| identifier_list ',' IDENTIFIER
	;

type_name
	: specifier_qualifier_list
	| specifier_qualifier_list abstract_declarator
	;

abstract_declarator
	: pointer
	| direct_abstract_declarator
	| pointer direct_abstract_declarator
	;

direct_abstract_declarator
	: '(' abstract_declarator ')' 			
	| '[' ']'
	| '[' constant_expression ']'
	| direct_abstract_declarator '[' ']'
	| direct_abstract_declarator '[' constant_expression ']'
	| '(' ')'
	| '(' parameter_type_list ')'
	| direct_abstract_declarator '(' ')'
	| direct_abstract_declarator '(' parameter_type_list ')'
	;

initializer
	: assignment_expression
	| '{' initializer_list '}'
	| '{' initializer_list ',' '}'
	;

initializer_list
	: initializer
	| initializer_list ',' initializer
	;

statement
	: labeled_statement
	| compound_statement
	| expression_statement
	| selection_statement
	| iteration_statement
	| jump_statement
	;

labeled_statement
	: IDENTIFIER ':' statement
	| CASE constant_expression ':' statement
	| DEFAULT ':' statement
	;

compound_statement
	: '{' '}'
	| '{' statement_list '}'
	| '{' declaration_list '}'
	| '{' declaration_list statement_list '}'
	;

declaration_list
	: declaration				{ $$.c = $1.c; }
	| declaration_list declaration
	;

statement_list
	: statement
	| statement_list statement
	;

expression_statement
	: ';'
	| expression ';'
	;

selection_statement
	: IF '(' expression ')' statement
	| IF '(' expression ')' statement ELSE statement
	| SWITCH '(' expression ')' statement
	;

iteration_statement
	: WHILE '(' expression ')' statement
	| DO statement WHILE '(' expression ')' ';'
	| FOR '(' expression_statement expression_statement ')' statement
	| FOR '(' expression_statement expression_statement expression ')' statement
	;

jump_statement
	: GOTO IDENTIFIER ';'
	| CONTINUE ';'
	| BREAK ';'
	| RETURN ';'
	| RETURN expression ';'
	;

translation_unit
	: external_declaration				
	| translation_unit external_declaration		
	;

external_declaration
	: function_definition
	| declaration
	;

function_definition
	: declaration_specifiers declarator declaration_list compound_statement		//{printf("decl======%s\n",$2.c);}
	| declaration_specifiers declarator compound_statement			{/*printf("decl111======%s   ksdj====%s\n",$2.c,$1.c);*/ fprintf(fp,"%d\n%s\n",cnt,$2.c); cnt = 0;}
	| declarator declaration_list compound_statement			{/*printf("decl222======%s\n",$1.c);*/fprintf(fp,"%s\n",$1.c);cnt = 0;}
	| declarator compound_statement
	;

%%
#include <stdio.h>
#include <stdlib.h>

extern char* yytext[];
extern int column;

void yyerror(char *s)
{
	printf("\n%*s\n%*s\n", column, "^", column, s);
	return;
}

void main(int argc, char **argv)
{
	extern FILE *yyin;
	fp = fopen("func_list.txt","w+");
	
	int i;
	for(i=1;i<argc;i++)
	{
		yyin = fopen(argv[i],"r");
		yyparse();
	}

	fclose(fp);
	return;
}
