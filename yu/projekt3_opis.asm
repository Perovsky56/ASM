format PE Console 4.0
entry start
include 'win32ax.inc'
include 'win_macros.inc'

section '.text' code readable executable 

start:				;pobieranie zmiennych									

	cinvoke printf, <"cos(x)/x dx">
	ustaw_kursor 1,0
	cinvoke printf, <"a = ">
	cinvoke scanf, <"%lf">, a
	cinvoke printf, <"b = ">
	cinvoke scanf, <"%lf">, b
	cinvoke printf, <"n = ">
	cinvoke scanf, <"%lf">, n
	
oblicz_dx:			;obliczanie dx'a

	fld [b]			;daje b na stos
	fld [a]			;daje a na stos
	fsubp			;odejmuje b od a i czysci
	fst [roznica]	;przeslanie st(0) do roznica
	fld [n]			;daje n na stos
	fdivp			;dzieli elementy stosu i czysci
	fstp [dxx]		;przeslanie st(0) do dxx i czysci
	
oblicz_x:			;oblicznaie x			

	fild [licznik]	;daje licznik na stos
	fld [n]			;daje n na stos
	fdivp			;dzieli licznik/n i czysci
	fld [roznica]	;daje roznica na stos
	fmulp			;mnozy (licznik/n)*roznica i czysci
	fld [a]			;daje a na stos 
	faddp			;dodaje ((licznik/n)*roznica)+a i czysci
	fstp [x]		;przeslanie st(0) do x i czysci
	
	cmp [licznik], 0;porownanie licznik do 0
	je oblicz_funkcjie2;skok gdy rowny
	
	fild [licznik]	;daje licznik na sots
	fcomp [n]		;porownanie licznik z 'n' i czysci 
	fstsw ax		;przelanie FPSR do ax
	sahf			;przeslanie odpowiednich bitow z ah do EFLAGS
	je oblicz_funkcjie2;skok gdy rowny
	
oblicz_funkcjie:	;obliczanie funkcji
	
	fld [x]			;daje x na stos
	fcos			;cos(x) 
	fld [x]			;daje x na stos
	fdivp			;dzieli cos(x)/x
	fld [wynik]		;daje wynik na stos
	faddp 			;dodaje (cos(x)/x)+wynik i czysci
	fstp [wynik]	;przenisi st(0) do wynik i czysci
	inc [licznik]	;licznik++
	
	jmp oblicz_x	;skok oblicz_x
	
oblicz_funkcjie2:

	fld [x]			;daje x na stos
	fcos			;cos(x)
	fld [x]			;daje x na stos
	fdivp			;dzieli cos(x)/x
	fld [wynik2]	;daje wynik2 na stos
	faddp 			;dodaje (cos(x)/x)+wynik2 i czysci
	fstp [wynik2]	;przenisi st(0) do wynik2 i czysci
	inc [licznik]	;licznik++
	cmp [licznik], 1;porownuje licznik do 1
	je oblicz_x		;jesli rowne skok
	
oblicz_sume:

	fld [wynik2]	;daj wynik2 na stos
	fild [dzielnik]	;daje dzielnik na stos 
	fdivp 			;dzieli wynik/2 dz
	fld [wynik]		;daje wynik na stos
	faddp			;dodaje wynik+wynik2/2 i czysci
	fld [dxx]		;daje dxx na stos
	fmulp			;mnozy (wynik+wynik2/2)dxx i czysci
	fstp [wynik]	;przenisi st(0) do wynik i czysci
	
koniec: 
	ustaw_kursor 4,0
	cinvoke printf, <'Wynik = %3lf ',0>, dword [wynik], dword [wynik+4]
	pob_znak
	end_prog
	
section '.data' data readable writeable
	
	a 		 dq 0
	b 		 dq 0
	n 		 dq 0
	x 		 dq 0
	dxx 	 dq 0
	roznica  dq 0
	licznik  dd 0
	wynik 	 dq 0
	wynik2 	 dq 0
	dzielnik dw 2
	
	
	

	


