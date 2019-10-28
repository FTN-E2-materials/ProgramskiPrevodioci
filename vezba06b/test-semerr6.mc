//OPIS: nested funkcija: nested i miniC funkcija moraju imati razlicito ime
//TEZINA 2
int abs(int i) {
  unsigned r; 
  function unsigned (unsigned x) dup -> return x + x;
  r = dup(3u);  
}

int main() {
  int a;
  unsigned b;

  a = 1;
  function int (int x) abs -> x = x + a;
  a = abs(-5);
}
