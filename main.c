
#include <stdio.h>

short test(void)
{
    short x = 2;
    /*    x + 3;
        x + 2;

        int *y = &x;

    */
    return x;
}

void main(void)
{
    printf("test %d\n", test());
}