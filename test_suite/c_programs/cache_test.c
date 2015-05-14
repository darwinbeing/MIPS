
#define MAX 16

int main()
{
  int a[MAX];
  int i;

  for (i = 0; i < MAX; i++)
    a[i] = i;

 asm("li $4, 0\n" 
     "li $5, 512\n"
     "cache_flush:\n"
     "cache 0x1, 0($4)\n"
     "addiu $4, $4, 1\n"
     "bne $4, $5, cache_flush");

  return 0;
}


