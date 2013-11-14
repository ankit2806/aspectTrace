#!/bin/sh

./module/make_script				# genetares module

insmod module/prof.ko				# insert module

for i in $@					# get the command line arguments the target code to be profiled 
do
	array=("${array[@]}" $i)		# each .c file in the code is provided as argument to the script
done

flex parser/lexer.l				# lex.yy.c is generated

yacc -d parser/yacc.y				# y.tab.c and y.tab.h are generated

gcc lex.yy.c y.tab.c 				# lex.yy.c and y.tab.h are compiled and a.out is generated

./a.out ${array[@]}				# target code .c files are parsed and func_list.txt is genrated

gcc aspect/generateAspect.c -o gen		# generates aspect.ah with the help of func_list.txt

./gen

ag++ ${array[@]} -a aspect.ah			# target code and aspects are compiled

./a.out						# executes profiler

rm a.out gen y.tab.h y.tab.c lex.yy.c func_list.txt .tmp_mem .tmp_free func_analysis.txt aspect.ah

rmmod prof

cd module

make clean

cd ..
