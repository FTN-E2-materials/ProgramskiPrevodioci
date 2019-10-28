//OPIS: dva ugnjezdena bloka
//RETURN: 106
//veliki primer, bilo bi zgodno podeliti ga na vise sitnijih

int main() {
    int x;
    int y;
    int b;
    unsigned c;

    x = 2;
    y = 3;
    b = 7;
    c = 5u;
    {
      int x;
      int a;
      int c;
      x = 5;
      a = 11;
      b = 4;
      c = -42;
      {
        int x;
        int a;
        unsigned c;
        x = 42;
        a = 15;
        b = 19;
        x = x + a + b;
        y = x + a - b;
        c = 10u;
      }
      y = x + y - a + b;
    }
    return x + y + b;
  }

