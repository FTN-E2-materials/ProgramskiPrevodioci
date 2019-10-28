//OPIS: nested funkcija poziv nepostojece funkcije
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
  //function unsigned (unsigned x) dup -> return x + x;
  a = abs(-5);
  a = inc(3);
  b = dup(5u);
}
