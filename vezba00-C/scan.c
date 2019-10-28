#include <ctype.h>
#include <stdio.h>

int main(void) {
  int ch;
  int state = 0;

  while(1) {
    switch(state) {
      case 0: {
        ch = getc(stdin);
        if(ch == '.')
          state = 1;
        else {
          //...
          if(ch == EOF)
            return 0;
        }
      }; break;

      case 1: {
        printf("\nDOT\t.");
        state = 0;
      }; break;

      case 2: {
      }; break;

      case 3: {
      }; break;

      case 4: {
      }; break;

      case 5: {
      }; break;

      case 6: {
      }; break;
    }
  }
}

