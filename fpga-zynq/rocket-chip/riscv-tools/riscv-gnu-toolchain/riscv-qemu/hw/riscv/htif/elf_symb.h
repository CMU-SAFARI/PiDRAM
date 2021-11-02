/*
 * elf.h - A package for manipulating Elf binaries
 *
 * Taken from:
 * https://www.cs.cmu.edu/afs/cs.cmu.edu/academic/class/15213-f03/www/ftrace/
 * elf.h
 *
 */

#ifndef ELF_H
#define ELF_H

#include <stdint.h>
#include <elf.h>

/*
 * This is a handle that is created by elf_open and then used by every
 * other function in the elf package
*/
typedef struct {
    void *maddr;            /* Start of mapped Elf binary segment in memory */
    int mlen;               /* Length in bytes of the mapped Elf segment */
    Elf64_Ehdr *ehdr;       /* Start of main Elf header (same as maddr) */
    Elf64_Sym *symtab;      /* Start of symbol table */
    Elf64_Sym *symtab_end;  /* End of symbol table (symtab + size) */
    char *strtab;           /* Address of string table */
    Elf64_Sym *dsymtab;     /* Start of dynamic symbol table */
    Elf64_Sym *dsymtab_end; /* End of dynamic symbol table (dsymtab + size) */
    char *dstrtab;          /* Address of dynamic string table */
} Elf_obj;

typedef struct {
    void *maddr;            /* Start of mapped Elf binary segment in memory */
    int mlen;               /* Length in bytes of the mapped Elf segment */
    Elf32_Ehdr *ehdr;       /* Start of main Elf header (same as maddr) */
    Elf32_Sym *symtab;      /* Start of symbol table */
    Elf32_Sym *symtab_end;  /* End of symbol table (symtab + size) */
    char *strtab;           /* Address of string table */
    Elf32_Sym *dsymtab;     /* Start of dynamic symbol table */
    Elf32_Sym *dsymtab_end; /* End of dynamic symbol table (dsymtab + size) */
    char *dstrtab;          /* Address of dynamic string table */
} Elf_obj32;

/*
 * Create and destroy Elf object handles
 */
Elf_obj *elf_open(const char *filename);
Elf_obj32 *elf_open32(const char *filename);

void elf_close(Elf_obj *ep);

/*
 * Functions for manipulating static symbols
 */

/* Returns pointer to the first symbol */
Elf64_Sym *elf_firstsym(Elf_obj *ep);
Elf32_Sym *elf_firstsym32(Elf_obj32 *ep);

/* Returns pointer to the next symbol, or NULL if no more symbols */
Elf64_Sym *elf_nextsym(Elf_obj *ep, Elf64_Sym *sym);
Elf32_Sym *elf_nextsym32(Elf_obj32 *ep, Elf32_Sym *sym);

/* Return symbol string name */
char *elf_symname(Elf_obj *ep, Elf64_Sym *sym);
char *elf_symname32(Elf_obj32 *ep, Elf32_Sym *sym);

/* True if symbol is a function */
int elf_isfunc(Elf_obj *ep, Elf64_Sym *sym);

/*
 * Corresponding functions for manipulating dynamic symbols
 */
Elf64_Sym *elf_firstdsym(Elf_obj *ep);
Elf64_Sym *elf_nextdsym(Elf_obj *ep, Elf64_Sym *sym);
char *elf_dsymname(Elf_obj *ep, Elf64_Sym *sym);
int elf_isdfunc(Elf_obj *ep, Elf64_Sym *sym);


#endif
