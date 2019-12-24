//OPIS: Test primer za ForIdIn
//RETURN: 15
int main() {
  int i;
  int result;
  result = 0;

  for i in(5 .. 1){		
    result = result + i;
  }

  return result;
}

