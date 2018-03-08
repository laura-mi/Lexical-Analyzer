/* Sanner for the C++ language */
%{
   #include <math.h>
   #include <stdio.h>
   FILE *fp;
%}
%option yylineno
digit [0-9]
alpha [a-zA-Z]
id   [a-zA-Z_][a-zA-Z0-9_]*
keyword auto|double|int|struct|break|else|long|switch|case|enum|register|typedef|char|extern|return|union|const|float|short|unsigned|continue|for|signed|void|default|goto|sizeof|volatile|if|static|while|asm|bool|catch|class|const_cast|delete|dynamic_cast|explicit|export|false|friend|inline|mutable|namespace|new|operator|private|protected|public|reinterpret_cast|static_cast|template|this|throw|true|try|typeid|typename|using|virtual|wchar_t
string \"[^\n"]*\"
character ['].[']
int_nr {digit}+
float_nr1 {int_nr}\.?({int_nr})?([eE]([+-]?{int_nr}))?
float_nr2 \.?({int_nr})([eE]([+-]?{int_nr}))?
number {int_nr}|{float_nr1}|{float_nr2}
ar_operators "+"|"-"|"*"|"/"|"++"|"--"|"%"|"="|"+="|"-="|"*="|"/="|"%="|"++"|"--"
logical_operators "||"|"&&"|"!"|"!="|"|"|"&"|"^"
bit_operators "~"|">>"|"<<"
rel_operators "<"|">"|"<="|">="|"=="
oth_operators "typeof"|"sizeof"|"new"|"malloc"|"delete"|"type"|"."|"#"|"->"
separator ";"|":"|","|"("|")"|"["|"]"|"{"|"}"|"()"|"{}"|"[]"
comment1 "//".*
comment2 [/][*][^*]*[*]+([^*/][^*]*[*]+)*[/]
%%
{int_nr} {
			fprintf(fp,"Line %d: An integer: %s (%d)\n", yylineno, yytext,atoi( yytext ) );}
{float_nr1}|{float_nr2} {
			fprintf(fp,"Line %d: A float: %s (%f)\n", yylineno, yytext,atoi( yytext ) );}
{keyword} {
			fprintf(fp,"Line %d: A keyword: %s\n", yylineno, yytext);}
{id} 		fprintf(fp,"Line %d: An identifier: %s\n", yylineno, yytext );
{ar_operators}|{logical_operators}|{bit_operators}|{rel_operators}|{oth_operators} {
			fprintf(fp,"Line %d: An operator: %s\n", yylineno, yytext );}
{string}	fprintf(fp,"Line %d: A string: %s\n", yylineno, yytext);
{character} fprintf(fp,"Line %d: A character %s\n", yylineno, yytext);
{separator} fprintf(fp,"Line %d: A separator %s\n", yylineno, yytext);
{comment1}	fprintf(fp,"Line %d: A comment of one line: %s\n", yylineno, yytext);
{comment2}	{
				int lines = 1;	
				int length = strlen(yytext);								
				for(int i = 1;i<length;i++)
					if(yytext[i] == '\n') lines++;
				
				char* input= strtok(yytext,"\n");
				char* first_line = input;
				char* last_line;				
				
				while (input != NULL)
				  {					
					last_line = input;
					//lines++;
					input = strtok (NULL, "\n");
				  }			
						
				if(lines == 1)
					fprintf(fp,"Line %d: A comment of one line: %s\n", yylineno, yytext);
				else
				fprintf(fp,"Line %d: A comment of %d lines: First line: %s [...] Last line: %s\n", yylineno-lines+1,lines, first_line, last_line);		
}
[ \t\n]+ /* eat up whitespace */
. 			fprintf(fp,"Line %d: Unrecognized character: %s\n", yylineno, yytext );
%%

int main( int argc, char **argv )
{	
	++argv, --argc; /* skip over program name */
	
	fp = fopen("Output.txt", "w+");
    fprintf(fp, "The resulted tokens are:\n");
	
	if ( argc > 0 )
	yyin = fopen( argv[0], "r" );
	else
	yyin = stdin;
	yylex();
}

int yywrap()
{
	return(1);
}