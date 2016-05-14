%{

#include <stdio.h>
#include <stdlib.h>

#define YY_DECL extern "C" int yylex()
enum {ID=300, NUM, SHOW, IF, LOOP,TO, EQUAL, ASSIGN, END, ERROR};
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
"=="													{	return EQUAL;	}
"="														{	return ASSIGN;	}	
"\n"													{	return END; 	}
"("														{	return '('; 	}
")"														{	return	')'; 	}
";"														{	return ';'; 	}
"#"														{	//comment(); 	}
"{"														{	return '{';		}
"}"														{	return '}';		}
[ \t ' ' ]+ ;
. 														{	return ERROR;	}
%%
