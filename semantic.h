#ifndef SEMANTIC_H
#define SEMANTIC_H

#include "mysqlq_types.h"

void semantic_define_table(char *name, ColumnDeclList *columns, int line);
void semantic_begin_query(char *name, int line);
void semantic_validate_reference(const ColumnRef *ref);
void semantic_validate_references(const RefList *list);

#endif
