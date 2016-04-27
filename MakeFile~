comp: parse.y lex.flex
	bison -d parse.y
	flex  lex.flex
	g++ parse.tab.c lex.yy.c -lfl -o out.comp -ggdb
clean:
	$(RM) parse.tab.c parse.tab.h lex.yy.c out.comp
