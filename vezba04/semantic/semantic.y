%{
  #include <stdio.h>
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
	int indeks1=-1;
	int indeks2=-1;					//promenljive indeks1,2 sluze za proveru u assignment iskazu

%}

%union {
  int i;
  char *s;
}

%token <i> _TYPE
%token _IF
%token _ELSE
%token _RETURN
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
%token _COMMA
%token _INC
%token _DO
%token _WHILE

%type <i> type num_exp exp literal
%type <i> function_call argument rel_exp
%type <i> vars
//ima dodatnu vrednost stavimo to <i>
//ako negde stavim $$=nesto,moramo staviti ovde %type <i> taj iskaz
%type <i> assignment												//dodajemo jer ce assignment da prima vrednost preko $$
%nonassoc ONLY_IF
%nonassoc _ELSE

%%

program
  : function_list
      {  
        int idx = lookup_symbol("main", FUN);
        if(idx == -1)
          err("undefined reference to 'main'");
        else 
          if(get_type(idx) != INT)
            warn("return type of 'main' is not int");
      }
  ;

function_list
  : function
  | function_list function
  ;

function
  : type _ID
      {
        fun_idx = lookup_symbol($2, FUN);
        if(fun_idx == -1)
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

type
  : _TYPE
      { $$ = $1; }
  ;

parameter
  : /* empty */
      { set_atr1(fun_idx, 0); }

  | type _ID
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
  : vars _SEMICOLON

  ;

vars
	: type _ID
      {
        if(lookup_symbol($2, VAR|PAR) == -1)
           insert_symbol($2, VAR, $1, ++var_num, NO_ATR);
        else 
           err("redefinition of '%s'", $2);
				$$=$1;
				//vars nosi sad tip 
				//jer $$ je vrednost pojma s leve strane pravila
				//gore moramo dodati %type <i> vars ili %type <s> vars ako hocemo vars
				//da ima mogucnost da bude tipa string
				//vars ce nositi type,kako bi posle mogli da znamo koji je tip 
      }

	| vars _COMMA _ID
      {
				//u $1 tj u varsu je type od gore ( $$ = $1)
        if(lookup_symbol($3, VAR|PAR) == -1)
           insert_symbol($3, VAR, $1, ++var_num, NO_ATR);
        else 
           err("redefinition of '%s'", $3);
				$$=$1;
				//ako imam 3,4,5... promenljivih da za tu 3,4,5.. znamo tip      
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
	| do_while
  ;

compound_statement
  : _LBRACKET statement_list _RBRACKET
  ;

assignment_statement
  : assignment num_exp _SEMICOLON
	{
		if(get_type($1) != get_type($2) )		//provera da li je promenljiva s leve strane istog tipa kao i izraz sa desne
			err("Uneta promenljiva nije korespodentnog tipa kao i numericki izraz !");
	}
  ;

assignment
	: _ID _ASSIGN
	{
		indeks1 = lookup_symbol($1,VAR|PAR);
		if(indeks1 == -1)										//provera da li ta promenljiva uopste postoji
			err("Uneta je promenljiva koja uopste ne postoji ! ");
		$$=indeks1;													//prenosimo njen indeks u assignment
	}
	| assignment _ID _ASSIGN
	{
		indeks2=lookup_symbol($2,VAR|PAR);
		if(indeks2 == -1)										//provera da li ta promenljiva uopste postoji
			err("Uneta je promenljiva koja uopste ne postoji ! ");
		
		if(get_type(indeks2) != get_type($1) )
			err("Unete promenljive s leve i desne strane nisu istog tipa!");
		$$=indeks2;													//prenosimo njen indeks u assignment
		
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
        if($$ == -1)
          err("'%s' undeclared", $1);
      }
	| _ID _INC
      {
        $$ = lookup_symbol($1, VAR|PAR);
        if($$ == -1)
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
        if(fcall_idx == -1)
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

do_while
	:	_DO statement _WHILE _LPAREN _ID _RELOP literal _RPAREN _SEMICOLON
		{
			int index=lookup_symbol($5,VAR|PAR);
			if(index == -1){
				err("promenljiva ne postoji u tvom kodu");
			}
			if( get_type(index) != get_type($7) ){
				err("promenljiva i literal moraju biti istog tipa!");
			}

		}
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
    return -1;
  else
    return error_count;
}

