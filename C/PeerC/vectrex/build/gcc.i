# 1 "source\\gcc.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "source\\gcc.c"
# 46 "source\\gcc.c"
asm(
 ".globl		_abort				\n\t"
 "_abort		.equ 	0xf000		\n\t"
);
# 68 "source\\gcc.c"
asm(
 ".globl		_free				\n\t"
 "_free		.equ 	0xf000		\n\t"
);
# 90 "source\\gcc.c"
asm(
 ".globl		_malloc				\n\t"
 "_malloc	.equ 	0xf000		\n\t"
);
# 112 "source\\gcc.c"

int memcmp (const void* str1, const void* str2, long unsigned int count)
{
 const unsigned char* s1 = (unsigned char*) str1;
 const unsigned char* s2 = (unsigned char*) str2;

 while (count-- > 0)
 {
  if (*s1++ != *s2++)
  {
   return s1[-1] < s2[-1] ? -1 : 1;
  }
 }
 return 0;
}






void* memcpy (void* dest, const void* src, long unsigned int len)
{
 char* d = (char*) dest;
 const char* s = (char*) src;
 while (len--)
 {
  *d++ = *s++;
 }
 return dest;
}






void* memmove(void* dest, const void* src, long unsigned int len)
{
 char* d = (char*) dest;
 const char* s = (char*) src;
 if (d < s)
 {
  while (len--)
  {
   *d++ = *s++;
  }
 }
 else
 {
  const char* lasts = s + (len-1);
  char* lastd = d + (len-1);
  while (len--)
  {
   *lastd-- = *lasts--;
  }
 }
 return dest;
}






void* memset(void* dest, int val, long unsigned int len)
{
 int* ptr = dest;
 while (len-- > 0)
 {
  *ptr++ = val;
 }
 return dest;
}
