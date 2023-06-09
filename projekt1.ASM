format MZ
entry main:start
stack 100h
; Pawe� Siemiginowski, s101450, projekt nr 1, grupa D
segment main
start:
	mov ax, dane	 ; wczytanie danych
	mov ds, ax

	mov dx, txt1
	mov ah, 9h	 ; "Linia polece�"
	int 21h

	xor dx, dx
;======= WEJSCIE BINARNE (ZNAK, MODU�) ==========
pob_bin:
	mov cx, 16     ; Licznik p�tli na 16
	xor bx, bx
petla1:
	push cx 	  ; Zabezpieczenie rejestru
petla2:
	mov ah, 7	     ; Pobranie znaku
	int 21h

	cmp al,1bh	 ; Sprawdzenie, czy wprowadzony znak to "ESC"
	je koniec_prog	   ; jak tak, to skocz do koniec_progr(amu)

	;cmp al,0Dh	  ; Sprawdzenie, czy wprowadzony znak to "Enter"
	;je koniec_p1	  ; jak tak to skocz do koniec_p1(amu)

	cmp al,8		; Sprawdzenie, czy wprowadzony znak to "Backspace"
	jne petla3		; Je�eli nie to skok do petla3

	pop cx		    ;  Jezeli licznik petli = 16 to powrot do poczatku petli
	cmp cx,16
	je  petla1
	
	inc cx		    ; Zwi�kszenie licznika p�tli o utracon� przez backspace warto��
	push cx

	mov dl, 8
	mov ah,2	   ; 8 = BACKSPACE
	int 21h

	mov dl, ' '
	mov ah,2	  ;
	int 21h

	mov dl, 8
	mov ah,2	 ; 8 = BACKSPACE
	int 21h

	jmp petla2     ; Powr�t do pobierania nast�pnej warto�ci

petla3:
	cmp al, '0'	    ; Jak poni�ej '0' to skok do petli1
	jb petla1
	cmp al, '1'	    ; Jak powy�ej '1' to skok do petli1
	ja petla1	    ; Powy�sze warunki zezwalaj� na wprowadzenie tylko 0 i 1

	mov dl, al	    ; Wy�wietl wprowadzany znak uzytkownikowi (podgl�d wpisywania w konsoli)
	mov ah, 2
	int 21h
	cmp cx, 16	   ; Jezeli licznik petli = 16 to mamy do czynienia ze znakiem (znak modu�)
	je skok2	   ; Jezeli cx = 16 to skocz do ety skok2

	cmp al, 0Dh	   ; Por�wnanie wej�cia i CR
	je koniec_p1	   ; Jezeli r�wne to skocz do ko�ca petli1
	and al, 0Fh	   ; Konwersja kodu ascii
	shl bx, 1	   ; Przesuniecie logiczne rejestru bx o jedna pozycje w lewo
	xor ah, ah	   ; Czyszczenie rejestru "ah"
skok1:
	or bx, ax	   ; Dodaj ax do rejestru bx
	jmp skok3	   ; Skocz do konca pierwszego warunku
skok2:
	cmp al, '1'	   ; Sprawdz, czy pierwsza liczba = 1
	jne skok3	   ; Jezeli nie to wyjdz
	mov [znak], 1	   ; Jezeli tak to ustaw pod [znak] w pamieci kod ascii minusa (do p�niejszego uzycia)
skok3:
	pop cx
	loop petla1
koniec_p1:
	mov [wejscie], bx	 ; Wstaw wprowadzona przez uzytkownika zawartosc rejestru bx w miejsce pamieci zmienna1


	MOV dl, 10	       ; Nastepna linia, powrot carriage
	MOV ah, 02h
	INT 21h
	MOV dl, 13
	MOV ah, 02h
	INT 21h


;====== WYJSCIE BINARNE ======

	mov dx, txt2
	mov ah, 9h		 ; [bin] =
	int 21h

	cmp [znak], 0
	je skok4
	mov dx, znak2		; Dodanie znaku minusa, je�eli 1 bit = '1'
	mov ah, 9h
	int 21h

