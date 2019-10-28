//OPIS: nested funkcija OK
//TEZINA 2
int abs(int i) {
  unsigned r; 
  
  function unsigned (unsigned x) dup -> return x + x;
  r = dup(3u);
  
  function int o -> return 0;
  return o();
}

int main() {
  int a;
  unsigned b;

  a = 1;
  function int (int x) inc -> x = x + a;
  a = abs(-5);
  a = inc(3);
  function int (int x) dec -> { x = x - 1; }
  a = inc(5) + dec(2);
}
