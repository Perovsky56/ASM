format PE Console 4.0
entry start

include 'win32ax.inc'
include 'win_macros.inc'

section '.text' code readable executable 

start:
	ustaw_kursor 0,0
	cinvoke printf, <"Obliczanie calki oznaczonej metoda trapezow. sin(x)/x", 10, 13>     ; dolna granica
	cinvoke printf, <"a (dolna granica) = ">     ; dolna granica
	cinvoke scanf, <"%lf">, a
	cinvoke printf, <"b (gorna granica) = ">
	cinvoke scanf, <"%lf">, b    ; górna granica
	cinvoke printf, <"n = ">
	cinvoke scanf, <"%lf">, n    ; ilosc przedzialow
	
obl_dx:
	fld [b] 		; b na stos
	fld [a] 		; a na stos
	fsubp			; odejmuje b od a i czysci st(0)
	fst [roznica]		; przeslanie st(0) do [roznica] 		    dx = (x_k - x_p) / n
	fld [n] 		; n na stos						   b	 a     n
	fdivp			; roznica/n i czyszczenie st(0)
	fstp [dxx]		; przeslanie st(0) do dxx i czyszczenie st(0)
	
obl_x:
	fild [licznik]		; licznik na stos
	fld [n] 		; n na stos
	fdivp			; dzieli licznik/n i czysci
	fld [roznica]		; roznica na stos
	fmulp			; mnozy (licznik/n)*roznica i czysci
	fld [a] 		; a na stos
	faddp			; dodaje ((licznik/n)*roznica)+a i czysci	       x_i = x_p + (i/n)*(x_k - x_p) dla i = 1, 2, ..., n
	fstp [x]		; przeslanie st(0) do x i czysci					     dx
	
	cmp [licznik], 0	; porownanie licznik z 0
	je obl_funkcje2 	; skok gdy rowny
	
	fild [licznik]		; licznik na stos
	fcomp [n]		; porownanie licznik z 'n'
	fstsw ax		; zapisanie flag FPU do akumulatora
	sahf			; przeslanie odpowiednich bitow z ah do EFLAGS
	je obl_funkcje2 	; jezeli rowne to skok do obl_funkcje2
	
obl_funkcje:
	fld [x] 		; x na stos
	fsin			; sin(x)
	fld [x] 		; x na stos
	fdivp			; dzieli sin(x)/x
	fld [wynik]		; wynik na stos 				       f_i = f(x_i)
	faddp			; dodaje (sin(x)/x)+wynik i czysci		       wynik = suma od f_1 do f_(n-1)
	fstp [wynik]		; przenosi st(0) do wynik i czysci
	inc [licznik]		; licznik++
	jmp obl_x		; skok obl_x
	
obl_funkcje2:
	fld [x] 		; x na stos
	fsin			; sin(x)
	fld [x] 		; x na stos
	fdivp			; dzieli sin(x)/x
	fld [wynik2]		; wynik2 na stos				       wynik2 = f_0 + f_n
	faddp			; dodaje (sin(x)/x)+wynik2 i czysci
	fstp [wynik2]		; przenosi st(0) do wynik2 i czysci
	inc [licznik]		; licznik++
	cmp [licznik], 1	; porownuje licznik z 1
	je obl_x		; jesli rowne skok do obliczania [x]
	
obl_sume:
	fld [wynik2]		; wynik2 na stos
	fild [dzielnik] 	; dzielnik na stos
	fdivp			; dzieli wynik/2 i czysci st(0)
	fld [wynik]		; wynik na stos 				S = dxx * (f_1 + f_2 + ... + f_(n-1) + (f_0 + f_n)/2)
	faddp			; dodaje wynik+wynik2/2 i czysci		S = dxx * (	      wynik	     +	    wynik2/2)
	fld [dxx]		; dxx na stos
	fmulp			; mnozy (wynik+wynik2/2)dxx i czysci
	fstp [wynik]		; przenosi st(0) do wynik i czysci
	
koniec: 
	ustaw_kursor 4,0
	cinvoke printf, <'Wynik sin(x)/x dx = %3lf ',0>, dword [wynik], dword [wynik+4]

	pob_znak
	end_prog


section '.data' data readable writeable
	a		 dq	 0
	b		 dq	 0
	n		 dq	 0
	x		 dq	 0
	dxx		 dq	 0
	roznica 	 dq	 0
	licznik 	 dd	 0
	wynik		 dq	 0
	wynik2		 dq	 0
	dzielnik	 dw	 2