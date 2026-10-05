#include "source.h"
#include <stdio.h>
#include <stdlib.h>

static const char *file_name;

void source_load(const char *name)
{
    file_name = name;
}

static void print_file(int stop_line)
{
    FILE *f = fopen(file_name, "r");
    int c, line = 1;

    while ((c = fgetc(f)) != EOF) {
        putchar(c);
        if (c == '\n') {
            if (stop_line > 0 && line == stop_line)
                break;
            line++;
        }
    }

    fclose(f);
}

void diagnostic_fail(int line)
{
    print_file(line);
    printf("\n[REJECTED] Error in line %d.\n", line);
    exit(1);
}

void diagnostic_success(void)
{
    print_file(0);
    printf("\n[ACCEPTED]\n");
}
