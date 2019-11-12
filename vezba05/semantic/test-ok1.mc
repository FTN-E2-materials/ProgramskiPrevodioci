//OPIS: imam fju tipa void i fju tipa main jedna nema povratnu vrednost, a druga ima 
void f(){
	// return 1; prijavice gresku jer ne moze da vrati broj
}
int main() {
    int a,b,c;

    do
      b = c = a + 1;
    while (b < 100);

		// return ; prijavice gresku jer nije fja tipa void
		return 1;
}

