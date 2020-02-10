all:	lexer compiler

lexer:	lexer.l
				flex lexer.l

compiler:	lex.yy.c
					g++ checkdatatype.cpp lex.yy.c -o checkdatatype
