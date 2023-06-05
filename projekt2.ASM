format MZ
entry main:start
stack 100h

include 'dos_macros.inc'

segment main
start:
	mov ax, dane
	mov ds, ax
	clrscr

;pob 1 zmiennej  // 'a'
	ustaw_kursor 1,1
	wyswietl txt1
	mov cx, 6
	mov si, 5
petla1:
	call pob_hex
	mov [zm1+si], al
	dec si
	loop petla1
;end 1 zmiennej

;pob 2 zmiennej  // 'b'
	ustaw_kursor 2,1
	wyswietl txt2
	mov cx, 6
	mov si, 5
petla2:
	call pob_hex
	mov [zm2+si], al
	dec si
	loop petla2
;end 2 zmiennej

;pob 3 zmiennej // 'c'
	ustaw_kursor 3,1
	wyswietl txt3
	mov cx, 6
	mov si, 5
petla3:
	call pob_hex
	mov [zm3+si], al
	dec si
	loop petla3
;end 3 zmiennej

;dod a+b
	ustaw_kursor 4,1
	wyswietl txt4
	mov cx, 6
	mov si, 0
	clc
petla4:
	mov al, [zm1+si]
	mov dl, [zm2+si]
	adc al, dl
	mov byte [wyn+si], al
	inc si
	loop petla4
; wynik
	jc przepelnij

	push wyn
	call wysw_wynik
	jmp end_dod

przepelnij:
	wyswietl error
	jmp zak_prog
end_dod:


; MODULO

	ustaw_kursor 5,1
	wyswietl txt5

	xor cx, cx
	mov si, 0
skok1:
	mov al, [zm3+5]
	clc
	rcl al, 1
	jc gl_prog     ;// Spr., czy MSB dzielnika =1
	push si
	push cx        ;// Przesuniêcie dzielnika o 1 bit w lewo
   ;====mov left1
	mov cx, 6
	mov si, 0
	clc
left1:
	mov al, [zm3+si]
	rcl al, 1
	mov [zm3+si], al
	inc si
	loop left1
  ;====end mov left1
	pop cx
	pop si
	inc si	       ;// k += 1
	jmp skok1
gl_prog:		 ; si = k
	xor ax, ax
	xor bx, bx
	mov ax, word [wyn]	;   // Spr., czy dzielna >= dzielnik
	mov bx, word [zm3]
	cmp ax, bx
	jl skokc0		;   // dzielna < dzielnik => skok do C=0
	jmp skokc1

skokc0:
	clc
	push si
	push cx
   ;====mov left2
	xor dx, dx	      ; // Przesuniêcie o 1 bit w lewo wyniku, C=0
	mov cx, 6
	mov si, 0
	clc
left2:
	mov dl, [wyn2+si]
	rcl dl, 1
	mov [wyn2+si], dl
	inc si
	loop left2
  ;====end mov left2
	pop cx
	pop si
	jmp gl_cont	      ; // Skok dalej


skokc1:
	clc
	push si
	push cx
   ;====mov left3
	xor dx, dx	      ; // Przesuniêcie o 1 bit w lewo wyniku, C=1
	mov cx, 6
	mov si, 0
	clc
left3:
	mov dl, [wyn2+si]
	rcl dl, 1
	mov [wyn2+si], dl
	inc si
	loop left3
  ;====end mov left3
	pop cx
	pop si
	xor dx, dx
	mov dl, [wyn2]
	adc dl, 1b	      ; // Dodanie 1 do przesuniêtego wyniku
	mov [wyn2], dl

	push ax
	push bx
	push si
	push cx
	xor ax, ax
	xor bx, bx
	mov si, 0
	mov cx, 6
minusowanie:
	mov al, [wyn+si]       ; // dzielna -= dzielna - dzielnik
	mov bl, [zm3+si]
	sbb al, bl
	mov byte [wyn+si], al
	inc si
	loop minusowanie
	pop cx
	pop si
	pop bx
	pop ax
	jmp gl_cont	     ; // Kontynuacja


gl_cont:
	cmp si, 0	     ; // Spr., czy k=0, jeœli tak = zakoñcz program
	je gl_quit
	dec si		     ; // k -= 1
	push si
	push cx
	push ax
   ;====mov right 1	     ; // Przesuniêcie dzielnika o 1 bit w prawo
	xor ax, ax
	mov cx, 6
	mov si, 5
	clc
