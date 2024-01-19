%{
#include "mlp_analyzer.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
%}

%option noyywrap
%option yylineno

IDENTIFIER   [a-zA-Z]{1,8}
INTREG  [-]?[1-9]*
ZERO "0"

%%
#include 	{ return INCLUDE; }
"<" 		{ return LT; }
">" 		{ return GT; }
iostream 	{ return IOSTREAM; }
using 		{ return USING; }
namespace 	{ return NAMESPACE; }
std 		{ return STD; }
int 		{ return INT; }		
main 		{ return MAIN; }
return 		{ return RETURN; }
cin  		{ return CIN; }
cout 		{ return COUT; }
">>" 		{ return SCIN; }
"<<" 		{ return SCOUT; }
endl 		{ return ENDL; }

{IDENTIFIER} { 
		strcpy(yylval.varname, yytext); 
		return ID; 
}

{ZERO} { 
		strcpy(yylval.varname, yytext); 
		return CONST; 
}

\- {
	strcpy(yylval.op, yytext);
	return OPERATOR;}
\+ { 
	strcpy(yylval.op, yytext);
	return OPERATOR;}
\* { 
	strcpy(yylval.op, yytext);
	return OPERATOR;}
\/ { 
	strcpy(yylval.op, yytext);
	return OPERATOR;}
\% { return MOD;}


INTREG { strcpy(yylval.varname, yytext); return CONST; }

"(" 	  	{ return SPARAN; }
")"		{ return EPARAN; }
"{" 	  	{ return SBRACE; }
"}"		{ return EBRACE; }
[=]       	{ return ASSIGN; }
";"		{ return SEMICOLON; }
","		{ return COMMA; }
"\n"      	{}
[ \t]     	{}
.         	{ return -1;}
%%