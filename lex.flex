%{
#include "parse.tab.h"
#include <iostream>
#include <cstdio>
using namespace std;
#define YY_DECL extern "C" int yylex()

void comment(void);

%}

%%
Show													{	return SHOW; 	}
if														{	return IF;		}
Loop													{	return LOOP;	}
to														{	return TO; 		}
$[a-z]													{	
															yylval.chval = (int)yytext[1]-'a'+1;
															return ID;
														}
[0-9]+													{ 	
															yylval.dval = atoi(yytext); 
															return NUM; 

														}
[0-1]+b 							{	
															char *end;
															yylval.dval = strtol(yytext,&end,2);
															return NUM;	
														}

[0-9a-fA-F]+h 											{	
															char *endx;
															yylval.dval = strtol(yytext,&endx,16);
															return NUM;	
														}
"+"														{ 	return '+'; }
"-"														{ 	return '-'; }
"%"														{	return '%'; }
"*"														{ 	return '*'; }
"/"														{ 	return '/'; }
"=="													{	return EQUAL;	}
"="														{	return ASSIGN;	}
":"														{	return ':'; }
"\n"													{	return END; 	}
"("														{	return '('; 	}
")"														{	return	')'; 	}
";"														{	return ';'; 	}
"#"														{	comment();		}
"{"														{	return '{';		}
"}"														{	return '}';		}
\"[a-zA-z_0-9]+\"									{	
															yylval.strval = yytext;
															return STRING;	
														}
[ \t ' ' ]+ ;
.
%%

int yywrap ( void ) { }

void comment(void){
 	char c, c1;
 
 loop:
 	while ((c = yyinput()) != '\\' && c != 0);
 
 	if ((c1 = yyinput()) != 'n' && c1 != 0)
 	{
 		goto loop;
 	}
 
} 