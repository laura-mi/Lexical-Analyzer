REM Used in case of updates in the set of rules
REM It will create a file 'a.exe' or will replace the old one if it is created.
win_flex rules.lex
c:\mingw\bin\gcc lex.yy.c
