//OPIS: nested funkcija: pogresan broj argumenata
//TEZINA 2
int abs(int i) {
  unsigned r; 
  
  function unsigned (unsigned x) dup -> return x + x;
  r = dup();
}

int main() {
  int a;
  unsigned b;

  a = 1;
  function int (int x) inc -> x = x + a;
  
  a = abs(-5);
  a = inc(3);
}