skok4:
	xor ax, ax
	xor bx, bx		 ; Reset rejestr�w
	xor cx, cx
	;xor dx, dx
	mov bx, [wejscie]      ; Wstawienie warto�ci wej�ciowej do rejestru bx
	mov cx,15	       ; Licznik p�tli na 15 (bez wliczania znaku na starcie)
	shl bx, 1	       ; Przestawienie rejestru bx o pozycje w lewo (ze wzgl�du na bit znaku)
binary1:
	push cx
	rcl bx,1	       ; Obr�t z zachowaniem skrajnej lewej warto�ci do flagi carry
	jc binary2	       ; Skok do binary2 jezeli flaga carry = 1
	mov dl,'0'	       ; Wstawienie do rejestru "dl" warto�ci 0, gdy carry flag = 0
	jmp binary3	       ; Omini�cie binary2
binary2:
	mov dl,'1'	       ; Ustawienie '1' w rejestrze "dl", gdy carry flag = 1
binary3:
	mov ah, 2	       ; Wy�wietlenie znaku z rejestru 'dl' na ekran
	int 21h
	pop cx		       
	loop binary1

	MOV dl, 10	       ; Nast�pna linia, powr�t carriage
	MOV ah, 02h
	INT 21h
	MOV dl, 13
	MOV ah, 02h
	INT 21h

  ;====== WYJSCIE OSEMKOWE ======

	mov dx, txt3	       ; [oct] =
	mov ah, 9h
	int 21h

	cmp [znak], 0
	je skok5
	mov dx, znak2	       ; Dodanie znaku minusa, je�eli 1 bit = '1'
	mov ah, 9h
	int 21h
skok5:
	xor ax, ax
	xor bx, bx	       ; Reset rejestr�w
	xor cx, cx

	mov ax, [wejscie]  ; 1 cyfra (znaku) - resetowanie bitu
	shl ax, 1	    ; 1 pozycja w lewo
	shr ax, 16	    ; 16 pozycji w prawo
	add al, 48	    ; suma al i '0'
       ; wysw_znak al
	xor ax, ax
	mov ax, [wejscie]  ; Pierwsza trojka bitow
	shl ax, 1	   ; 1 pozycja w lewo
	shr ax, 13	   ; 13 pozycji w prawo
	add al, 48	   ; Zamiane na kod ascii (+'0')
	mov dl, al	   ; Wy�wietlenie znaku
	mov ah, 2
	int 21h

	mov ax, [wejscie] ; Druga trojka bitow
	shl ax, 4
	shr ax, 13
	add al, 48
	mov dl, al
	mov ah, 2
	int 21h

	mov ax, [wejscie] ; Trzecia trojka bitow
	shl ax, 7
	shr ax, 13
	add al, 48
	mov dl, al
	mov ah, 2
	int 21h

	mov ax, [wejscie] ; Czwarta trojka bitow
	shl ax, 10
	shr ax, 13
	add al, 48
	mov dl, al
	mov ah, 2
	int 21h

	mov ax, [wejscie] ; Piata trojka bitow
	and al, 7	   ; Mno�enie logiczna rejestru al i '0000 0111'
	add al, 48
	mov dl, al
	mov ah, 2
	int 21h

	MOV dl, 10
	MOV ah, 02h	   ; Nast�pna linia, powr�t carriage
	INT 21h
	MOV dl, 13
	MOV ah, 02h
	INT 21h

;====== WYJSCIE DECYMALNE ======

	mov dx, txt4
	mov ah, 9h	   ; [dec] =
	int 21h

	cmp [znak], 0
	je skok6
	mov dx, znak2	     ; Dodanie znaku minusa, je�eli 1 bit = '1'
	mov ah, 9h
	int 21h
skok6:
	xor ax, ax
	xor bx, bx
	xor cx, cx

	mov ax, [wejscie]
	mov cx, 0
	mov dx, 0
