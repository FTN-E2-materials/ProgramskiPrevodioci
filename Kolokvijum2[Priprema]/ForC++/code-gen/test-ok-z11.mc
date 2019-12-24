//OPIS: Test fora
//RETURN:100
int main() {
  int suma;
  int i;

  suma = 0;
  for(i = 0;i < 5; i++){
    for(int j = 0; j < 5; j++){ 
      suma = suma + 2 + 2;
    }
  }

  return suma;
}

