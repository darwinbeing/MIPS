//#include <stdio.h>

int main () {
  int i;
  int array[10];
  int *p;
  int sum;

  /* test instruction "sb" */
  p = array;
  for (i = 0; i < 10; i++) {
    *((char *)p + 0) = i + 1;
    *((char *)p + 1) = i + 2;
    *((char *)p + 2) = i + 3;
    *((char *)p + 3) = i + 4;
    //printf("array[%d] = %08x\n", i, *p);
    p = p + 1;
  }
  //printf("\n");

  /* test instruction "sh" */
  p = array;
  for (i = 0; i < 10; i++) {
    *((short *)p + 0) = i - 1;
    *((short *)p + 1) = i - 2;
    //printf("array[%d] = %08x\n", i, *p);
    p = p + 1;
  }
  //printf("\n");

  /* test instruction "sb" */
  p = array;
  for (i = 0; i < 10; i++) {
    *((char *)p + 0) = i - 1;
    *((char *)p + 1) = i - 2;
    *((char *)p + 2) = i - 3;
    *((char *)p + 3) = i - 4;
    //printf("array[%d] = %08x\n", i, *p);
    p = p + 1;
  }
  //printf("\n");

  /* test instruction "lb" */
  p = array;
  for (i = 0; i < 10; i++) {
    sum = *((char *)p + 0) + *((char *)p + 1) + 
          *((char *)p + 2) + *((char *)p + 3);
    //printf("sum of array[%d] = %08x\n", i, sum);
    p = p + 1;
  }
  //printf("\n");

  /* test instruction "lbu" */
  p = array;
  for (i = 0; i < 10; i++) {
    sum = *((unsigned char *)p + 0) + *((unsigned char *)p + 1) + 
          *((unsigned char *)p + 2) + *((unsigned char *)p + 3);
    //printf("sum of array[%d] = %08x\n", i, sum);
    p = p + 1;
  }
  //printf("\n");

  /* test instruction "lh" */
  p = array;
  for (i = 0; i < 10; i++) {
    sum = *((short *)p + 0) + *((short *)p + 1);
    //printf("sum of array[%d] = %08x\n", i, sum);
    p = p + 1;
  }

  //printf("\n");

  /* test instruction "lhu" */
  p = array;
  for (i = 0; i < 10; i++) {
    sum = *((unsigned short *)p + 0) + *((unsigned short *)p + 1);
    //printf("sum of array[%d] = %08x\n", i, sum);
    p = p + 1;
  }
  return 0;
}

