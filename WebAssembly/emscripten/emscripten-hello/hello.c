#include <stdio.h>
#include <emscripten.h>

EMSCRIPTEN_KEEPALIVE

int main() {
  printf("hello, world!\n");
  return 0;
}
