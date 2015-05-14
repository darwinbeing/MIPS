//#include <stdio.h>

int main () {
  int i;
  int array[64];
  int *p, *q;
  int sum;

  p = array;
  for (i = 0; i < 32; i++) {
    *((unsigned short *)p + 0) = i;
    *((unsigned short *)p + 1) = i+1;
    sum = *((unsigned short *)p + 0) + *((unsigned short *)p + 1);
    *((char *)p + 0) = sum;
    *((char *)p + 1) = sum;
    *((char *)p + 2) = sum;
    *((char *)p + 3) = sum;
    sum = *((unsigned char *)p + 0) + *((unsigned char *)p + 3);
    *((char *)p + 0) = (char)  sum;
    *((short *)p + 0) = (short) sum;
    *((char *)p + 1) = (char)  sum;
    *((short *)p + 1) = (short) sum;
    sum = *p;
    *((short *)p + 1) = (short) sum;
    *((short *)p + 0) = (short) sum;
    *((char *)p + 3) = (char)  sum;
    *((char *)p + 2) = (char)  sum;
    q = p + 1;
    sum = *((unsigned short *)p + 0) + *((unsigned short *)p + 1);
    *((char *)q + 0) = *((char *)p + 3);
    *((char *)q + 1) = *((char *)p + 2);
    *((char *)q + 2) = *((char *)p + 1);
    *((char *)q + 3) = *((char *)p + 0);
    sum = *((unsigned short *)q + 0) + *((unsigned short *)q + 1);
    *((char *)p + 0) = (char)  sum; 
    *((short *)p + 0) = (short) sum;
    *((char *)p + 1) = (char)  sum;
    *((short *)p + 1) = (short) sum;
    sum = *p;
    *((short *)q + 1) = (short) sum;
    *((short *)q + 0) = (short) sum;
    *((char *)q + 3) = (char)  sum;
    *((char *)q + 2) = (char)  sum;
    p = q + 1;
  }
/*
  for (i = 0; i < 10; i++) {
    printf("array[%d] = %x\n", i, array[i]);
  }
*/
  return 0;
}