dzielenie:
	cmp ax, 0	     ; Sprawd�, czy jest co dzieli�
	je wypis_dec	     ; Je�eli ax = 0 to skok do sekcji wypisywania
	mov bx, 10	     ; Dzielnik = 10
	div bx		     ; Dzielenie (ax = wynik; dx = reszta)
	push dx 		  ; Wrzucenie reszty do stosu, (ax = wynik; dx = reszta)
	inc cx			  ; Zwi�kszenie licznika dziele�
	xor dx, dx		  ; Reset warto�ci rejestru dx
	jmp dzielenie		  ; Powr�t na pocz�tek p�tli
wypis_dec:
	cmp cx, 0	     ; Sprawd�, czy zosta�o wykonane jakie� dzielenie (cx > 0)
	je koniec_dec	     ; Je�eli nie to wyj�cie z programu
	pop dx		     ; �ci�gni�cie rejestru ze stosu
	add dx,30h	     ; +'0'
	mov ah,02h	     ; Wy�wietlenie znaku
	int 21h
	dec cx		     ; Dekrementacja licznika dziele� o jeden
	jmp wypis_dec	     ; Skok do pocz�tku wypisywania
koniec_dec:

	MOV dl, 10
	MOV ah, 02h	      ; Nast�pnia linia, powr�t carriage
	INT 21h
	MOV dl, 13
	MOV ah, 02h
	INT 21h

;====== WYJSCIE HEX ======

	mov dx, txt5
	mov ah, 9h	; [hex] =
	int 21h

	cmp [znak], 0
	je skok7
	mov dx, znak2	    ; Dodanie znaku minusa, je�eli 1 bit = '1'
	mov ah, 9h
	int 21h
skok7:
	xor ax, ax
	xor bx, bx
	xor cx, cx
; 1 cyfra
	mov ax, [wejscie]
	shr ax, 12	  ; Przesuni�cie 4 skrajnych lewych bit�w na praw� stron� rejestru "ax"
	cmp al, 10	  ; Por�wnanie rejestru "al" z 10
	jb hex1 	  ; Jezeli < 10 to mamy do czynienia z cyframi ( 1-9 ), skok do hex1
	add al, 55	; w przeciwnym wypadku dodanie 55 ascii (65 = 'A')
	jmp hex2	; i skok do hex2

hex1:
	add al, 30h    ; +'0'
hex2:
	mov dl, al
	mov ah, 2      ; Wy�wietl warto��
	int 21h
; 2 cyfra
	mov ax, [wejscie]
	shl ax, 4	; Przesuni�cie na pocz�tku o 4 pozycje w lewo (zerowanie skrajnych bit�w)
	shr ax, 12
	cmp al, 10
	jb hex3
	add al, 55
	jmp hex4

hex3:
	add al, 30h
hex4:
	mov dl, al
	mov ah, 2
	int 21h
; 3 cyfra
	mov ax, [wejscie]
	shl ax, 8
	shr ax, 12
	cmp al, 10
	jb hex5
	add al, 55
	jmp hex6

hex5:
	add al, 30h
hex6:
	mov dl, al
	mov ah, 2
	int 21h
; 4 cyfra
	mov ax, [wejscie]
	and al, 0Fh	  ; Resetowanie 12 najstarszych bit�w za pomoc� mno�enia logicznego z warto�ci� "0000 0000 0000 1111"
	cmp al, 10
	jb hex7
	add al, 55
	jmp hex8

hex7:
	add al, 30h
hex8:
	mov dl, al
	mov ah, 2
	int 21h

;============= KONIEC =============

koniec_prog:
	mov ah, 4Ch	; Zako�czenie programu
	int 21h

segment dane
	txt1 db 'Linia polecen: ','$'	 ; TEKST WEJ�CIOWY
	txt2 db '[bin] = ', '$'        ; BINARNIE
	txt3 db '[oct] = ', '$'        ; �SEMKOWO
	txt4 db '[dec] = ', '$'        ; DECYMALNIE
	txt5 db '[hex] = ', '$'        ; HEKSADECYMALNIE
	wejscie dw 0		       ; WARTO�� WEJ�CIOWA
	znak dw 0		       ; SPRAWDZANIE ZNAKU
	znak2 db '-', '$'	       ; ZNAK MINUSA DO WY�WIETLANIA