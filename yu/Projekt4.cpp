#include <iostream>
#include "time.h"
#include "windows.h"

using namespace std;

HDC okno = GetDC(GetConsoleWindow());       //pobiera uchwyt okna używany przez konsolę
constexpr int obrazx = 640, obrazy = 480;   //rozdzielczosc rysowania obrazu
constexpr float xmin = -1.5, xmax =1.5;     //zakres wyswietlania punktwo na ekranie w osi x
constexpr float ymin = -1.5, ymax =1.5;     //zakres wyswietlania punktwo na ekranie w osi y

void liczenie(float* x, float* y, int los)    //fynkcja liczaca X Y
{
    float a, b, c, d, e, f; //parametry
    if (los <= 33)          //warunek prawdopodobienstwa
    {
        a = 0.5;            //przydzielenie wspolczynnikow odwzorowania
        b = 0.0;
        c = -0.5;
        d = 0.0;
        e = 0.5;
        f = 0.5;
    }
    else if(los > 33 && los <= 66)//warunek prawdopodobienstwa
    {
        a = 0.5;            //przydzielenie wspolczynnikow odwzorowania
        b = 0.0;
        c = -0.5;
        d = 0.0;
        e = 0.5;
        f = -0.5;
    }
    else if(los > 66)       //warunek prawdopodobienstwa
    {
        a = 0.5;            //przydzielenie wspolczynnikow odwzorowania
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
        finit               //inicjalizacja koprocesora

        fld[a]              //a na stos
        fld[xx]             //xx na stos
        fmulp st(1), st(0)  //a*xx i czyści
        fld[b]              //b na stos
        fld[yy]             //yy na stos
        fmulp st(1), st(0)  //b*yy i czysci
        fld[c]              //c na stos
        faddp st(1), st(0)  //(b*yy)+c i czysci
        faddp st(1), st(0)  //(a*xx)+(b*yy)+c i czysci

        fld[d]              //d na stos
        fld[xx]             //xx na stos
        fmulp st(1), st(0)  //d*xx i czysci
        fld[e]              //e na stos
        fld[yy]             //yy na stos
        fmulp st(1), st(0)  //e*yy i czysci
        fld[f]              //f na stos
        faddp st(1), st(0)  //(e*yy)+f
        faddp st(1), st(0)  //(d*xx)+(e*yy)f

        fstp[yy]            //(d*xx)+(e*yy)+f do yy i czysci
        fstp[xx]            //(a*xx)+(b*yy)+c do xx i czysci
    }
    *x = xx;
    *y = yy;
}

void wyswietlanie_pixela(float x, float y) //konwertowanie X Y na piksele
{
    float xx;
    float yy;
    /*
    __asm
    {
        finit               //inicajalizuje koprocesor

        fld[xmin]           //xmin na stos
        fld[xx]             //xx na stos
        fsubp st(1), st(0)  //xx-xmin iczysci
        fld[xmin]           //xmin na stos
        fld[xmax]           //xmax na stos
        fsubp st(1), st(0)  //xmax-xmin i czysci
        fdivp st(1), st(0)  //(xx-xmin)/(xmax-xmin) i czysci           
        fld[obrazx]         //obrazx na stos
        fmulp st(1), st(0)  //((xx-xmin)/(xmax-xmin))*obrazx i czysci

        
        fld[ymin]           //ymin na stos
        fld[yy]             //yy na stos
        fsubp st(1), st(0)  //yy-ymin i czysci
        fld[ymin]           //ymin na stos
        fld[ymax]           //ymax na stos
        fsubp st(1), st(0)  //ymax-ymin i czysci
        fdivp st(1), st(0)  //(yy-ymin)/(ymax-ymin) i czysci            
        fld[obrazy]         //obrazy na stos
        fmulp st(1), st(0)  //(y-ymin)/(ymax-ymin)*obrazy i czysci
        fld[obrazy]         //obrazy na stos
        fsubp st(1), st(0)  //obrazy-((y - ymin)/(ymax-ymin)*obrazy) i czysci

        fstp[yy]            //obrazy-((y - ymin)/(ymax-ymin)*obrazy) do yy i czysci
        fstp[xx]            //((xx-xmin)/(xmax-xmin))*obrazx do xx i czysci
    }
    */

   //to samo co wyzej tylko w C++
   xx = ((x - xmin) / (xmax - xmin)) * obrazx;         
   yy = obrazy - ((y - ymin) / (ymax - ymin) * obrazy);

   SetPixel(okno, xx, yy, 0);       //ustawienie pixela
}

int main()
{
    srand(time(NULL));              //ustawienie punkt startowy generatora pseudolosowego
    system("color f0");             //ustawienie koloru tla
    int los;
    float x = 0;
    float y = 0;
    for (int i = 0; i < 20000; i++) //petla iteracyjna
    {
        los = rand() % 100;         //losowanie pseldolosu
        liczenie(&x, &y, los);      //wywolanie funkcji liczacej x y
        wyswietlanie_pixela(x, y);  //wywolanie funkcji wyswietlajacej x y
    }
}
