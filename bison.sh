#!/bin/bash
bison -d parse.y
flex lex.flex
g++ lex.yy.c parse.tab.c -lfl -o parse
./parse
gcc assCode.s -o test
./test
