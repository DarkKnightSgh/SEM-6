compiler: y.tab.c lex.yy.c
	gcc y.tab.c lex.yy.c -o compiler
y.tab.c: parser.y
	yacc -dy parser.y -Wno
lex.yy.c: lexer.l y.tab.h
	flex lexer.l
output: compiler
	./compiler < input1.c > output1.txt
	./compiler < input2.c > output2.txt
	./compiler < input3.c > output3.txt
	./compiler < input4.c > output4.txt
	./compiler < input5.c > output5.txt
	./compiler < input6.c > output6.txt

clean:
	rm -f compiler y.tab.c y.tab.h lex.yy.c output*.txt