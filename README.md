# 🛡️ SQL Lex/Bison Parser & Compiler

A robust SQL lexer and syntactic/semantic parser implemented in C using **Flex** and **Bison**, developed as part of advanced compiler construction and database systems coursework.

## 🚀 Features

- **Lexical Analysis (Flex):** Tokenizes SQL queries, identifying keywords, identifiers, literals, and operators (`mysqlq.l`).
- **Syntax Analysis (Bison):** Implements a context-free grammar to parse SQL structures and build parse trees (`mysqlq.y`).
- **Semantic Analysis:** Validates type consistency, schema references, and expression semantics (`semantic.c`, `semantic.h`).
- **Test Suite:** Includes comprehensive test scripts with valid (`valid_*.sql`) and invalid (`invalid_*.sql`) SQL query samples for robust validation.

## 📂 Project Structure

```tree
├── mysqlq.l            # Flex lexer specification
├── mysqlq.y            # Bison parser grammar specification
├── semantic.c/.h       # Semantic analysis & type checking
├── source.c/.h         # Source file handling & helpers
├── mysqlq_types.h      # Data structures and AST definitions
├── valid_*.sql         # Positive test cases (valid SQL)
├── invalid_*.sql       # Negative test cases (syntax/semantic errors)
└── ANAFORA.docx        # Detailed technical report (Greek)
```

## 🛠️ Usage & Compilation

1. Generate lexer and parser:
   ```bash
   flex mysqlq.l
   bison -d mysqlq.y
   ```
2. Compile:
   ```bash
   gcc -o myParser lex.yy.c mysqlq.tab.c semantic.c source.c -lm
   ```
3. Run against test queries:
   ```bash
   ./myParser valid_01.sql
   ```
