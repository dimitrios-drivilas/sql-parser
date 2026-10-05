#ifndef MYSQLQ_TYPES_H
#define MYSQLQ_TYPES_H

typedef enum {
    DATA_INT,
    DATA_FLOAT,
    DATA_VARCHAR
} DataKind;

typedef struct {
    DataKind kind;
    long varchar_length;
} TypeSpec;

typedef struct {
    char *name;
    TypeSpec type;
    int line;
} ColumnDecl;

typedef struct {
    ColumnDecl **item;
    int count;
} ColumnDeclList;

typedef struct {
    char *name;
    int line;
} ColumnRef;

typedef struct {
    ColumnRef **item;
    int count;
} RefList;

#endif
