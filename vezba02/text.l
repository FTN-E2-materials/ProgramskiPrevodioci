%option noyywrap yylineno
%{
  #include "text.tab.h"
%}

%%

[ \t]+    { /* skip */ }
\n+         { return NW; }
"."         { return DOT; }
"?"         { return UPITNIK; }
"!"         { return UZVICNIK; }
","         { return ZAREZ; }
[A-Z][a-z]* { return CAPITAL_WORD; }
[a-z]+      { return WORD; }
                     
.           { printf("\nline %d: LEXICAL ERROR on char %c", 
                      yylineno, *yytext); }    

