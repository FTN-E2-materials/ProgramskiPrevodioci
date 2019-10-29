int abs(int i) {
  int res,marko;
  marko=0;
	marko=marko++;
	marko++;
  if(i < 0)
    res = 0 - i;
  else 
    res = i;

	do
		res = res +i;
	while(res>0);

  return res;
}

int main() {
  return abs(-5);
}


