%option noyywrap

%%

[0-9]+         { printf("broj: %s\n", yytext); }
[+-]?[0-9]+    { printf("broj: %s\n", yytext); }
0[xX][0-9A-Fa-f]{1,4} { printf("heksa broj : %s\n", yytext); }
[+-]?[0-9]+"."[0-9]*  { printf("realni broj : %s\n", yytext); }

[bB][rR][eE][aA][kK]  { printf("kljucna rec : %s\n", yytext); }

"//".*

[0-9]+F  { printf("%d°C", ( (atoi(yytext) - 32) * 5/9 )); }


%%

int main() {
  yylex();
}
