%option noyywrap yylineno nodefault noinput nounput caseless

%x COMMENT

%{
#include <stdlib.h>
#include <string.h>

#include "mysqlq.tab.h"
#include "source.h"

int scanner_last_token_line = 1;
static int comment_start_line = 1;

static char *copy_text(const char *text)
{
    char *copy = malloc(strlen(text) + 1);
    strcpy(copy, text);
    return copy;
}

static int token(int type)
{
    scanner_last_token_line = yylineno;
    return type;
}

#define YY_USER_ACTION yylloc.first_line = yylloc.last_line = yylineno;
%}

ID      [A-Za-z_][A-Za-z0-9_]*
INT     -?[0-9]+
FLOAT   -?[0-9]+\.[0-9]+
STRING  \'[^\'\n]*\'
SPACE   [ \t\r\f\v]+

%%

{SPACE}                         ;
\n                              ;
"--"[^\r\n]*                  ;

"/*"                            { comment_start_line = yylineno; BEGIN(COMMENT); }
<COMMENT>"*/"                   { BEGIN(INITIAL); }
<COMMENT>\n                     ;
<COMMENT>.                      ;
<COMMENT><<EOF>>                { diagnostic_fail(comment_start_line); }

"create"                        { return token(CREATE_KW); }
"table"                         { return token(TABLE_KW); }
"select"                        { return token(SELECT_KW); }
"from"                          { return token(FROM_KW); }
"where"                         { return token(WHERE_KW); }
"group"                         { return token(GROUP_KW); }
"order"                         { return token(ORDER_KW); }
"by"                            { return token(BY_KW); }
"limit"                         { return token(LIMIT_KW); }
"and"                           { return token(AND_KW); }
"or"                            { return token(OR_KW); }
"not"                           { return token(NOT_KW); }
"in"                            { return token(IN_KW); }
"int"                           { return token(INT_KW); }
"float"                         { return token(FLOAT_KW); }
"varchar"                       { return token(VARCHAR_KW); }

"!="                            { return token(NEQ); }
">="                            { return token(GTE); }
"<="                            { return token(LTE); }
"="                             { return token(EQ); }
">"                             { return token(GT); }
"<"                             { return token(LT); }
","                             { return token(COMMA); }
";"                             { return token(SEMICOLON); }
"("                             { return token(LPAREN); }
")"                             { return token(RPAREN); }
"*"                             { return token(STAR); }

{FLOAT}                         { yylval.text = copy_text(yytext); return token(FLOAT_LITERAL); }
{INT}                           { yylval.text = copy_text(yytext); return token(INT_LITERAL); }
{STRING}                        { yylval.text = copy_text(yytext); return token(STRING_LITERAL); }
{ID}                            { yylval.text = copy_text(yytext); return token(IDENTIFIER); }

.                               { diagnostic_fail(yylineno); }

%%
