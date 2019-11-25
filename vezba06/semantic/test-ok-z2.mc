//OPIS: switch iskaz
//RETURN: 5

int main() {
  int state;
	int x;
  state = 2;
	x=0;

	switch(state){
		case 1: x=1; break;
		case 2: { x=2; } break;
		case 3: { x=3; }
		default: x=100;
	}	

//  switch(state) {
//    case 1: x = 1; break;
//    case 2: { x = 5;} break;
//    default: x = 10;
//  }
//  return x;
}
