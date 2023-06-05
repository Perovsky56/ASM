format MZ
entry main:start
stack 100h

segment main
start:
	mov ax, dane
	mov ds, ax

	mov ah, 0 ; clear screen
	mov al, 3
	int 10h

	mov ah, 2 ; ustaw kursor
	mov bh, 0
	mov dl, 2 ; kolumna
	mov dh, 10 ; wiersz
skok3:
	mov ah, 1 ; pobieranie znaku // al - znak w kodzie ascii
	int 21h

	cmp al, 1Bh
	je skok7

	cmp al, 65
	jb skok3
	cmp al, 90
	ja skok3

	mov dl, al ; wysw_znak ASCII
	mov ah, 2
	int 21h

	xor bx, bx
	mov bl, [licznik]
	inc bl
	mov [licznik], bl

	jmp skok3
skok7:
	mov ah, 2 ; ustaw kursor
	mov bh, 0
	mov dl, 2 ; kolumna
	mov dh, 11 ; wiersz

	mov ah, 9
	mov dx, txt1
	int 21h

	xor dx, dx
	mov dl, [licznik]
	add dx,30h	     ; +'0'
	mov ah,02h	     ; Wyœwietlenie znaku
	int 21h

	mov ah, 4Ch
	int 21h

segment dane
	licznik db 0
	txt1	db 'liczba liter: $'