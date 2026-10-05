%code requires {
#include "mysqlq_types.h"
}

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "semantic.h"
#include "source.h"

int yylex(void);
void yyerror(const char *message);

extern FILE *yyin;
extern int yylineno;
extern int scanner_last_token_line;


static ColumnDecl *column_decl_new(char *name, TypeSpec type, int line)
{
    ColumnDecl *column = malloc(sizeof(ColumnDecl));
    column->name = name;
    column->type = type;
    column->line = line;
    return column;
}

static ColumnDeclList *column_list_new(ColumnDecl *column)
{
    ColumnDeclList *list = malloc(sizeof(ColumnDeclList));
    list->item = malloc(sizeof(ColumnDecl *));
    list->item[0] = column;
    list->count = 1;
    return list;
}

static ColumnDeclList *column_list_append(ColumnDeclList *list, ColumnDecl *column)
{
    list->item = realloc(list->item, (list->count + 1) * sizeof(ColumnDecl *));
    list->item[list->count++] = column;
    return list;
}


static ColumnRef *column_ref_new(char *name, int line)
{
    ColumnRef *ref = malloc(sizeof(ColumnRef));
    ref->name = name;
    ref->line = line;
    return ref;
}

static void column_ref_free(ColumnRef *ref)
{
    free(ref->name);
    free(ref);
}

static RefList *ref_list_new(ColumnRef *ref)
{
    RefList *list = malloc(sizeof(RefList));
    list->item = malloc(sizeof(ColumnRef *));
    list->item[0] = ref;
    list->count = 1;
    return list;
}

static RefList *ref_list_append(RefList *list, ColumnRef *ref)
{
    list->item = realloc(list->item, (list->count + 1) * sizeof(ColumnRef *));
    list->item[list->count++] = ref;
    return list;
}

static void ref_list_free(RefList *list)
{
    int i;
    if (list == NULL)
        return;
    for (i = 0; i < list->count; i++)
        column_ref_free(list->item[i]);
    free(list->item);
    free(list);
}
%}

%define parse.error detailed
%locations

%union {
    char *text;
    TypeSpec type_spec;
    ColumnDecl *column_decl;
    ColumnDeclList *column_list;
    ColumnRef *column_ref;
    RefList *ref_list;
}

%token CREATE_KW "CREATE"
%token TABLE_KW "TABLE"
%token SELECT_KW "SELECT"
%token FROM_KW "FROM"
%token WHERE_KW "WHERE"
%token GROUP_KW "GROUP"
%token ORDER_KW "ORDER"
%token BY_KW "BY"
%token LIMIT_KW "LIMIT"
%token AND_KW "AND"
%token OR_KW "OR"
%token NOT_KW "NOT"
%token IN_KW "IN"
%token INT_KW "INT"
%token FLOAT_KW "FLOAT"
%token VARCHAR_KW "VARCHAR"

%token <text> IDENTIFIER "identifier"
%token <text> INT_LITERAL "integer literal"
%token <text> FLOAT_LITERAL "floating-point literal"
%token <text> STRING_LITERAL "string literal"

%token COMMA ","
%token SEMICOLON ";"
%token LPAREN "("
%token RPAREN ")"
%token STAR "*"
%token EQ "="
%token NEQ "!="
%token GT ">"
%token LT "<"
%token GTE ">="
%token LTE "<="

%type <column_list> column_declaration_list
%type <column_decl> column_declaration
%type <type_spec> type_specification
%type <ref_list> projection column_reference_list
%type <column_ref> column_reference


%start program

%%

program
    : statement_sequence
    ;

statement_sequence
    : statement
    | statement_sequence statement
    ;

statement
    : create_statement SEMICOLON
    | select_statement SEMICOLON
    ;

create_statement
    : CREATE_KW TABLE_KW IDENTIFIER LPAREN column_declaration_list RPAREN
      {
          semantic_define_table($3, $5, @3.first_line);
      }
    ;

column_declaration_list
    : column_declaration
      {
          $$ = column_list_new($1);
      }
    | column_declaration_list COMMA column_declaration
      {
          $$ = column_list_append($1, $3);
      }
    ;

column_declaration
    : IDENTIFIER type_specification
      {
          $$ = column_decl_new($1, $2, @1.first_line);
      }
    ;

