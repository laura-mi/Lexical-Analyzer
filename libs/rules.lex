/* Sanner for the C++ language */
%{
   #include <math.h>
   #include <stdio.h>
   FILE *fp;
%}
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
comment ("//".*)|([/][*][^*]*[*]+([^*/][^*]*[*]+)*[/])

%%

{int_nr} {
			fprintf(fp,"An integer: %s (%d)\n", yytext,
			atoi( yytext ) );
}
{float_nr1}|{float_nr2} {
			fprintf(fp,"A float: %s (%f)\n", yytext,
			atoi( yytext ) );
}
{keyword} {
			fprintf(fp,"A keyword: %s\n", yytext );
}
{id} 		fprintf(fp,"An identifier: %s\n", yytext );
{ar_operators}|{logical_operators}|{bit_operators}|{rel_operators}|{oth_operators} {
			fprintf(fp,"An operator: %s\n", yytext );
}
{string}	fprintf(fp,"A string: %s\n", yytext);
{character} fprintf(fp,"A character %s\n", yytext);
{separator} fprintf(fp,"A separator %s\n", yytext);
{comment}	//fprintf(fp,"A comment %s\n",yytext);
[ \t\n]+ /* eat up whitespace */
. 			fprintf(fp,"Unrecognized character: %s\n", yytext );
%%

int main( int argc, char **argv )
{	
	++argv, --argc; /* skip over program name */
	
	fp = fopen("Output.txt", "w+");
    fprintf(fp, "The resulted tokens are:...\n");
	
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