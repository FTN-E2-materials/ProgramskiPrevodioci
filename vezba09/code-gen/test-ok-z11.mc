//OPIS: provera switcha
//RETURN: 1

int main() {
  int state;
  int s;
  state=10;
  s=1;

  switch (state) {
    case 10: { s = 1; } break;
    case 20: s = 2;
    default: s = 0;
  } 

  return s;
}

