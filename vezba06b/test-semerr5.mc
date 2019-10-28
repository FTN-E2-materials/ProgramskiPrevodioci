//OPIS: nested funkcija: pogresan tip povratne vrednosti
//TEZINA 2
int main(int i) {
  unsigned r; 
  function unsigned (unsigned x) dup -> return x + x;
  return dup(3u);
}

