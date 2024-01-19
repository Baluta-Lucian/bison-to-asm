C:\Utilities\GnuWin32\bin\bison -d mlp_analyzer.y
C:\Utilities\GnuWin32\bin\flex mlp_scanner.l
gcc mlp_analyzer.tab.c lex.yy.c
cat $args[0] | .\a.exe