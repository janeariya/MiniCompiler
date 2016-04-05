%{
#include "parse.tab.h"
#include <string.h>
void yyerror ( char *); 
int yyparse ( void ); 
%}

%%
int														{	return INT; }
Show													{	return SHOW; }
if														{	return IF;	}
Loop													{	return LOOP;	}
to														{	return TO; }
SHOW													{	return SHOW; }
$[a-z]													{	
															yylval.dval = (int)yytext[1]-48;
															return ID;
														}
[0-9]+													{ 	
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
"+"														{ 	return '+'; }
"-"														{ 	return '-'; }
"%"														{	return '%'; }
"*"														{ 	return '*'; }
"/"														{ 	return '/'; }
">"														{	return '>'; }
"<"														{	return '<'; }
"=="													{	return EQUAL;	}
"="														{	return ASSIGN;	}	
"\n"													{	return END; }
"("														{	return '('; }
")"														{	return	')'; }
";"														{	return ';'; 	}
"#"														{	comment(); 		}
"{"														{	return '{';	}
"}"														{	return '}';		}
L?\"(\\.|[^\\"])*\"										{	
															char sub[128];
															substring(yytext,sub,2,strlen(yytext)-2);
															yylval.strval = sub;
															return STRING; 
														}
[ \t ' ' ]+ ;
. 														{	return ERROR;}
%%

void yyerror ( char * str ) { 
	printf (" ERROR : Could not parse !\n" );
}

int yywrap ( void ) { }

int main ( void ) {
			 printf("> "); 
			yyparse ();

}

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

void substring(char s[], char sub[], int p, int l) {
   int c = 0;
 
   while (c < l) {
      sub[c] = s[p+c-1];
      c++;
   }
   sub[c] = '\0';
}