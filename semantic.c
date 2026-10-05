#include "semantic.h"
#include "source.h"
#include <stdlib.h>
#include <string.h>

typedef struct {
    char *name;
    ColumnDeclList *columns;
} Table;

static Table *tables = NULL;
static int table_count = 0;
static int current_table = -1;

static int find_table(const char *name)
{
    int i;

    for (i = 0; i < table_count; i++)
        if (strcmp(tables[i].name, name) == 0)
            return i;

    return -1;
}

static int column_exists(int table, const char *name)
{
    int i;

    for (i = 0; i < tables[table].columns->count; i++)
        if (strcmp(tables[table].columns->item[i]->name, name) == 0)
            return 1;

    return 0;
}

void semantic_define_table(char *name, ColumnDeclList *columns, int line)
{
    int i, j;

    if (find_table(name) != -1)
        diagnostic_fail(line);

    for (i = 0; i < columns->count; i++)
        for (j = i + 1; j < columns->count; j++)
            if (strcmp(columns->item[i]->name, columns->item[j]->name) == 0)
                diagnostic_fail(columns->item[j]->line);

    tables = realloc(tables, (table_count + 1) * sizeof(Table));
    tables[table_count].name = name;
    tables[table_count].columns = columns;
    table_count++;
}

void semantic_begin_query(char *name, int line)
{
    current_table = find_table(name);
    free(name);

    if (current_table == -1)
        diagnostic_fail(line);
}

void semantic_validate_reference(const ColumnRef *ref)
{
    if (!column_exists(current_table, ref->name))
        diagnostic_fail(ref->line);
}

void semantic_validate_references(const RefList *list)
{
    int i;

    if (list == NULL)
        return;

    for (i = 0; i < list->count; i++)
        semantic_validate_reference(list->item[i]);
}
