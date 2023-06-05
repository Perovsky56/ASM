; dos_macros

;macros:
; clrscr			 - wyczyœæ okno
; pob_znak			 - pobierz 1 znak ASCII bez echa (po wykonaniu makra znak znajduje siê w rejestrze AL)
; pob_znak_ECHO 		 - pobierz 1 znak ASCII z echem (po wykonaniu makra znak znajduje siê w rejestrze AL)
; ustaw_kursor wiersz, kolumna	 - ustaw kursor na pozycji 'wiersz','kolumna'
; wyswietl txt			 - wyœwietl zmienn¹ tekstow¹ o nazwie podanej jako argument
; wysw_znak znak_ASCII		 - wyœwietla 1 znak ASCII ze zmiennej podanej jako argument
; end_prog			 - koñczy program


;DEFINICJE MACRO
;-----------------------------------------------------------------------------------------------------
;	clrscr
;-----------------------------------------------------------------------------------------------------
macro clrscr
{
	mov ah,0
	mov al,3
	int 10h
}


;-----------------------------------------------------------------------------------------------------
;	ustaw_kursor
;-----------------------------------------------------------------------------------------------------
macro ustaw_kursor wiersz, kolumna
{
	mov ah,2
	mov bh,0
	mov dl,kolumna
	mov dh,wiersz
	int 10h
}


;-----------------------------------------------------------------------------------------------------
;	pob_znak_ECHO
; out:	AL - kod ASCII
;-----------------------------------------------------------------------------------------------------
macro pob_znak_ECHO
{
	mov ah,1
	int 21h
}

;-----------------------------------------------------------------------------------------------------
;	wysw_znak_ASCII
;-----------------------------------------------------------------------------------------------------
macro wysw_znak znak_ASCII
{
	mov dl, znak_ASCII
	mov ah,2
	int 21h
}

;-----------------------------------------------------------------------------------------------------
;	pob_znak
; out:	AL - kod ASCII
;-----------------------------------------------------------------------------------------------------
macro pob_znak
{
	mov ah,7
	int 21h
}

;-----------------------------------------------------------------------------------------------------
;	wyswietl
; txt - adres zmiennej tekstowej do wyœwietlenia - musi byæ zakoñczona $
;-----------------------------------------------------------------------------------------------------
macro wyswietl txt
{
	mov ah,9
	mov dx, txt
	int 21h
}


;-----------------------------------------------------------------------------------------------------
;	end_prog
;-----------------------------------------------------------------------------------------------------
macro end_prog
{
	mov ah,4Ch
	int 21h
}