right1:
	mov al, [zm3+si]
	rcr al, 1
	mov [zm3+si], al
	dec si
	loop right1
  ;====end mov right 1
	pop ax
	pop cx
	pop si
	jmp gl_prog
gl_quit:
	mov word [modulo], ax	   ; // Przesuniêcie dzielnej do [modulo]
	push modulo
	call wysw_wynik

zak_prog:
	pob_znak
	end_prog


;======================= END =========================================

wysw_wynik:
    pop bp
    pop bx
    push bp
    mov cx,6
    mov si,5
petla5:
       mov al,[bx+si]
       call wysw_hex  ;si=5 -najstarszy bajt zmiennej
       dec si
       loop petla5
ret

pob_cyfr_hex:
	pob_znak
	cmp al,'0'
	jb pob_cyfr_hex
	cmp al,'9'
	jbe cyfr
	cmp al,'A'
	jb pob_cyfr_hex
	cmp al,'F'
	jbe lit_d
	cmp al,'a'
	jb pob_cyfr_hex
	cmp al,'f'
	ja pob_cyfr_hex
lit_m:	     
	push ax
	wysw_znak al   ;wyswietlenie
	pop ax
	sub al,87
	jmp ety2
lit_d:	       
	push ax
	wysw_znak al   ;wyswietlenie
	pop ax
	sub al,55
	jmp ety2
cyfr:	       
	push ax
	wysw_znak al   ;wyswietlenie
	pop ax
	sub al,30h ; 48
ety2:	       
	ret	; 4 m³odsze bity rejestru al zawieraj¹ wartoœæ
		; jednej liczby heksadecymalnej

pob_hex:
	call pob_cyfr_hex
	shl al,4
	push ax
	call pob_cyfr_hex
	pop dx
	and al,0Fh
	and dl,0F0h
	add al,dl
	ret

wysw_hex:
	push ax
	shr al,4
	cmp al,10
	jb ety4
	add al,55	; kody ascii liter
	jmp ety5
ety4:
	add al,30h
ety5:		     
	wysw_znak al

	pop ax
	and al,0Fh
	cmp al,10 
	jb ety6   
	add al,55	; kody ascii liter
	jmp ety7
ety6:
	add al,30h
ety7:		     
	wysw_znak al
	ret


segment dane
zm1	db	0, 0, 0, 0, 0, 0
zm2	db	0, 0, 0, 0, 0, 0
zm3	db	0, 0, 0, 0, 0, 0
wyn	db	0, 0, 0, 0, 0, 0
wyn2	db	0, 0, 0, 0, 0, 0
modulo	db	0, 0, 0, 0, 0, 0
txt1	db	'a = $'
txt2	db	'b = $'
txt3	db	'c = $'
txt4	db	'Wynik a+b = $'
txt5	db	'Wynik (a+b) % c = $'
error	db	'***$'


; Modulo bajtów

;skok1:
       ; xor dx, dx		    ; dx:ax
      ;  xor ax, ax
       ; xor bx, bx
       ; mov al, [wyn]
       ; mov ah, [wyn+1]
       ; mov bl, [zm3]
       ; cmp bl, 0
       ; je przepelnij
       ; mov bh, [zm3+1]
       ; cmp bh, 0
       ; je przepelnij
       ; div bx 		     ; ax = wynik; dx = reszta
       ; mov byte [wyn2], dl
       ; mov byte [wyn2+1], dh

       ; xor dx, dx		    ; dx:ax
       ; xor ax, ax
       ; xor bx, bx
       ; mov al, [wyn+2]
       ; mov ah, [wyn+3]
       ;  mov bl, [zm3+2]
       ; cmp bl, 0
       ; je przepelnij
       ; mov bh, [zm3+3]
       ; cmp bh, 0
       ; je przepelnij
       ; div bx 		     ; ax = wynik; dx = reszta
       ; mov byte [wyn2+2], dl
       ; mov byte [wyn2+3], dh

       ; xor dx, dx		    ; dx:ax
       ; xor ax, ax
       ; xor bx, bx
       ; mov al, [wyn+4]
       ; mov ah, [wyn+5]
       ; mov bl, [zm3+4]
       ; cmp bl, 0
       ; je przepelnij
       ; mov bh, [zm3+5]
       ; cmp bh, 0
       ; je przepelnij
       ; div bx 		     ; ax = wynik; dx = reszta
       ; mov byte [wyn2+4], dl
       ; mov byte [wyn2+5], dh
       ; inc si
       ; jmp skok1