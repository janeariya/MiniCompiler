#!/bin/bash
bison -d parse.y
flex lex.flex
g++ lex.yy.c parse.tab.c -lfl -o parse
