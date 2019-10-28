//OPIS: vise for petlji u ugnjezdenim blokovima
//RETURN: 37
//veliki primer, bilo bi zgodno podeliti ga na vise sitnijih

int main() {
    int x;
    int y;
    int b;

    x = 2;
    y = 3;
    b = 7;
    {
      int x;
      int a;
      unsigned i;
      x = 5;
      a = 11;
      b = 4;
      i = 50u;
      for (int i = 0; i < 8; i++)
        x = x + i;
      {
        int x;
        int a;
        int i;
        x = 42;
        a = 15;
        b = 19;
        for (unsigned i = 0u; i < 7u; i++)
          x = x + 1;
        x = x + a + b;
        y = x + a - b;
      }
      y = x + y - a + b;
      for (int i = -15; i < 7; i++)
        y = y + i;
    }
    for (int i = -5; i < 5; i++)
      b = b + i;
    return x + y + b;
  }

