%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "parser.tab.h"

extern void addLexError(int, const char*);
int line = 1;
%}

%%

"//".* ;

"int"      { return INT; }
"float"    { return FLOAT; }
"char"     { return CHAR; }
"string"   { return STRING; }

"if"       { return IF; }
"else"     { return ELSE; }
"while"    { return WHILE; }
"for"      { return FOR; }


[0-9]*\.[0-9]*\.[0-9]*    { addLexError(line, "Malformed number"); }


[0-9]+\.[0-9]+            { yylval.str = strdup("float"); return NUMBER; }
[0-9]+                    { yylval.str = strdup("int"); return NUMBER; }


\"([^\"\n]*)$             { addLexError(line, "Unterminated string"); }
\"([^\"\n]*)\"            { yylval.str = strdup("string"); return STRING_LITERAL; }


\'([^\'\n]*)$             { addLexError(line, "Unterminated character"); }
\'([^\'\n])\'             { yylval.str = strdup("char"); return CHAR_LITERAL; }


[0-9][a-zA-Z_]+           { addLexError(line, "Invalid identifier"); }


[a-zA-Z_][a-zA-Z0-9_]* {
    yylval.str = strdup(yytext);
    return IDENTIFIER;
}


"=="|">="|"<="|"!="|">"|"<" { return RELOP; }

"+" { return PLUS; }
"-" { return MINUS; }
"*" { return MUL; }
"/" { return DIV; }
"=" { return ASSIGN; }


";" { return SEMI; }
"(" { return LPAREN; }
")" { return RPAREN; }
"{" { return LBRACE; }
"}" { return RBRACE; }


[ \t\r]+ ;
\n { line++; }


[^a-zA-Z0-9 \t\n\+\-\*/=;(){}<>!\"'] {
    addLexError(line, "Invalid character");
}

%%

int yywrap() { return 1; }
