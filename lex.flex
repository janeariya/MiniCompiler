%{
#include "parse.tab.h"
#include <string.h>
void yyerror ( char *); 
int yyparse ( void ); 
%}

%%
Show													{	return SHOW; }
if														{	return IF;	}
Loop													{	return LOOP;	}
to														{	return TO; }
$[a-z]													{	
															yylval.chval = (char)yytext[1]-'a';
															return ID;
														}
[0-9]+													{ 	
															printf("%d\n",atoi(yytext));
															yylval.dval = atoi(yytext); 
															return NUM; 

														}
[0-1]([0-1])?([0-1])?([0-1])?b 							{	
															char *end;
															yylval.dval = strtol(yytext,&end,2);
															return NUM;	
														}

[0-9a-fA-F]([0-9a-fA-F])?([0-9a-fA-F])?([0-9a-fA-F])?h 	{	
															char *endx;
															yylval.dval = strtol(yytext,&endx,16);
															return NUM;	
														}
"+"														{ 	printf("+\n"); return '+'; }
"-"														{ 	return '-'; }
"%"														{	return '%'; }
"*"														{ 	return '*'; }
"/"														{ 	return '/'; }
"=="													{	return EQUAL;	}
"="														{	return ASSIGN;	}	
"\n"													{	return END; }
"("														{	return '('; }
")"														{	return	')'; }
";"														{	return ';'; 	}
"#"														{	comment(); 		}
"{"														{	return '{';	}
"}"														{	return '}';		}
[ \t ' ' ]+ ;
. 														{	return ERROR;}
%%

void yyerror ( char * str ) { 
	printf (" ERROR : Could not parse !%s\n",str );
}

int yywrap ( void ) { }


comment()
{
	char c, c1;

loop:
	while ((c = input()) != '\\' && c != 0);

	if ((c1 = input()) != 'n' && c != 0)
	{
		goto loop;
	}

}