type_specification
    : INT_KW
      {
          $$.kind = DATA_INT;
          $$.varchar_length = 0L;
      }
    | FLOAT_KW
      {
          $$.kind = DATA_FLOAT;
          $$.varchar_length = 0L;
      }
    | VARCHAR_KW LPAREN INT_LITERAL RPAREN
      {
          long length = atol($3);
          if (length <= 0)
              diagnostic_fail(@3.first_line);
          free($3);
          $$.kind = DATA_VARCHAR;
          $$.varchar_length = length;
      }
    ;

select_statement
    : SELECT_KW projection FROM_KW IDENTIFIER
      {
          semantic_begin_query($4, @4.first_line);
          semantic_validate_references($2);
          ref_list_free($2);
      }
      optional_where optional_group_by optional_order_by optional_limit
    ;

projection
    : STAR
      {
          $$ = NULL;
      }
    | column_reference_list
      {
          $$ = $1;
      }
    ;

column_reference_list
    : column_reference
      {
          $$ = ref_list_new($1);
      }
    | column_reference_list COMMA column_reference
      {
          $$ = ref_list_append($1, $3);
      }
    ;

column_reference
    : IDENTIFIER
      {
          $$ = column_ref_new($1, @1.first_line);
      }
    ;

optional_where
    : %empty
    | WHERE_KW boolean_expression
    ;

boolean_expression
    : or_expression
    ;

or_expression
    : and_expression
    | or_expression OR_KW and_expression
    ;

and_expression
    : negated_expression
    | and_expression AND_KW negated_expression
    ;

negated_expression
    : primary_expression
    | NOT_KW negated_expression
    ;

primary_expression
    : predicate
    | LPAREN boolean_expression RPAREN
    ;

predicate
    : column_reference comparison_operator literal
      {
          semantic_validate_reference($1);
          column_ref_free($1);
      }
    | column_reference IN_KW LPAREN literal_list RPAREN
      {
          semantic_validate_reference($1);
          column_ref_free($1);
      }
    | column_reference NOT_KW IN_KW LPAREN literal_list RPAREN
      {
          semantic_validate_reference($1);
          column_ref_free($1);
      }
    ;

comparison_operator
    : EQ
    | NEQ
    | GT
    | LT
    | GTE
    | LTE
    ;

literal
    : INT_LITERAL
      {
          free($1);
      }
    | FLOAT_LITERAL
      {
          free($1);
      }
    | STRING_LITERAL
      {
          free($1);
      }
    ;

literal_list
    : literal
    | literal_list COMMA literal
    ;

optional_group_by
    : %empty
    | GROUP_KW BY_KW column_reference_list
      {
          semantic_validate_references($3);
          ref_list_free($3);
      }
    ;

optional_order_by
    : %empty
    | ORDER_KW BY_KW column_reference_list
      {
          semantic_validate_references($3);
          ref_list_free($3);
      }
    ;

optional_limit
    : %empty
    | LIMIT_KW INT_LITERAL
      {
          if (atol($2) <= 0)
              diagnostic_fail(@2.first_line);
          free($2);
      }
    ;

%%

void yyerror(const char *message)
{
    int line = yylloc.last_line > 0 ? yylloc.last_line : (yylineno > 0 ? yylineno : 1);

    if (message != NULL && strstr(message, "end of file") != NULL) {
        line = scanner_last_token_line > 0 ? scanner_last_token_line : line;
        diagnostic_fail(line);
    }

    diagnostic_fail(line);
}

int main(int argc, char **argv)
{
    int parse_result;

    if (argc != 2) {
        fprintf(stderr, "Usage: %s file_name\n", argv[0]);
        return EXIT_FAILURE;
    }

    source_load(argv[1]);

    yyin = fopen(argv[1], "r");
    if (yyin == NULL) {
        fprintf(stderr, "Cannot open input file '%s'.\n", argv[1]);
        return EXIT_FAILURE;
    }

    yylineno = 1;
    parse_result = yyparse();
    fclose(yyin);
    yyin = NULL;

    if (parse_result != 0)
        return EXIT_FAILURE;

    diagnostic_success();
    return EXIT_SUCCESS;
}
