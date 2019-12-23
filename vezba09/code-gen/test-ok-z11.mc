//OPIS: Test fora
//RETURN: 100
int main() {
  int suma;
  int i;
  int j;
  suma = 0;
  for(i = 0; i < 5; i++){
    for(j = 0; j < 2; j++){
       suma = suma + 10;
    }
    suma = suma + i;
  }
 
  for(i = 0; i<5; i++){
    suma = suma - i;
  }

  return suma;
}

