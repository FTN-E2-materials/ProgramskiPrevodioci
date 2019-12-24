//OPIS: Test iterator petlje
//RETURN: 18
int main() {
  int x;
  int y;
  int j;
  y=0;
  iterate x 1 to 3 {
    iterate j 1 to 3{
      y = x + y;
    }
  }
  
  return y;
}

