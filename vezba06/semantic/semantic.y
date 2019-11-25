%{
  #include <stdio.h>
  #include <stdlib.h>
  #include "defs.h"
  #include "symtab.h"

  int yyparse(void);
  int yylex(void);
  int yyerror(char *s);
  void warning(char *s);

  extern int yylineno;
  char char_buffer[CHAR_BUFFER_LENGTH];
  int error_count = 0;
  int warning_count = 0;
  int var_num = 0;
  int fun_idx = -1;
  int fcall_idx = -1;
	int brojac_bloka=0;
	int idxSWI=0;									// indeks svic promenljive
	int korisceni_literali[100];	// smestam literale iz case-a koji su se iskoristili
	int index_literala=0;					// koristi za indeks u trenutnom nizu korisceni_literali

	int brojac_fora=0;						// promenljiva koja sluzi da nam kaze u kom smo foru kako bi imali lokalne pr u foru tipa (int i=0;....)

%}

%union {
  int i;
  char *s;
}

%token <i> _TYPE
%token _IF
%token _ELSE
%token _RETURN
%token _SWITCH
%token _CASE
%token _COLUMN
%token _BREAK
%token _DEFAULT
%token _FOR
%token _INC

%token <s> _ID
%token <s> _INT_NUMBER
%token <s> _UINT_NUMBER
%token _LPAREN
%token _RPAREN
%token _LBRACKET
%token _RBRACKET
%token _ASSIGN
%token _SEMICOLON
%token <i> _AROP
%token <i> _RELOP


%type <i> num_exp exp literal function_call argument rel_exp

%nonassoc ONLY_IF
%nonassoc _ELSE

%%

program
  : function_list
      {  
        if(lookup_symbol("main", FUN) == NO_INDEX)
          err("undefined reference to 'main'");
       }
  ;

function_list
  : function
  | function_list function
  ;

function
  : _TYPE _ID
      {
        fun_idx = lookup_symbol($2, FUN);
        if(fun_idx == NO_INDEX)
          fun_idx = insert_symbol($2, FUN, $1, NO_ATR, NO_ATR);
        else 
          err("redefinition of function '%s'", $2);
      }
    _LPAREN parameter _RPAREN body
      {
        clear_symbols(fun_idx + 1);
        var_num = 0;
      }
  ;

parameter
  : /* empty */
      { set_atr1(fun_idx, 0); }

  | _TYPE _ID
      {
        insert_symbol($2, PAR, $1, 1, NO_ATR);
        set_atr1(fun_idx, 1);
        set_atr2(fun_idx, $1);
      }
  ;

body
  : _LBRACKET variable_list statement_list _RBRACKET
  ;

variable_list
  : /* empty */
  | variable_list variable
  ;

variable
  : _TYPE _ID _SEMICOLON
      {
        if( (lookup_symbol($2, VAR|PAR) != NO_INDEX) && (get_atr2(lookup_symbol($2, VAR|PAR)) == brojac_bloka )   )
           err("redefinition of '%s'", $2);
        else
					insert_symbol($2, VAR, $1, ++var_num, brojac_bloka);
           
      }
  ;

statement_list
  : /* empty */
  | statement_list statement
  ;

statement
  : compound_statement
  | assignment_statement
  | if_statement
  | return_statement
	| switch_statement
	| for_statement
  ;

compound_statement
  : _LBRACKET 
		{
			brojac_bloka++;
			$<i>$ = get_last_element();
		}
		variable_list statement_list _RBRACKET
		{
			//print_symtab();
			brojac_bloka--;
			clear_symbols($<i>2 + 1);
			//print_symtab();		
		}
  ;

assignment_statement
  : _ID _ASSIGN num_exp _SEMICOLON
      {
        int idx = lookup_symbol($1, VAR|PAR);
        if(idx == NO_INDEX)
          err("invalid lvalue '%s' in assignment", $1);
        else
          if(get_type(idx) != get_type($3))
            err("incompatible types in assignment");
      }
  ;

num_exp
  : exp
  | num_exp _AROP exp
      {
        if(get_type($1) != get_type($3))
          err("invalid operands: arithmetic operation");
      }
  ;

exp
  : literal
  | _ID
      {
        $$ = lookup_symbol($1, VAR|PAR);
        if($$ == NO_INDEX)
          err("'%s' undeclared", $1);
      }
  | function_call
  | _LPAREN num_exp _RPAREN
      { $$ = $2; }
  ;

literal
  : _INT_NUMBER
      { $$ = insert_literal($1, INT); }

  | _UINT_NUMBER
      { $$ = insert_literal($1, UINT); }
  ;

function_call
  : _ID 
      {
        fcall_idx = lookup_symbol($1, FUN);
        if(fcall_idx == NO_INDEX)
          err("'%s' is not a function", $1);
      }
    _LPAREN argument _RPAREN
      {
        if(get_atr1(fcall_idx) != $4)
          err("wrong number of args to function '%s'", 
              get_name(fcall_idx));
        set_type(FUN_REG, get_type(fcall_idx));
        $$ = FUN_REG;
      }
  ;

