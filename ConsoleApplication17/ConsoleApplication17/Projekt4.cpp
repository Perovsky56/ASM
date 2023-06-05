#include <iostream>
#include "time.h"
#include "windows.h"

using namespace std;

HDC okno = GetDC(GetConsoleWindow());     //pobranie uchwytu okna do konsoli

int obrazX = 800, obrazY = 600;
float xmin = -1.5, xmax = 1.5;
float ymin = -1.5, ymax = 1.5;

void oblicz(float *x, float *y, int los)
{
    float a, b, c, d, e, f;
    if (los <= 33)
    {
        a = 0.5;
        b = 0.0;
        c = -0.5;
        d = 0.0;
        e = 0.5;
        f = 0.5;
    }
    else if (los > 33 && los <= 66)
    {
        a = 0.5;
        b = 0.0;
        c = -0.5;
        d = 0.0;
        e = 0.5;
        f = -0.5;
    }
    else if (los > 66)
    {
        a = 0.5;
        b = 0.0;
        c = 0.5;
        d = 0.0;
        e = 0.5;
        f = -0.5;
    }

    float xx = *x;
    float yy = *y;

    __asm
    {
        finit

        fld[a]
        fld[xx]
        fmulp st(1), st(0) //a*xx
        fld[b]
        fld[yy]
        fmulp st(1), st(0) //b*yy
        fld[c]
        faddp st(1), st(0) //(b*yy)+c
        faddp st(1), st(0) //(a*xx)+(b*yy)+c

        fstp [xx] //(a*xx)+(b*yy)+c do xx

        fld[d]
        fld[xx]
        fmulp st(1), st(0) //d*xx
        fld[e]
        fld[yy]
        fmulp st(1), st(0) //e*yy
        fld[f]
        faddp st(1), st(0) //(e*yy)+f
        faddp st(1), st(0) //(d*xx)+(e*yy)+f

        fstp[yy] //(d*xx)+(e*yy)+f do yy
    };

    *x = xx;
    *y = yy;
}

void wyswietlPixel(float x, float y)
{
    float xx;
    float yy;
    
    xx = ((x - xmin) / (xmax - xmin)) * obrazX;
    yy = obrazY - ((y - ymin) / (ymax - ymin) * obrazY);

    SetPixel(okno, xx, yy, 0);
}

int main()
{
    srand(time(NULL));
    system("color f0");
    int los;
    float x = 0;
    float y = 0;
    for (int i = 0; i < 100000; i++)
    {
        los = rand() % 100 + 1;
        oblicz(&x, &y, los);
        wyswietlPixel(x, y);
    }

    Sleep(5000000);
}
