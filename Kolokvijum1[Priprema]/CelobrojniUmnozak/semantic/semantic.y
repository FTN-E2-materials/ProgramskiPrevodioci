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

  int returnStatements = 0;

	int idindex = 0;
	int countIds = 0;
	int countLiterals = 0;
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
%token _POSTINC
%token _DO
%token _WHILE

%token _READ
%token _DATA
%token _FROM

%type <i> num_exp exp literal function_call argument rel_exp
%type <i> linking_vars

%nonassoc ONLY_IF
%nonassoc _ELSE

%%

program
  : function_list
      {  
        if(lookup_symbol("main", FUN) == -1)
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
        if(fun_idx == -1)
          fun_idx = insert_symbol($2, FUN, $1, NO_ATR, NO_ATR);
        else 
          err("redefinition of function '%s'", $2);
      }
    _LPAREN parameter _RPAREN body
      {
        clear_symbols(fun_idx + 1);
        var_num = 0;
		  		//*bitno
				if(returnStatements==0 & get_type(fun_idx) != VOID)
					err("Non-void function with no return statement.");
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
		  if(get_type($1) == VOID) err("Parametri ne mogu biti tipa void!");
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
  : linking_vars _SEMICOLON
  ;

linking_vars
  : _TYPE _ID
		{
        if(lookup_symbol($2, VAR|PAR) == -1)
           insert_symbol($2, VAR, $1, ++var_num, NO_ATR);
        else 
           err("redefinition of '%s'", $2);
					$$ = $1;
			
			if(get_type($1) == VOID) err("Varijable ne mogu biti tipa void!");
      }
  | linking_vars _COMMA _ID
	{
        if(lookup_symbol($3, VAR|PAR) == -1)
           insert_symbol($3, VAR, $1, ++var_num, NO_ATR);
        else 
           err("redefinition of '%s'", $3);
					$$ = $1;
      }
  ;


do_while
	:	_DO statement _WHILE _LPAREN _ID _RELOP literal _RPAREN _SEMICOLON
			{
				int promjenljiva = lookup_symbol($5, VAR|PAR);

				if(promjenljiva == -1)
					err("'%s' is undefined!", $5);
				
				if(get_type(promjenljiva) != get_type($7))
					err("var|par and literal in DO_WHILE are not of the same type!");
			}
	;




//*************** Read From + cjelobrojni umnozak *******************

readFrom
	: _READ nizIdeva _FROM data
				{
						if(countLiterals % countIds != 0) err("Broj literala nije cjelobrojni umnozak ID-eva!");
				} _DO statement
	;


nizIdeva
	: _ID {
					//id mora biti prethodno deklarisan
					idindex = lookup_symbol($1, VAR|PAR);
					if(idindex == -1) err("'%s' nije prethodno definisan!", $1);
					countIds++;
				}
	| nizIdeva _COMMA _ID
				{
					//id mora biti prethodno deklarisan
					idindex = lookup_symbol($3, VAR|PAR);
					if(idindex == -1) err("'%s' nije prethodno definisan!", $3);
					countIds++;
				}
	;

data
	:	_DATA nizLiterala
	| data _DATA nizLiterala
	;

nizLiterala
	: literal {
									//id i literali moraju biti istog tipa
							if(get_type(idindex) != get_type($1)) err("Promjenljiva i literali nisu istog tipa!");
									countLiterals++;
						}
	| nizLiterala _COMMA literal
						{
								//id i literali moraju biti istog tipa
						if(get_type(idindex) != get_type($3)) err("Promjenljiva i literali nisu istog tipa!");
								countLiterals++;
						}
	;

//**********************************************


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
		| readFrom
  ;

compound_statement
  : _LBRACKET statement_list _RBRACKET
  ;

assignment_statement
  : _ID _ASSIGN num_exp _SEMICOLON
      {
        int idx = lookup_symbol($1, VAR|PAR);
        if(idx == -1)
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
        if($$ == -1)
          err("'%s' undeclared", $1);
      }
  		| _ID _POSTINC 
			{
				$$ = lookup_symbol($1, VAR|PAR);
				if($$ == -1) err("'%s' undeclared", $1);
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
		  if(get_type(fun_idx) == VOID){
          err("Void function must not return a value!");
		  }else{
		     if(get_type(fun_idx) != get_type($2))
		       err("incompatible types in return");
				}
			returnStatements++;
      }
  | _RETURN _SEMICOLON 
		{
			if(get_type(fun_idx) != VOID)
          err("Non-void function must return a value!");
			 returnStatements++;
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