argument
  : /* empty */
    { $$ = 0; }

  | num_exp
    { 
      if(get_atr2(fcall_idx) != get_type($1))
        err("incompatible type for argument in '%s'",
            get_name(fcall_idx));
      $$ = 1;
    }
  ;

if_statement
  : if_part %prec ONLY_IF
  | if_part _ELSE statement
  ;

if_part
  : _IF _LPAREN rel_exp _RPAREN statement
  ;

//  "for" "(" <type> <id1> "=" <lit> ";" <relation> ";" <id2> "++" ")"
//     <stmt>
//
//gde je 
//<type> tip podatka (int ili unsigned)
//<id1> i <id2> su identifikatori
//<relation> relacioni izraz
//<stmt> statement

//Realizovati sledeće semantičke provere:
//a) <id1> treba da bude lokalna promenljiva za for iskaz
//   (sledeći for iskaz može da definiše iterator sa istim imenom)
//b) tip literala <lit> treba da bude isti kao tip promenljive <id1>
//c) <id1> i <id2> treba da budu ista promenljiva 


for_statement
	:	_FOR _LPAREN _TYPE _ID
			{
				brojac_fora++;
				if( lookup_symbol($4, VAR|PAR) != NO_INDEX && get_atr2(lookup_symbol($4, VAR|PAR)) == brojac_fora )
					err("Izmena promenljive '%s'", $4);
				else
					$<i>$ = insert_symbol($4, VAR, $3, ++var_num, brojac_fora);														// cuvam u meta promenljivoj indeks da bi posle znao sta da obrisem
																																																//insert symbol vraca indeks ubacenog elementa u tabeli simbola 
			}	
	 _ASSIGN literal
			{
				if ( get_type($7) != get_type(lookup_symbol($4, VAR|PAR) ) )
					err("Promenljiva %s i literal %d nisu istog tipa !",$4,atoi(get_name($7)));
			}
	 _SEMICOLON rel_exp _SEMICOLON _ID
			{
				if ( get_name(lookup_symbol($4, VAR|PAR)) != get_name(lookup_symbol($12, VAR|PAR) ) )
					err("Pazi : %s i %s moraju da budu iste promenljive !",$4,$12);
			}	
	 _INC _RPAREN statement
			{
				brojac_fora--;
				print_symtab();
				clear_symbols($<i>5);					//ZASTO MI SA $<i>4+1 ne radi ?????????????????????????????
			}
	;



switch_statement
	:	_SWITCH _LPAREN _ID
		{
			idxSWI = lookup_symbol($3, VAR|PAR);
      if(idxSWI == NO_INDEX)
				err("Promenljiva '%s' nije prethodno deklarisana",$3);
		}	
	 _RPAREN _LBRACKET case_statements default_statement _RBRACKET
	;


case_statements
	: case_statement
	| case_statements case_statement
	;

case_statement
	: _CASE literal
		{
			//konstanta mora biti jedinstvena,prvo proverim da li je vec u nizu
			int i=0;
			
			for(i;i<index_literala;i++){
				if( korisceni_literali[i] == $2 ){
					err("Pokusavas da koristis vec iskoristenu konstantu !");
					break;
				} 
			}
			
			//ako nije duplikat ubacim konstantu u niz
			korisceni_literali[index_literala] = $2;
			index_literala++;
			
			//provera tipa konstante i tipa pr
			//printf("\nIndex switch promenljive: %d ",idxSWI);
			printf("literal: %d ", $2);
			
			if ( get_type(idxSWI) != get_type($2) ){
				err("Tip konstante i tip promenljive nisu korespodentni!");
			}
			//print_symtab();
		}	
	 _COLUMN statement break_statement
	;

break_statement
	: /* empty */
	|	_BREAK _SEMICOLON
	;

default_statement
	: /* empty */
	| _DEFAULT _COLUMN statement
	;




rel_exp
  : num_exp _RELOP num_exp
      {
        if(get_type($1) != get_type($3))
          err("invalid operands: relational operator");
      }
  ;

return_statement
  : _RETURN num_exp _SEMICOLON
      {
        if(get_type(fun_idx) != get_type($2))
          err("incompatible types in return");
      }
  ;

%%

int yyerror(char *s) {
  fprintf(stderr, "\nline %d: ERROR: %s", yylineno, s);
  error_count++;
  return 0;
}

void warning(char *s) {
  fprintf(stderr, "\nline %d: WARNING: %s", yylineno, s);
  warning_count++;
}

int main() {
  int synerr;
  init_symtab();

  synerr = yyparse();

  clear_symtab();
  
  if(warning_count)
    printf("\n%d warning(s).\n", warning_count);

  if(error_count)
    printf("\n%d error(s).\n", error_count);

  if(synerr)
    return -1; //syntax error
  else
    return error_count; //semantic errors
}

