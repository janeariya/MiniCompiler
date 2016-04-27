#!/bin/bash
bison -d parse.y
flex lex.flex
g++ lex.yy.c parse.tab.c stack.c queue.c ast.c asmGenerator.cpp -g -O1 -o parse
./parse