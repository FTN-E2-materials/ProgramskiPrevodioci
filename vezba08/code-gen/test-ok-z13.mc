//OPIS: jednostavan miniC conditional izraz3
//RETURN: 9

int main() {
	int a;
	int b;
	a = 3;
	b = 3;

	a = a + (a == b) ? a : b + 3;

	return a;
}

