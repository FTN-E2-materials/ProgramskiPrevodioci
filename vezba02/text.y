%{
  #include <stdio.h>
  int yylex(void);
  int yyparse(void);
  int yyerror(char *);
  extern int yylineno;
  int brojacObavestajnih = 0;
  int brojacUzvicnih = 0;
  int brojacUpitnih = 0;
  int brojacPasusa = 0;
%}

%token  DOT
%token  CAPITAL_WORD
%token  WORD
%token UPITNIK
%token UZVICNIK
%token ZAREZ
%token NW

%%



text 
  : pasus NW {brojacPasusa++;}
  | text pasus NW {brojacPasusa++;}
  | NW
  ;

pasus
  : sentence 
  | pasus sentence
  ;

sentence 
  : words DOT {brojacObavestajnih++;}
  | words UPITNIK {brojacUpitnih++;}
  | words UZVICNIK {brojacUzvicnih++;}
  ;

words 
  : CAPITAL_WORD
  | words WORD
  | words CAPITAL_WORD
  | words ZAREZ WORD
  | words ZAREZ CAPITAL_WORD
  ;

%%

int main() {
  yyparse();
  printf("\nBroj obavestajnih: %d" , brojacObavestajnih);
  printf("\nBroj upitnih: %d" , brojacUpitnih);
  printf("\nBroj uzvicnih: %d\n" , brojacUzvicnih);
  printf("\nBroj pasusa: %d\n" , brojacPasusa);
}

int yyerror(char *s) {
  fprintf(stderr, "line %d: SYNTAX ERROR %s\n", yylineno, s);
} 

