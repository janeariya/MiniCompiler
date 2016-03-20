%{
#include "biCal.tab.h"
#include <string.h>
void yyerror ( char *); // we need to forward declare these functions ,
int yyparse ( void ); // don ’t worry about them
%}

%%
int						{	return INT; }
char					{	return CHAR; }
string					{	return STRING; }
bool					{	return BOOL; }
Show					{	return SHOW; }
if						{	return IF;	}
Loop					{	return LOOP;	}
$[a-zA-Z][a-zA-Z0-9]+	{	yylval.id = *yytext;
							return ID; }	
[0-9]+					{ 	
							yylval.dval = atoi(yytext); 
							return NUM; 
						}
[0-1]([0-1])?([0-1])?([0-1])?b 	{	
							char *end;
							yylval.dval = strtol(yytext,&end,2);
							return NUM;	
						}
[0-9a-fA-F]([0-9a-fA-F])?([0-9a-fA-F])?([0-9a-fA-F])?h 	{	
															char *endx;
															yylval.dval = strtol(yytext,&endx,16);
															return NUM;	
														}
"+"						{ 	return '+'; 	}
"-"						{ 	return '-'; 	}
"%"						{	return '%'; 	}
"*"						{ 	return '*'; 	}
"/"						{ 	return '/'; 	}
">"						{	return '>'; 	}
"<"						{	return '<'; 	}
"=="					{	return "=="; 	}
"="						{	return "="; 	}
"\n"					{	return *yytext; }
"("						{	return '('; 	}
")"						{	return	')'; 	}
";"						{	return ';'; 	}
"#"						{	return COMMENT;	}
"{"						{	return START;	}
"}"						{	return END;		}
[ \t ' ' ]+ ;
. ; 
%%

void yyerror ( char * str ) { 
	printf (" ERROR : Could not parse !\n" );
}

int yywrap ( void ) { }

int main ( void ) {
		printf("> ");
		yyparse ();
}